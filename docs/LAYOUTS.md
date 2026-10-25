# Theme layout guidance

The wallpaper and existing display type define each theme. Preserve those identities while keeping account names, passwords, session names and power actions legible.

The desktop compositions retain their original alignment: automotive dashboards, manga splits, pastel panels and terminal consoles. A reserved footer separates system actions from the artwork and login controls. Below 1200×680, a compact form uses the same wallpaper and accent with controls large enough to read and operate.

System controls inherit the composition’s visual treatment: cinematic rules, dashboard stripes, terminal outlines, rounded pastel controls, parchment frames, or square pixel borders. Each Main.qml sets its utility surface, text, font, corner geometry, accent, and alignment. Each theme supplies its accent through `theme.conf`. Sign-in buttons select light or dark text according to that accent. Clocks over photographs have a dark backing and white text. Account and password text use sans-serif; headings and desktop clocks keep the theme's display face.

Keep authentication panels above the footer's reserved space. Bound decorative image dimensions explicitly; an image's native height must not determine where a login form lands. Allow space for the entire form, including its sign-in button. Do not rely solely on pressing Enter or on an unlabeled icon. Provide visible focus and a useful password placeholder. Extra field focus indicators appear during keyboard navigation; mouse clicks retain the design’s normal field treatment and text cursor. Authentication errors remain visible regardless of input method. Use `Common.UsernamePicker` for the account dropdown and bind it to the shared controller. Read the selected account from `auth.username` when submitting. `LoginStatus` positions feedback beside the form; keep the standard object names on username, password, sign-in, clock, and system controls so its placement can avoid them.

Before accepting a layout change, run the render checks described in [TESTING.md](TESTING.md), inspect desktop and compact screenshots, and preview the packaged theme in SDDM test mode for animation and display-specific rendering.
