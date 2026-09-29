(() => {
  "use strict";
  const runtime = window.NBlocker;
  runtime?.register("instagram.messages.only", (root) => {
    if (!runtime.config.filteringEnabled || !runtime.config.messagesOnly) return;
    const links = root.querySelectorAll?.('nav a[href], [role="navigation"] a[href]') || [];
    for (const link of links) {
      const path = new URL(link.href, location.href).pathname;
      if (!path.startsWith("/direct") && !path.startsWith("/accounts")) {
        window.NBlocker.hide(link, "instagram.messages.only");
      }
    }
  });
})();
