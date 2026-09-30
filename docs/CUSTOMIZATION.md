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

`common/AuthController.qml` validates login requests, prevents duplicate submissions, and clears/refocuses the password after authentication fails. `LoginStatus.qml` displays progress and errors. `SessionPicker.qml` supplies a session selector for themes without one in their layout. `ActionArea.qml` makes custom login and power controls keyboard accessible with Tab, Enter and Space. `Wallpaper.qml` displays installed GIFs or the still thumbnail of unconverted videos.

Edit these templates in `common/` and regenerate the packaged copies. Do not edit `themes/<id>/components/` directly: CI checks that those copies match their source.
