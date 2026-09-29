(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  const normalizedText = (element) => (element?.textContent || "").trim().toLocaleLowerCase();
  const posts = new Set();
  const accountModules = new Set();

  const scan = (root) => {
    const labels = root.querySelectorAll?.("article span, article h2, article h3") || [];
    for (const label of labels) {
      const text = normalizedText(label);
      if (text === "suggested for you" || text === "suggested posts" || text === "because you watched") {
        const container = label.closest("article") || label.parentElement;
        if (container) posts.add(container);
      }
    }

    const headings = root.querySelectorAll?.('main h2, main h3, main [role="heading"]') || [];
    for (const heading of headings) {
      const text = normalizedText(heading);
      if (text === "suggested for you" || text === "suggested accounts") {
        const container = heading.closest("section") || heading.parentElement;
        if (container && !container.closest("article")) accountModules.add(container);
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
    const currentPosts = connected(posts);
    const currentAccounts = connected(accountModules);
    if (runtime.config.hideSuggestedPosts) {
      for (const post of currentPosts) runtime.hide(post, "instagram.feed.suggestions");
    }
    if (runtime.config.hideRecommendedAccounts) {
      for (const module of currentAccounts) runtime.hide(module, "instagram.feed.accounts");
    }

    const all = new Set([...currentPosts, ...currentAccounts]);
    const blockable = [...all].filter((element) => !element.dataset.nblockerHidden).length;
    runtime.updateMetrics("instagram.feed.suggestions", {
      suggested: all.size,
      blockable
    });
  };

  runtime.register("instagram.feed.suggestions", apply);
  runtime.registerAction("blockDetectedItems", () => {
    scan(document);
    let affected = 0;
    for (const element of new Set([...connected(posts), ...connected(accountModules)])) {
      if (!element.dataset.nblockerHidden) affected += 1;
      runtime.hide(element, "instagram.feed.suggestions.manual");
    }
    apply(document);
    return affected;
  });
})();
