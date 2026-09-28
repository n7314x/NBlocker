(() => {
  "use strict";
  if (!window.NBlocker) return;
  window.NBlocker.platform = "youtube";
  if (window.NBlocker.config.reduceWebMotion) {
    document.documentElement.classList.add("nblocker-reduce-motion");
  }
})();
