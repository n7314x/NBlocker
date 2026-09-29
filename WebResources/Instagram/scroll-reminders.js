(() => {
  "use strict";
  const runtime = window.NBlocker;
  if (!runtime || window.__nblockerInstagramReminders) return;
  window.__nblockerInstagramReminders = true;

  let timer;
  let scheduledMinutes;
  let configuredPostLimit;
  const seenPosts = new WeakSet();
  let postCount = 0;
  let didReportPosts = false;

  const updateTimer = () => {
    const minutes = runtime.config.filteringEnabled ? Number(runtime.config.scrollReminderMinutes) : NaN;
    const nextMinutes = Number.isFinite(minutes) && minutes > 0 ? minutes : undefined;
    if (nextMinutes === scheduledMinutes) return;
    if (timer) window.clearTimeout(timer);
    timer = undefined;
    scheduledMinutes = nextMinutes;
    if (nextMinutes) {
      timer = window.setTimeout(() => {
        runtime.report("scrollReminder", { kind: "time" });
        timer = undefined;
      }, nextMinutes * 60 * 1000);
    }
  };

  runtime.register("instagram.scroll.reminders", (root) => {
    updateTimer();
    const candidate = runtime.config.filteringEnabled ? Number(runtime.config.scrollReminderPosts) : NaN;
    const postLimit = Number.isFinite(candidate) && candidate > 0 ? candidate : undefined;
    if (postLimit !== configuredPostLimit) {
      configuredPostLimit = postLimit;
      postCount = 0;
      didReportPosts = false;
    }
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
