(() => {
  "use strict";
  window.NBlocker?.register("youtube.comments.hidden", (root) => {
    for (const comments of root.querySelectorAll?.("ytm-comment-section-renderer, ytm-comments-entry-point-header-renderer") || []) {
      window.NBlocker.hide(comments, "youtube.comments.hidden");
    }
  });
})();
