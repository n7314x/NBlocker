(() => {
  "use strict";
  if (window.NBlocker) return;

  const rules = new Map();
  let scheduled = false;
  const pendingRoots = new Set();

  const report = (event, payload = {}) => {
    try {
      window.webkit?.messageHandlers?.nblocker?.postMessage({ event, ...payload });
    } catch (_) {
      // Native messaging is optional while rules are inspected in a desktop browser.
    }
  };

  const apply = (root = document) => {
    for (const [id, rule] of rules) {
      try {
        rule(root);
      } catch (_) {
        report("ruleError", { rule: id });
      }
    }
  };

  window.NBlocker = {
    platform: "unknown",
    config: Object.freeze({ ...(window.__NBLOCKER_CONFIG__ || {}) }),
    register(id, rule) {
      if (typeof id !== "string" || typeof rule !== "function") return;
      rules.set(id, rule);
      this.schedule(document);
    },
    schedule(root = document) {
      if (root instanceof Document || root instanceof Element) pendingRoots.add(root);
      if (scheduled) return;
      scheduled = true;
      requestAnimationFrame(() => {
        scheduled = false;
        const roots = [...pendingRoots];
        pendingRoots.clear();
        for (const pendingRoot of roots) apply(pendingRoot);
      });
    },
    report,
    hide(element, rule) {
      if (!(element instanceof Element)) return;
      element.dataset.nblockerHidden = rule;
    }
  };
})();
