(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  runtime.register("instagram.stories.entries", (root) => {
    if (!runtime.config.filteringEnabled || !runtime.config.hideStories) return;
    const links = root.querySelectorAll?.('a[href^="/stories/"]') || [];
    for (const link of links) {
      const container = link.closest('li, [role="listitem"]') || link;
      runtime.hide(container, "instagram.stories.entries");
    }
  });
})();
