(() => {
  "use strict";
  if (!window.NBlocker) return;
  const reportReady = () => {
    window.NBlocker.report("ready", { platform: window.NBlocker.platform });
  };
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", reportReady, { once: true });
  } else {
    reportReady();
  }
})();
