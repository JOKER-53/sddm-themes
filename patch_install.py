import re

with open("install.sh", "r") as f:
    content = f.read()

patch = """
# ── Dynamic Wallpaper Conversion ──────────────────────────
if [[ -f "$DEST/assets/wallpaper.mp4" ]]; then
  step "Converting MP4 to high-quality GIF for SDDM..."
  if ! command -v ffmpeg &>/dev/null; then
    warn "ffmpeg is missing! SDDM animations require GIF format."
    install_missing "$pm" "ffmpeg" || die "Please install ffmpeg to continue."
  fi
  PALETTE="/tmp/sddm_palette_$$.png"
  
  printf "  ${BK}[${R}${GLD} WAIT ${R}${BK}]${R} ${D}Generating color palette...${R}\r"
  ffmpeg -y -i "$DEST/assets/wallpaper.mp4" -vf "fps=24,palettegen=stats_mode=diff" "$PALETTE" </dev/null &>/dev/null
  
  printf "  ${BK}[${R}${GLD} WAIT ${R}${BK}]${R} ${D}Rendering frames (this takes a minute)...${R}\r"
  ffmpeg -y -i "$DEST/assets/wallpaper.mp4" -i "$PALETTE" -filter_complex "fps=24[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" "$DEST/assets/wallpaper.gif" </dev/null &>/dev/null
  
  rm -f "$PALETTE"
  rm -f "$DEST/assets/wallpaper.mp4"
  printf "  ${BK}[${R}${BG}  OK  ${R}${BK}]${R} ${B}Wallpaper converted successfully!        ${R}\n"
fi
"""

# Insert right after the copying loop completes
content = re.sub(
    r'(printf "\\\\r  \$\{BK\}\[\$\{R\}%s\$\{BK\}\]\$\{R\} \$\{B\}100%%\$\{R\}  done                              \\\\n" "\$bar")',
    r'\1\n' + patch,
    content
)

with open("install.sh", "w") as f:
    f.write(content)
