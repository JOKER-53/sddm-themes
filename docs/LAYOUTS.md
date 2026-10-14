# Theme layout guidance

The wallpaper and existing display type define each theme. Preserve those identities while keeping account names, passwords, session names and power actions legible.

The desktop compositions retain their original alignment: automotive dashboards, manga splits, pastel panels and terminal consoles. A reserved footer separates system actions from the artwork and login controls. Below 1200×680, a compact form uses the same wallpaper and accent with controls large enough to read and operate.

Shared UI colours are `#15171b` for system surfaces, `#ffffff` for primary text, `#d4dbe2` for supporting text, and `#56616b` for boundaries. Each theme supplies its accent through `theme.conf`. Sign-in buttons select light or dark text according to that accent. Clocks over photographs have a dark backing and white text. Account and password text use sans-serif; headings and desktop clocks keep the theme's display face.

Keep authentication panels above the footer's reserved space. Bound decorative image dimensions explicitly; an image's native height must not determine where a login form lands. Allow space for the entire form, including its sign-in button. Do not rely solely on pressing Enter or on an unlabeled icon. Provide visible focus and a useful password placeholder.

Before accepting a layout change, run the render checks described in [TESTING.md](TESTING.md), inspect desktop and compact screenshots, and preview the packaged theme in SDDM test mode for animation and display-specific rendering.
