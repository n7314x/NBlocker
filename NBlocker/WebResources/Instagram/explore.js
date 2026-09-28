(() => {
  "use strict";
  window.NBlocker?.register("instagram.explore.entries", (root) => {
    const entries = root.querySelectorAll?.('a[href^="/explore"], [aria-label="Explore" i]') || [];
    for (const entry of entries) {
      window.NBlocker.hide(entry.closest('a, [role="link"]') || entry, "instagram.explore.entries");
    }
  });
})();
