(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  runtime.register("instagram.feed.suggestions", (root) => {
    const candidates = root.querySelectorAll?.("article span, article h2, article h3") || [];
    for (const candidate of candidates) {
      const label = (candidate.textContent || "").trim().toLocaleLowerCase();
      const isSponsored = label === "sponsored";
      const isSuggested = label === "suggested for you" || label === "suggested posts";
      if ((isSponsored && runtime.config.hideSponsoredPosts) ||
          (isSuggested && runtime.config.hideSuggestedPosts)) {
        runtime.hide(candidate.closest("article") || candidate.parentElement, "instagram.feed.suggestions");
      }
    }

    if (runtime.config.hideRecommendedAccounts) {
      const headings = root.querySelectorAll?.('main h2, main h3, main [role="heading"]') || [];
      for (const heading of headings) {
        const label = (heading.textContent || "").trim().toLocaleLowerCase();
        if (label === "suggested for you" || label === "suggested accounts") {
          runtime.hide(heading.closest("section") || heading.parentElement, "instagram.feed.accounts");
        }
      }
    }
  });
})();
