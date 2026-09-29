(() => {
  "use strict";
  if (window.NBlocker) return;

  const rules = new Map();
  const actions = new Map();
  const metricSources = new Map();
  let scheduled = false;
  let metricsScheduled = false;
  let lastMetricsSignature = "";
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

  const reportMetrics = () => {
    metricsScheduled = false;
    const totals = { ads: 0, suggested: 0, blockable: 0 };
    for (const metrics of metricSources.values()) {
      totals.ads += metrics.ads;
      totals.suggested += metrics.suggested;
      totals.blockable += metrics.blockable;
    }
    const signature = `${totals.ads}:${totals.suggested}:${totals.blockable}`;
    if (signature === lastMetricsSignature) return;
    lastMetricsSignature = signature;
    report("metrics", totals);
  };

  const safeCount = (value) => Math.min(9999, Math.max(0, Number.isFinite(value) ? Math.trunc(value) : 0));

  window.NBlocker = {
    platform: "unknown",
    config: Object.freeze({ ...(window.__NBLOCKER_CONFIG__ || {}) }),
    updateConfig(nextConfig) {
      if (!nextConfig || typeof nextConfig !== "object" || Array.isArray(nextConfig)) return false;
      window.__NBLOCKER_CONFIG__ = { ...nextConfig };
      this.config = Object.freeze({ ...nextConfig });
      document.documentElement?.classList.toggle(
        "nblocker-reduce-motion",
        Boolean(this.config.filteringEnabled && this.config.reduceWebMotion)
      );
      return true;
    },
    reapplyRules() {
      for (const element of document.querySelectorAll?.("[data-nblocker-hidden]") || []) {
        delete element.dataset.nblockerHidden;
      }
      lastMetricsSignature = "";
      apply(document);
      return true;
    },
    register(id, rule) {
      if (typeof id !== "string" || typeof rule !== "function") return;
      rules.set(id, rule);
      this.schedule(document);
    },
    registerAction(id, action) {
      if (typeof id !== "string" || typeof action !== "function") return;
      const existing = actions.get(id) || [];
      existing.push(action);
      actions.set(id, existing);
    },
    performAction(id) {
      let affected = 0;
      for (const action of actions.get(id) || []) {
        try {
          affected += safeCount(action());
        } catch (_) {
          report("ruleError", { rule: id });
        }
      }
      this.schedule(document);
      return affected;
    },
    updateMetrics(source, values = {}) {
      if (typeof source !== "string") return;
      metricSources.set(source, {
        ads: safeCount(values.ads),
        suggested: safeCount(values.suggested),
        blockable: safeCount(values.blockable)
      });
      if (metricsScheduled) return;
      metricsScheduled = true;
      requestAnimationFrame(reportMetrics);
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
