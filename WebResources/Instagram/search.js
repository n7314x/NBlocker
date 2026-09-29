(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  const reservedPaths = new Set([
    "accounts", "direct", "explore", "reel", "reels", "stories", "p"
  ]);

  runtime.register("instagram.search.results", (root) => {
    if (!runtime.config.filteringEnabled) return;
    if (!location.pathname.startsWith("/explore")) return;
    const links = root.querySelectorAll?.('main a[href^="/"]') || [];
    for (const link of links) {
      let path;
      try {
        path = new URL(link.href, location.href).pathname;
      } catch (_) {
        continue;
      }
      if (runtime.config.blockPostSearch && /^\/(p|reel|reels)\//i.test(path)) {
        runtime.hide(link.closest('article, [role="listitem"]') || link, "instagram.search.posts");
        continue;
      }
      const parts = path.split("/").filter(Boolean);
      const first = parts[0]?.toLocaleLowerCase();
      const looksLikeAccount = first && !reservedPaths.has(first) && parts.length === 1;
      if (!runtime.config.allowAccountSearch && looksLikeAccount) {
        runtime.hide(link.closest('[role="listitem"]') || link, "instagram.search.accounts");
      }
    }
  });
})();
