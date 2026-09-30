(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("instagram.explore.entries", (root) => {
    if (!runtime.config.filteringEnabled || !runtime.config.hideExplore) return;

    const navigation = runtime.instagramNavigation;
    const entries = root.querySelectorAll?.([
      'a[href^="/explore"]',
      '[aria-label="Explore" i]',
      '[title="Explore" i]'
    ].join(", ")) || [];
    for (const entry of entries) {
      if (navigation?.isSearchControl(entry)) continue;
      if (!navigation?.isExploreControl(entry)) continue;
      const control = entry.closest('a, [role="link"], button') || entry;
      if (!navigation.hideItem(control, "instagram.explore.entries")) {
        runtime.hide(control, "instagram.explore.entries");
      }
    }

    const isExploreLanding = /^\/explore\/?$/i.test(location.pathname);
    const parameters = new URLSearchParams(location.search);
    const hasSearchRoute = /^\/explore\/search(?:\/|$)/i.test(location.pathname) ||
      ["q", "query", "search"].some((key) => parameters.has(key));
    if (!isExploreLanding || hasSearchRoute) return;

    const searchInputs = document.querySelectorAll([
      'input[type="search"]',
      'input[role="searchbox"]',
      'input[aria-label*="Search" i]',
      'input[placeholder*="Search" i]'
    ].join(", "));
    const hasSearchText = [...searchInputs].some((input) => String(input.value || "").trim().length > 0);
    if (hasSearchText) return;

    const discoveryLinks = root.querySelectorAll?.([
      'a[href^="/p/"]',
      'a[href^="/reel/"]',
      'a[href^="/reels/"]'
    ].join(", ")) || [];
    for (const link of discoveryLinks) {
      if (!link.closest("main")) continue;
      runtime.hide(
        link.closest('article, [role="listitem"]') || link,
        "instagram.explore.discovery"
      );
    }
  });
})();
