(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  runtime.register("youtube.watch.recommendations", (root) => {
    if (!runtime.config.filteringEnabled || location.pathname !== "/watch") return;

    if (runtime.config.hideRelatedVideos) {
      const selectors = [
        "ytm-watch-next-secondary-results-renderer",
        "ytm-related-chip-cloud-renderer",
        '[target-id*="related" i]'
      ].join(",");
      for (const related of root.querySelectorAll?.(selectors) || []) {
        runtime.hide(related, "youtube.watch.related");
      }
    }

    if (runtime.config.hideEndScreenRecommendations) {
      for (const overlay of root.querySelectorAll?.(".ytp-ce-element, .ytp-endscreen-content") || []) {
        runtime.hide(overlay, "youtube.watch.endscreen");
      }
    }
  });
})();
