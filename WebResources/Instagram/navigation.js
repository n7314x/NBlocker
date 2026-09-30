(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime || window.__nblockerInstagramNavigation) return;
  window.__nblockerInstagramNavigation = true;

  const controlSelector = 'a[href], [role="link"], button';

  const controlFor = (element) => {
    if (!(element instanceof Element)) return null;
    return element.matches(controlSelector) ? element : element.closest(controlSelector);
  };

  const semanticText = (element) => {
    const control = controlFor(element);
    if (!control) return "";
    const values = [
      control.getAttribute("aria-label"),
      control.getAttribute("title")
    ];
    const labelledBy = control.getAttribute("aria-labelledby")?.split(/\s+/) || [];
    for (const identifier of labelledBy) {
      values.push(document.getElementById(identifier)?.textContent);
    }
    for (const descendant of control.querySelectorAll("[aria-label], [aria-labelledby], [title], [alt], input[placeholder]")) {
      values.push(
        descendant.getAttribute("aria-label"),
        descendant.getAttribute("title"),
        descendant.getAttribute("alt"),
        descendant.getAttribute("placeholder")
      );
      const descendantLabels = descendant.getAttribute("aria-labelledby")?.split(/\s+/) || [];
      for (const identifier of descendantLabels) {
        values.push(document.getElementById(identifier)?.textContent);
      }
    }
    values.push(control.textContent);
    return values.filter(Boolean).join(" ").replace(/\s+/g, " ").trim();
  };

  const pathFor = (element) => {
    const control = controlFor(element);
    const href = control?.getAttribute("href");
    if (!href) return null;
    try {
      return new URL(href, location.href).pathname;
    } catch (_) {
      return null;
    }
  };

  const isSearchControl = (element) => /(^|\b)search(\b|$)/i.test(semanticText(element));
  const isExploreControl = (element) => {
    if (isSearchControl(element)) return false;
    return /(^|\b)explore(\b|$)/i.test(semanticText(element));
  };

  const destinationKind = (element) => {
    const text = semanticText(element);
    if (/(^|\b)search(\b|$)/i.test(text)) return "search";
    if (/(^|\b)home(\b|$)/i.test(text)) return "home";
    if (/(^|\b)reels?(\b|$)/i.test(text)) return "reels";
    if (/(^|\b)(messages?|inbox|direct)(\b|$)/i.test(text)) return "messages";
    if (/(^|\b)(profile|account)(\b|$)/i.test(text)) return "profile";
    if (/(^|\b)explore(\b|$)/i.test(text)) return "explore";

    const path = pathFor(element);
    if (/^\/$/.test(path || "")) return "home";
    if (/^\/explore\/?$/i.test(path || "")) return "explore";
    if (/^\/reels?\/?$/i.test(path || "")) return "reels";
    if (/^\/direct(?:\/inbox)?\/?$/i.test(path || "")) return "messages";
    return null;
  };

  const controlsWithin = (element) => {
    const controls = [];
    if (element.matches?.(controlSelector)) controls.push(element);
    controls.push(...(element.querySelectorAll?.(controlSelector) || []));
    return controls;
  };

  const directItems = (element) => [...element.children]
    .filter((child) => controlsWithin(child).length > 0);

  const recognizedDirectItems = (element) => directItems(element)
    .filter((child) => controlsWithin(child).some((control) => destinationKind(control)));

  const isMobileBottomLayout = (element) => {
    if (typeof window.matchMedia !== "function" || !window.matchMedia("(max-width: 900px)").matches) return false;
    const bounds = element.getBoundingClientRect();
    if (bounds.width <= 0 || bounds.height <= 0) return false;
    return bounds.top >= window.innerHeight * 0.5 &&
      bounds.bottom >= window.innerHeight - Math.max(96, window.innerHeight * 0.12);
  };

  const layoutFor = (element) => {
    const control = controlFor(element);
    if (!control) return null;
    const semanticNavigation = control.closest('nav, [role="navigation"]');
    let candidate = control.parentElement;
    let depth = 0;
    while (candidate && depth < 8) {
      const items = directItems(candidate);
      const containsControl = items.some((item) => item.contains(control));
      const recognizedItems = recognizedDirectItems(candidate);
      if (containsControl && recognizedItems.length >= 2 && isMobileBottomLayout(candidate)) {
        return { container: candidate, items };
      }
      if (candidate === semanticNavigation) break;
      candidate = candidate.parentElement;
      depth += 1;
    }
    return null;
  };

  const markLayout = (layout) => {
    if (!layout) return false;
    layout.container.dataset.nblockerCompactNav = "true";
    for (const item of layout.items) item.dataset.nblockerNavItem = "true";
    return true;
  };

  const hideItem = (element, rule) => {
    const control = controlFor(element);
    const layout = layoutFor(control);
    if (!control || !layout) return false;
    markLayout(layout);
    const item = layout.items.find((candidate) => candidate.contains(control));
    if (!item) return false;
    runtime.hide(item, rule);
    return true;
  };

  const compactNavigation = (root) => {
    const candidates = root.querySelectorAll?.([
      'nav a[href]',
      'nav button',
      '[role="navigation"] a[href]',
      '[role="navigation"] button',
      'a[href="/"]',
      'a[href="/explore"]',
      'a[href="/explore/"]',
      'a[href="/reels"]',
      'a[href="/reels/"]',
      'a[href^="/direct"]'
    ].join(", ")) || [];
    for (const candidate of candidates) {
      if (!destinationKind(candidate)) continue;
      markLayout(layoutFor(candidate));
    }
  };

  runtime.instagramNavigation = Object.freeze({
    compactNavigation,
    hideItem,
    isExploreControl,
    isSearchControl,
    semanticText
  });
  runtime.register("instagram.navigation", compactNavigation);

  document.addEventListener("click", (event) => {
    const anchor = event.target instanceof Element ? event.target.closest("a[href]") : null;
    if (!anchor) return;
    try {
      if (!runtime.config.filteringEnabled) return;
      const url = new URL(anchor.href, location.href);
      const isReel = /^\/(reel|reels)(\/|$)/i.test(url.pathname);
      const isCurrentlyViewingReel = /^\/(reel|reels)(\/|$)/i.test(location.pathname);
      const blocksContinuation = runtime.config.blockReelChaining &&
        isCurrentlyViewingReel && url.pathname !== location.pathname;
      if (isReel && (runtime.config.blockReelRoutes || blocksContinuation)) {
        event.preventDefault();
        event.stopImmediatePropagation();
        runtime.report("navigationPrevented", { route: "reel" });
      }
    } catch (_) {
      runtime.report("ruleError", { rule: "instagram.navigation" });
    }
  }, true);
})();
