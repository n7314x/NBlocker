# Instagram known issues

- Instagram changes labels and DOM structure frequently; selectors need device and
  locale fixtures beyond English.
- Suggested-post detection is conservative to avoid hiding ordinary posts.
- Detection counts describe currently mounted DOM containers; Instagram's virtualized
  feed can remove older containers, so they are not lifetime session totals.
- Account switching opens Instagram's account-management route; exact switcher UI is
  controlled by Instagram and varies with the signed-in state.
- Single Reel allow-once and robust swipe-gesture prevention are milestone 2 work;
  direct next-Reel link clicks already receive best-effort interception.
- Website media policies may limit autoplay/mute control independently of scripts.
