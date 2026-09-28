(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("instagram.appearance.grayscale", () => {
    document.documentElement.classList.toggle("nblocker-grayscale", Boolean(runtime.config.grayscale));
    document.documentElement.classList.toggle("nblocker-media-grayscale", Boolean(runtime.config.grayscaleMediaOnly));
  });
})();
