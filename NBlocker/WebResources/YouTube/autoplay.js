(() => {
  "use strict";
  window.NBlocker?.register("youtube.playback.autoplay", (root) => {
    for (const media of root.querySelectorAll?.("video[autoplay], audio[autoplay]") || []) {
      media.autoplay = false;
      media.removeAttribute("autoplay");
    }
    for (const toggle of root.querySelectorAll?.('[aria-label*="Autoplay" i]') || []) {
      if (toggle.getAttribute("aria-pressed") === "true") toggle.click();
    }
  });
})();
