(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("instagram.feed.hidden", (root) => {
    if (!runtime.config.filteringEnabled || !runtime.config.hideFeed || location.pathname !== "/") return;
    for (const article of root.querySelectorAll?.("main article") || []) {
      window.NBlocker.hide(article, "instagram.feed.hidden");
    }
  });
})();
