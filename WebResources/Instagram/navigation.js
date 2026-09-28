(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime || window.__nblockerInstagramNavigation) return;
  window.__nblockerInstagramNavigation = true;

  document.addEventListener("click", (event) => {
    const anchor = event.target instanceof Element ? event.target.closest("a[href]") : null;
    if (!anchor) return;
    try {
      const url = new URL(anchor.href, location.href);
      const isReel = /^\/(reel|reels)(\/|$)/i.test(url.pathname);
      const isCurrentlyViewingReel = /^\/(reel|reels)(\/|$)/i.test(location.pathname);
      const blocksContinuation = runtime.config.blockReelChaining &&
        isCurrentlyViewingReel && url.pathname !== location.pathname;
      if (isReel && (runtime.config.blockReelRoutes || blocksContinuation)) {
        event.preventDefault();
        event.stopImmediatePropagation();
        runtime.report("navigationPrevented", { route: "reel" });
      }
    } catch (_) {
      runtime.report("ruleError", { rule: "instagram.navigation" });
    }
  }, true);
})();
