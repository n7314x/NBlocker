(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("youtube.appearance.grayscale", () => {
    document.documentElement.classList.toggle("nblocker-grayscale", Boolean(runtime.config.grayscale));
    document.documentElement.classList.toggle("nblocker-hide-thumbnails", Boolean(runtime.config.hideThumbnails));
  });
})();
