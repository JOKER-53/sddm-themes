# Customization

Every theme reads its background and primary accent from `theme.conf`:

```ini
[General]
accent=#1c69d4
background=assets/wallpaper.jpg
```

Edit `themes/<id>/theme.conf`, put the media inside that theme's `assets/` directory, and reinstall. Wallpaper paths are relative to the theme directory; absolute paths and `..` segments are rejected during installation. JPEG, PNG, GIF and MP4 are supported. MP4 backgrounds are converted into GIFs in the installed package, leaving the original source media unchanged. You can also use `theme.conf.user` to override installed SDDM settings; use JPEG, PNG or GIF for installed overrides, since MP4 conversion happens during installation.

The main accent changes the theme's primary highlights. Secondary colours remain part of the individual design. The older `brand` key remains an optional alias; when supplied it takes precedence over `accent`. Neon additionally supports `neonPink` and `neonCyan`.

For catalog-managed wallpaper changes, update `wallpaper`, `thumbnail` and `animated` in `theme-catalog.json` as well as `theme.conf`. The thumbnail must be a still image. Run:

```bash
python3 scripts/generate.py
python3 scripts/validate.py
```

The catalog controls the website and generated gallery; it does not overwrite theme styling. Update `accent` in the catalog if you want the website accent to match your new primary colour.

## Shared behavior

`common/AuthController.qml` owns the selected account and session, validates login requests, prevents duplicate submissions, and clears/refocuses the password after authentication fails. `UsernamePicker.qml` supplies the account dropdown in every layout, preferring SDDM’s remembered account name over a stale account index. `LoginStatus.qml` displays progress and errors beside the form using the design’s palette, font, and corner style. `SystemBar.qml` reserves space for session selection and power controls. Each design configures its `accent`, `surface`, `foreground`, `cornerRadius`, `controlRadius`, `fontFamily`, `treatment`, and footer alignment in Main.qml. `SessionPicker.qml` uses the same treatment for its selector and popup. `LoginSubmit.qml` supplies readable sign-in buttons. `ActionArea.qml` makes custom controls keyboard accessible with Tab, Enter and Space, and `FieldFocus.qml` marks focused input fields. `Wallpaper.qml` displays installed GIFs or the still thumbnail of unconverted videos.

The individual desktop compositions scale with the screen. Below 1200 pixels wide or 680 pixels high, `CompactGreeter.qml` presents the same wallpaper and accent with full-size input controls. All username selectors are noneditable dropdowns. Both forms share the selected account; changing layouts clears the old and new password fields. The password failure handler always targets the form that is currently visible. Error styling clears when a user edits the password or changes accounts.

Edit these templates in `common/` and regenerate the packaged copies. Do not edit `themes/<id>/components/` directly: CI checks that those copies match their source.
