# Instagram routes

| Route | Classification | Initial policy |
| --- | --- | --- |
| `/` | home | allow |
| `/direct` and descendants | messages | allow |
| `/reel/{id}` or `/reels/{id}` | reel | allow or block by setting |
| `/reels/` | reel feed | allow or block by setting |
| `/explore` and descendants | explore | allow; DOM entry may be hidden |
| `/accounts/*` | accounts | allow |
| other same-host paths | profile/content | allow |

`instagram.com` and its first-party subdomains are treated as platform routes so
Instagram-owned mobile, API, and login handoffs remain inside the wrapper. HTTP is
upgraded to HTTPS. HTTPS Facebook authentication hosts are allowed for Instagram's
site-owned login flow. Lookalike domains and other top-level hosts require an explicit
external-open action rather than inheriting the authenticated platform context.
Harmless subframe/internal navigation is never promoted to a user-facing warning.
Known Instagram app-scheme profile links are converted to first-party web URLs when
safe; other app-launch attempts are ignored instead of opening the installed app.
