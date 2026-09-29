(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("instagram.explore.entries", (root) => {
    if (!runtime.config.filteringEnabled || !runtime.config.hideExplore) return;
    const entries = root.querySelectorAll?.('a[href^="/explore"], [aria-label="Explore" i]') || [];
    for (const entry of entries) {
      window.NBlocker.hide(entry.closest('a, [role="link"]') || entry, "instagram.explore.entries");
    }
  });
})();
