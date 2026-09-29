(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;
  const feedAds = new Set();
  const storyAds = new Set();

  const scan = (root) => {
    const candidates = root.querySelectorAll?.("article span, article h2, article h3, main span") || [];
    for (const candidate of candidates) {
      const label = (candidate.textContent || "").trim().toLocaleLowerCase();
      if (label !== "sponsored" && label !== "paid partnership") continue;
      const article = candidate.closest("article");
      if (article) {
        feedAds.add(article);
      } else if (/^\/stories(\/|$)/i.test(location.pathname)) {
        const container = candidate.closest('[role="dialog"], main > div, section') || candidate.parentElement;
        if (container) storyAds.add(container);
      }
    }
  };

  const connected = (elements) => {
    for (const element of elements) {
      if (!element.isConnected) elements.delete(element);
    }
    return [...elements];
  };

  const apply = (root = document) => {
    scan(root);
    const currentFeedAds = connected(feedAds);
    const currentStoryAds = connected(storyAds);
    const filteringEnabled = Boolean(runtime.config.filteringEnabled);
    if (filteringEnabled && runtime.config.hideSponsoredPosts) {
      for (const ad of currentFeedAds) runtime.hide(ad, "instagram.feed.ads");
    }
    if (filteringEnabled && runtime.config.hideStoryAds) {
      for (const ad of currentStoryAds) runtime.hide(ad, "instagram.story.ads");
    }
    const all = new Set([...currentFeedAds, ...currentStoryAds]);
    const blockable = [...all].filter((element) => !element.dataset.nblockerHidden).length;
    runtime.updateMetrics("instagram.feed.ads", { ads: all.size, blockable });
  };

  runtime.register("instagram.feed.ads", apply);
  runtime.registerAction("blockDetectedItems", () => {
    scan(document);
    let affected = 0;
    for (const element of new Set([...connected(feedAds), ...connected(storyAds)])) {
      if (!element.dataset.nblockerHidden) affected += 1;
      runtime.hide(element, "instagram.ads.manual");
    }
    apply(document);
    return affected;
  });
})();
