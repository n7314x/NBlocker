# Screen Time capability

Family Controls, Managed Settings, Device Activity, and shield extensions require
capabilities in the signing profile. Sideloading by itself does not grant them.
NBlocker's default target therefore compiles and works without these entitlements.

The app exposes these states:

- `notProvisioned`: the ordinary build; protected-app selection is unavailable.
- `notDetermined`: an entitled build has not requested user authorization.
- `denied`: the system declined authorization.
- `approved`: authorization is active.
- `unavailable(reason)`: the framework or runtime environment cannot provide it.

Milestone 1 implements the state facade and explanatory UI. It does not call
authorization APIs or imply system enforcement. Future entitled builds should add a
separate target setting and dependency that adopts the existing facade.

Extension boundaries remain distinct: Device Activity monitoring observes schedules,
Managed Settings applies shields, shield configuration renders the system surface,
and shield actions process allowed responses. These components should exchange only
small Codable values through an app group and must never be linked into the default
unsigned target merely to silence compiler errors.
