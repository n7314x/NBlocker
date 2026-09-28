(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime || window.__nblockerObserverInstalled) return;
  window.__nblockerObserverInstalled = true;

  const start = () => {
    if (!document.documentElement) return;
    const observer = new MutationObserver((records) => {
      const parents = new Set();
      let additionCount = 0;
      for (const record of records) {
        additionCount += record.addedNodes.length;
        if (record.addedNodes.length > 0 && record.target instanceof Element) {
          parents.add(record.target);
        }
      }
      if (additionCount > 24 || parents.size > 8) {
        runtime.schedule(document);
      } else {
        for (const parent of parents) runtime.schedule(parent);
      }
    });
    observer.observe(document.documentElement, { childList: true, subtree: true });
    runtime.schedule(document);
  };

  let lastY = window.scrollY;
  let scrollQueued = false;
  addEventListener("scroll", () => {
    if (scrollQueued) return;
    scrollQueued = true;
    requestAnimationFrame(() => {
      const nextY = window.scrollY;
      if (Math.abs(nextY - lastY) > 18) {
        runtime.report("scroll", { direction: nextY > lastY ? "down" : "up" });
        lastY = nextY;
      }
      scrollQueued = false;
    });
  }, { passive: true });

  addEventListener("popstate", () => runtime.schedule(document));
  addEventListener("pageshow", () => runtime.schedule(document));
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", start, { once: true });
  } else {
    start();
  }
})();
