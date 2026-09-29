(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("youtube.comments.hidden", (root) => {
    if (!runtime.config.filteringEnabled || runtime.config.showComments) return;
    for (const comments of root.querySelectorAll?.("ytm-comment-section-renderer, ytm-comments-entry-point-header-renderer") || []) {
      window.NBlocker.hide(comments, "youtube.comments.hidden");
    }
  });
})();
