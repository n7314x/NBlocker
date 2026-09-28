# YouTube routes

| Route | Classification | Initial policy |
| --- | --- | --- |
| `/` | home | allow or redirect to subscriptions by setting |
| `/feed/subscriptions` | subscriptions | allow |
| `/watch?v=…` | video | allow |
| `/shorts/{id}` | short | allow or block by setting |
| `/results?search_query=…` | search | allow or block independently |
| other same-host paths | content | allow |

Supported platform hosts are `youtube.com`, `www.youtube.com`, `m.youtube.com`, and
`youtu.be`. HTTPS Google/YouTube account and consent hosts are allowed for site-owned
authentication. Short-link IDs are normalized before classification; full URLs and
query values are never logged.
