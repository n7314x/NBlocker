(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime || window.__nblockerInstagramReminders) return;
  window.__nblockerInstagramReminders = true;

  const minutes = Number(runtime.config.scrollReminderMinutes);
  if (Number.isFinite(minutes) && minutes > 0) {
    window.setTimeout(() => {
      runtime.report("scrollReminder", { kind: "time" });
    }, minutes * 60 * 1000);
  }

  const postLimit = Number(runtime.config.scrollReminderPosts);
  const seenPosts = new WeakSet();
  let postCount = 0;
  let didReportPosts = false;
  runtime.register("instagram.scroll.reminders", (root) => {
    if (!Number.isFinite(postLimit) || postLimit <= 0 || didReportPosts) return;
    const posts = root.querySelectorAll?.("main article") || [];
    for (const post of posts) {
      if (seenPosts.has(post)) continue;
      seenPosts.add(post);
      postCount += 1;
    }
    if (postCount >= postLimit) {
      didReportPosts = true;
      runtime.report("scrollReminder", { kind: "posts" });
    }
  });
})();
