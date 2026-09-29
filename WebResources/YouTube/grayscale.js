(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("youtube.appearance.grayscale", () => {
    const enabled = Boolean(runtime.config.filteringEnabled);
    document.documentElement.classList.toggle("nblocker-grayscale", enabled && Boolean(runtime.config.grayscale));
    document.documentElement.classList.toggle("nblocker-hide-thumbnails", enabled && Boolean(runtime.config.hideThumbnails));
  });
})();
