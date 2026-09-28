(() => {
  "use strict";
  window.NBlocker?.register("instagram.feed.hidden", (root) => {
    if (location.pathname !== "/") return;
    for (const article of root.querySelectorAll?.("main article") || []) {
      window.NBlocker.hide(article, "instagram.feed.hidden");
    }
  });
})();
