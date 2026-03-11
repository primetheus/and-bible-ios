// TiltScrollService.swift — CoreMotion pitch-based auto-scroll (iOS only)
//
// Uses device pitch angle to scroll Bible text forward, matching Android's
// PageTiltScrollControl.kt behavior. Calibrates on start and re-calibrates
// on touch events.

#if os(iOS)
import CoreMotion

/**
 Converts device pitch changes into forward scrolling callbacks for tilt-scroll behavior.

 The service mirrors Android's pitch-based auto-scroll behavior. It calibrates a neutral device
 angle on start, ignores small movements inside a dead zone, and emits only forward-scroll deltas
 when the device tilts past that threshold.

 Data dependencies:
 - `CMMotionManager` supplies device-motion updates on the main queue
 - `onScroll` is set by the owning view/controller to translate computed pixel deltas into actual
   scrolling

 Side effects:
 - `start()` begins Core Motion updates and resets calibration state
 - `stop()` terminates motion updates and clears active/calibrated state
 - `calibrate()` forces the next motion sample to become the new neutral reference angle

 - Important: Motion callbacks are requested on `.main`, so `onScroll` executes on the main queue.
 */
@Observable
class TiltScrollService {
    /// Core Motion manager used to access device-motion samples.
    private let motionManager = CMMotionManager()

    /// Neutral pitch angle established during the latest calibration sample.
    private var referenceAngle: Double = 0

    /// Whether `referenceAngle` has been established from a live motion sample.
    private var isCalibrated = false

    /// Whether the service is currently receiving device-motion updates.
    private(set) var isActive = false

    /// Minimum pitch delta before tilt scroll begins.
    private let deadZoneDegrees: Double = 2.0

    /// Maximum pitch delta used when normalizing scroll speed.
    private let maxDegrees: Double = 45.0

    /// Minimum emitted scroll delta in pixels.
    private let baseScrollPixels: Int = 2

    /// Callback invoked on the main queue with pixel count to scroll.
    var onScroll: ((Int) -> Void)?

    /**
     Starts device-motion updates and resets tilt calibration.

     Side effects:
     - marks the service active and clears calibration so the next sample sets a new reference angle
     - starts device-motion delivery on the main queue at approximately 30 Hz

     Failure modes:
     - returns without side effects when device motion is unavailable on the current device
     */
    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        isActive = true
        isCalibrated = false
        motionManager.deviceMotionUpdateInterval = 1.0 / 30 // 30 Hz
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            self.handleMotionUpdate(motion)
        }
    }

    /**
     Stops device-motion updates and clears active/calibration state.
     */
    func stop() {
        motionManager.stopDeviceMotionUpdates()
        isActive = false
        isCalibrated = false
    }

    /**
     Re-calibrates so the next motion sample becomes the neutral "no scroll" angle.
     */
    func calibrate() {
        isCalibrated = false
    }

    /**
     Processes one motion sample and emits a forward-scroll delta when tilt exceeds the dead zone.

     - Parameter motion: Device-motion sample containing the current pitch angle.

     Side effects:
     - captures the current pitch as `referenceAngle` during the first sample after calibration
     - invokes `onScroll` with a pixel delta when the device is tilted forward beyond the dead zone

     Failure modes:
     - returns without emitting scroll when calibration has not been established yet
     - returns without emitting scroll for reverse tilt or tilt inside the dead zone
     */
    private func handleMotionUpdate(_ motion: CMDeviceMotion) {
        let pitchDegrees = motion.attitude.pitch * 180.0 / .pi

        if !isCalibrated {
            referenceAngle = pitchDegrees
            isCalibrated = true
            return
        }

        let delta = pitchDegrees - referenceAngle

        if abs(delta) < deadZoneDegrees { return }

        guard delta > 0 else { return }

        let normalizedSpeed = min((delta - deadZoneDegrees) / (maxDegrees - deadZoneDegrees), 1.0)
        let pixels = Int(Double(baseScrollPixels) + normalizedSpeed * 8.0)
        onScroll?(pixels)
    }
}
#endif
