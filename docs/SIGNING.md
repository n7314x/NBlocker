# Signing

Normal CI validation uses `CODE_SIGNING_ALLOWED=NO` and requires no secret. This also
keeps privileged Screen Time extensions out of the default build graph.

For a signed build, provide certificate/profile material through GitHub Secrets and
import it into a temporary keychain during the packaging job. Bundle identifiers,
team identifiers, and profile names should be supplied as workflow inputs or secret
configuration rather than committed defaults. Remove the temporary keychain at the
end of the job.

Family Controls and related extension entitlements must appear in both the app's
entitlements and its actual provisioning profile. A source entitlement file alone
does not grant the capability.
