(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  window.NBlocker?.register("instagram.reels.entries", (root) => {
    if (!runtime.config.filteringEnabled) return;
    const anchors = root.querySelectorAll?.('a[href^="/reel/"], a[href^="/reels/"]') || [];
    for (const anchor of anchors) {
      const inNavigation = anchor.closest('nav, [role="navigation"]');
      const inFeedArticle = anchor.closest("article");
      if (inNavigation && runtime.config.hideReelsTab) {
        runtime.hide(anchor.closest('a, [role="link"]') || anchor, "instagram.reels.tab");
      } else if (inFeedArticle && runtime.config.hideReelsInFeed) {
        runtime.hide(inFeedArticle, "instagram.reels.feed");
      } else if (!inNavigation && !inFeedArticle && runtime.config.hideReelsOnProfiles) {
        runtime.hide(anchor, "instagram.reels.profile");
      }
    }
    const labeled = root.querySelectorAll?.('[aria-label*="Reels" i]') || [];
    for (const element of labeled) {
      if (runtime.config.hideReelsTab && element.closest('nav, [role="navigation"]')) {
        runtime.hide(element.closest('a, [role="link"]') || element, "instagram.reels.tab");
      }
    }

    const reelMedia = new Set();
    if (/^\/(reel|reels)(\/|$)/i.test(location.pathname)) {
      for (const media of root.querySelectorAll?.("video, audio") || []) reelMedia.add(media);
    }
    for (const anchor of anchors) {
      for (const media of anchor.closest("article")?.querySelectorAll("video, audio") || []) reelMedia.add(media);
    }
    for (const media of reelMedia) {
      if (runtime.config.disableReelAutoplay) {
        media.autoplay = false;
        media.removeAttribute("autoplay");
      }
      if (runtime.config.muteReelMedia) media.muted = true;
    }
  });
})();
