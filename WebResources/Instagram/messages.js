(() => {
  "use strict";
  window.NBlocker?.register("instagram.messages.only", (root) => {
    const links = root.querySelectorAll?.('nav a[href], [role="navigation"] a[href]') || [];
    for (const link of links) {
      const path = new URL(link.href, location.href).pathname;
      if (!path.startsWith("/direct") && !path.startsWith("/accounts")) {
        window.NBlocker.hide(link, "instagram.messages.only");
      }
    }
  });
})();
