(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("instagram.appearance.grayscale", () => {
    const enabled = Boolean(runtime.config.filteringEnabled);
    document.documentElement.classList.toggle("nblocker-grayscale", enabled && Boolean(runtime.config.grayscale));
    document.documentElement.classList.toggle("nblocker-media-grayscale", enabled && Boolean(runtime.config.grayscaleMediaOnly));
  });
})();
