(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime) return;

  runtime.register("youtube.search.suggestions", (root) => {
    const selectors = [
      "ytm-search-suggestions-section",
      "ytm-search-suggestion-renderer",
      'ytm-searchbox [role="listbox"] [role="option"]',
      '[role="search"] [role="listbox"] [role="option"]'
    ].join(",");
    for (const suggestion of root.querySelectorAll?.(selectors) || []) {
      runtime.hide(suggestion, "youtube.search.suggestions");
    }
  });
})();
