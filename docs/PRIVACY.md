# Privacy

NBlocker is local-first and ships without an account, backend, analytics SDK, ads,
or telemetry. Platform settings, routines, and aggregate app-contained usage are
stored in `UserDefaults`. No browsing history is uploaded.

Instagram and YouTube authentication data remains under WebKit's default persistent
website data store. Local DOM rules inspect only the attributes and semantic labels
needed to apply a filter; NBlocker does not store, log, or export page text. It does
not intercept password fields, cookies, request bodies, or direct-message content.
Clearing site data is always an explicit user action and signs the website out.

Privacy-safe diagnostic logs may include the platform, stable rule ID, coarse route
kind, result status, and numeric counts. They must not include a complete URL, query,
fragment, account identifier, page title, content, cookie, or credential.

Opening a link outside NBlocker hands that URL to iOS after an explicit action.
