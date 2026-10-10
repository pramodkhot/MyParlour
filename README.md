# MyParlour (demo v0.1)

Beauty parlour management app built with Flutter. This is a demo build for collecting feedback
from parlour owners: no login, no server, and all data stays on the phone with preloaded sample
data.

- Full spec: [MYPARLOUR_DEMO_BUILD_PROMPT.md](MYPARLOUR_DEMO_BUILD_PROMPT.md)
- Choices made along the way: [DECISIONS.md](DECISIONS.md)

## Checks

```
flutter analyze
flutter test
```

## Getting the APK

Every push to `main` runs **Actions → Build APK**. Open the latest run and download the
`myparlour-apk` artifact. Pushing a tag such as `v0.1.0` also creates a GitHub Release with the
APK attached.

To keep installs updatable without uninstalling, add the signing secrets described in Section 12
of the spec (`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`).
