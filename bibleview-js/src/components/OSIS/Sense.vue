<template>
  <div class="sense" :class="{ structural: isStructural }">
    <span v-if="displayMarker" class="sense-marker">{{ displayMarker }}</span>
    <div ref="root" class="sense-content"><slot/></div>
  </div>
</template>

<script setup lang="ts">
import {computed, onMounted, onUpdated, ref} from "vue";

const props = defineProps<{n?: string}>();

const root = ref<HTMLElement | null>(null);
const isStructural = ref(false);
const displayMarker = computed(() => {
    const marker = props.n?.trim();
    if (!marker) return "";
    return /[.]$/.test(marker) ? marker : `${marker}.`;
});

function normalizeSenseContent() {
    const element = root.value;
    if (!element) return;

    let hasDirectText = false;

    for (const node of [...element.childNodes]) {
        if (node.nodeType !== Node.TEXT_NODE) continue;

        const original = node.textContent ?? "";
        const normalized = original.replace(/^\s*\.\s*/, "");

        if (normalized.trim().length > 0) {
            hasDirectText = true;
            if (normalized !== original) {
                node.textContent = normalized;
            }
            continue;
        }

        node.textContent = "";
    }

    isStructural.value = !hasDirectText && element.children.length > 0;
}

onMounted(normalizeSenseContent);
onUpdated(normalizeSenseContent);
</script>

<style scoped>
.sense {
  display: flex;
  align-items: flex-start;
  gap: 0.45em;
  margin-inline-start: 1.1em;
  margin-top: 0.15em;
}

.sense.structural {
  margin-inline-start: 0;
  margin-top: 0;
}

.sense-marker {
  flex: 0 0 auto;
  min-width: 1.1em;
  text-align: right;
  opacity: 0.75;
}

.sense-content {
  min-width: 0;
}
</style>
