(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("youtube.home.recommendations", (root) => {
    if (!runtime.config.filteringEnabled ||
        (!runtime.config.hideHomeFeed && !runtime.config.hideHomeRecommendations) ||
        location.pathname !== "/") return;
    for (const grid of root.querySelectorAll?.("ytm-rich-grid-renderer, ytm-browse ytm-section-list-renderer") || []) {
      window.NBlocker.hide(grid, "youtube.home.recommendations");
    }
  });
})();
