(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  runtime.register("youtube.shorts.entries", (root) => {
    if (!runtime.config.filteringEnabled) return;
    if (runtime.config.hideShortsTab) {
      const links = root.querySelectorAll?.('ytm-pivot-bar-item-renderer a[href^="/shorts"], nav a[href^="/shorts"], a[aria-label="Shorts" i]') || [];
      for (const link of links) {
        runtime.hide(link.closest("ytm-pivot-bar-item-renderer, a") || link, "youtube.shorts.tab");
      }
    }

    if (runtime.config.hideShortsShelves) {
      for (const shelf of root.querySelectorAll?.("ytm-rich-section-renderer, ytm-reel-shelf-renderer") || []) {
        const heading = shelf.querySelector('h2, h3, [role="heading"]');
        const label = (heading?.textContent || shelf.getAttribute("aria-label") || "").trim().toLocaleLowerCase();
        if (label === "shorts" || shelf.matches("ytm-reel-shelf-renderer")) {
          runtime.hide(shelf, "youtube.shorts.shelf");
        }
      }
    }
  });
})();
