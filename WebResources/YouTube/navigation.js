(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime || window.__nblockerYouTubeNavigation) return;
  window.__nblockerYouTubeNavigation = true;

  document.addEventListener("click", (event) => {
    const anchor = event.target instanceof Element ? event.target.closest("a[href]") : null;
    if (!anchor) return;
    try {
      if (!runtime.config.filteringEnabled) return;
      const url = new URL(anchor.href, location.href);
      const isShort = /^\/shorts(\/|$)/i.test(url.pathname);
      const isCurrentlyViewingShort = /^\/shorts(\/|$)/i.test(location.pathname);
      const blocksContinuation = runtime.config.preventShortChaining &&
        isCurrentlyViewingShort && url.pathname !== location.pathname;
      if (isShort && (runtime.config.blockShortRoutes || blocksContinuation)) {
        event.preventDefault();
        event.stopImmediatePropagation();
        runtime.report("navigationPrevented", { route: "short" });
      }
    } catch (_) {
      runtime.report("ruleError", { rule: "youtube.navigation" });
    }
  }, true);
})();
