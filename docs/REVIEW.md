# Repository review — 2026-10-25

## Focus and artwork follow-up

- Extra focus indicators appear for keyboard navigation or authentication errors. Mouse clicks use the text cursor and the design’s existing field styling, without adding a white underline.
- Sunset Drive’s configured/catalog accent now matches its existing peach/orange controls, including compact mode. Its system controls use a warm brown surface instead of magenta/purple.
- Deadpool’s artwork fits a right-side area at its original aspect ratio, with a stronger dark wash behind the left login panel. The character is no longer enlarged and cropped across the whole screen.

## Follow-up from screenshot review

- Session and power controls now use explicit per-theme palettes, fonts, corners, borders, and alignment. Dashboard, terminal, pastel, parchment, comic, and pixel treatments follow the existing compositions. Shared implementation retains consistent action behavior.
- Removed the full-width sign-in button covering Deadpool’s password. The original submit arrow now has its own separate hit target.
- Transparent password fields use an inset focus underline; username focus follows its field background. This avoids rectangular outlines cutting across rounded fields.
- Render checks now reject overlaps between login controls and exercise the session dropdown plus reboot, shutdown, and suspend through fake SDDM actions. No real power actions run during testing.

## Fixed across all 44 designs

- Authentication banners now use each design’s palette, type, and corner style. They position themselves beside the form and avoid username, password, sign-in, clock, and system controls. Longer feedback wraps instead of being clipped.
- Every username field is a noneditable dropdown, as requested. The shared selector prioritizes SDDM’s remembered username, then a valid saved account index, then the first account. SDDM persists successful logins; the theme does not maintain a separate user-history file.
- Full and compact forms share account and session state. Layout switches clear both password fields, preventing stale secrets from reappearing. Failed logins clear and refocus the currently visible password.
- Alien X’s repeated-field expression could populate the password field with an account name. It now uses separate account/password controls, and starts with an empty password.
- Authentication failures mark the password field and expose an accessible description. Editing the password or selecting a different account clears the old error. Successful authentication also clears the password while duplicate submissions remain blocked during session startup.
- Invalid, fractional, and out-of-range session indices are rejected before submission. Missing accounts and sessions produce safe empty states rather than phantom selections.
- Shared dropdowns preserve the individual design’s colors, font, background, and delegates, with visible keyboard focus and legible fallback popups.

## Verification

The QML harness covers all designs with fake SDDM users, sessions, and authentication signals. It exercises actual dropdown keyboard interaction, sign-in clicks, Enter submission, retries, account synchronization across layout switches, password clearing, last-user defaults, invalid sessions, empty models, and longer feedback. Render checks cover 1920×1080, 1366×768, 1024×768, 800×600, and 3440×1440. Qt 6 screenshots include failure states and a gallery toggle.

These checks do not establish real PAM authentication, session startup, animation playback, or every font/DPI combination. Qt 5 runs in the existing CI matrix; it is not installed in this local environment. Website tests require a Playwright Chromium installation, which is absent locally.

## Further work needing a system environment

- Smoke-test installed themes with real SDDM/PAM in disposable Qt 5 and Qt 6 VMs, including successful login, rejected credentials, account lockout, remembered-user behavior, and session startup.
- Review animation playback and display scaling on actual greeter hardware.
- Consider instantiating staged packages with the target Qt runtime before activating them, so missing runtime modules are detected before replacing the active theme.

Generated components under themes/*/components are intentional standalone packages. Edit common/*.qml and run scripts/generate.py; do not modify individual copies.
