#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
#   JOKER53 · SDDM THEME INSTALLER
#   Usage:  sudo ./install.sh [theme-id]
# ═══════════════════════════════════════════════════════
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$REPO_DIR"
SDDM_THEMES="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"

# ── Colours ────────────────────────────────────────────
R=$'\033[0m'      # reset
B=$'\033[1m'      # bold
D=$'\033[2m'      # dim
IT=$'\033[3m'     # italic

K=$'\033[30m';  RD=$'\033[31m';  GR=$'\033[32m';  YL=$'\033[33m'
BL=$'\033[34m';  MG=$'\033[35m';  CY=$'\033[36m';  WH=$'\033[37m'

BK=$'\033[90m'; BR=$'\033[91m'; BG=$'\033[92m'; BY=$'\033[93m'
BB=$'\033[94m'; BM=$'\033[95m'; BC=$'\033[96m'; BW=$'\033[97m'

ORG=$'\033[38;5;208m'
PNK=$'\033[38;5;213m'
SKY=$'\033[38;5;117m'
GLD=$'\033[38;5;220m'
LME=$'\033[38;5;154m'
MNT=$'\033[38;5;121m'
LVN=$'\033[38;5;135m'
CRL=$'\033[38;5;203m'

# ── Helpers ─────────────────────────────────────────────
tw() { tput cols 2>/dev/null || echo 80; }

# solid line with repeating ASCII char
line()  { local c="${1:--}" n="${2:-$(tw)}"; printf "%${n}s\n" | tr ' ' "$c"; }
bline() { printf "${BK}"; line "${1:--}"; printf "${R}"; }

# centred text
ctr() {
  local s="$1" w="${2:-$(tw)}" raw
  raw="${s//$'\033'[0-9;]*m/}"   # strip ANSI for length calc
  raw="${raw//$'\033'[0m/}"
  local pad=$(( (w - ${#raw}) / 2 ))
  [[ $pad -lt 0 ]] && pad=0
  printf "%*s%s\n" "$pad" "" "$s"
}

ok()   { echo -e " ${BG}[  OK  ]${R}  $*"; }
info() { echo -e " ${SKY}[ INFO ]${R}  $*"; }
warn() { echo -e " ${GLD}[ WARN ]${R}  $*"; }
step() { echo -e " ${BM}[  >>  ]${R}  ${B}$*${R}"; }
die()  { echo -e "\n ${BR}[ FAIL ]${R}  ${BR}${B}$*${R}" >&2; exit 1; }

# ── Root check ──────────────────────────────────────────
[[ $EUID -eq 0 ]] || die "Run as root:  sudo $0 ${1:-}"

# ── Banner ──────────────────────────────────────────────
clear
echo ""
printf "${BM}${B}"
line "="
echo ""
ctr "${BW}${B}     ___  ___  ___  __  __    ___  ___  ___  ___  ___  ___ "
ctr "${BM}${B}    |   ||   ||   ||  \/  |  |__ ||   ||  _||   ||   ||   |"
ctr "${BC}${B}    | J || O || K || |\/| |  | __|| E || |_ | S || D || M |"
ctr "${BB}${B}    |___||___||___||_|  |_|  |___||___||___||___||___||___|"
echo ""
ctr "${BK}${D}        S D D M   T H E M E   I N S T A L L E R${R}"
echo ""
printf "${BM}${B}"
line "="
printf "${R}"
echo ""
ctr "${BK}${D}  Anime  .  JDM  .  Cyberpunk  .  Marvel  .  Nature  .  Pixel  ${R}"
ctr "${BK}${D}         44 hand-crafted themes  .  Pure QML  .  Qt5 & Qt6      ${R}"
echo ""

# ── Qt version ──────────────────────────────────────────
detect_qt_version() {
  if pacman -Qq sddm &>/dev/null 2>&1; then
    pacman -Qi sddm 2>/dev/null | grep -q 'qt6' && { echo "6"; return; }
    echo "5"; return
  fi
  if dpkg -l sddm &>/dev/null 2>&1; then
    dpkg -l | grep -q 'sddm-qt6\|qt6-sddm' && { echo "6"; return; }
    echo "5"; return
  fi
  echo "6"
}

QT_VER=$(detect_qt_version)
info "SDDM runtime  ->  ${B}${BC}Qt${QT_VER}${R}"

# ── Dependencies ────────────────────────────────────────
install_missing() {
  local pm=$1; shift; local pkgs=("$@")
  step "Installing: ${CY}${pkgs[*]}${R}"
  case "$pm" in
    pacman) pacman -S --noconfirm "${pkgs[@]}" ;;
    apt)    apt update && apt install -y "${pkgs[@]}" ;;
    dnf)    dnf install -y "${pkgs[@]}" ;;
    zypper) zypper install -y "${pkgs[@]}" ;;
  esac
}

check_deps_qt6() {
  local pm="" missing=()
  if   command -v pacman &>/dev/null; then pm="pacman"
    for p in qt6-declarative qt6-5compat qt6-svg; do
      pacman -Qq "$p" &>/dev/null || missing+=("$p"); done
  elif command -v apt    &>/dev/null; then pm="apt"
    for p in qml6-module-qtquick qml6-module-qt5compat-graphicaleffects libqt6svg6; do
      dpkg -l "$p" &>/dev/null || missing+=("$p"); done
  elif command -v dnf    &>/dev/null; then pm="dnf"
    for p in qt6-qtdeclarative qt6-qt5compat qt6-qtsvg; do
      rpm -q "$p" &>/dev/null || missing+=("$p"); done
  elif command -v zypper &>/dev/null; then pm="zypper"
    for p in qt6-declarative qt6-5compat qt6-svg; do
      rpm -q "$p" &>/dev/null || missing+=("$p"); done
  fi
  [[ ${#missing[@]} -gt 0 ]] \
    && { [[ -n "$pm" ]] && install_missing "$pm" "${missing[@]}" \
                        || warn "Missing Qt6 packages: ${missing[*]}"; } \
    || ok "All Qt6 dependencies satisfied"
}

check_deps_qt5() {
  local pm="" missing=()
  if   command -v pacman &>/dev/null; then pm="pacman"
    for p in qt5-declarative qt5-graphicaleffects qt5-quickcontrols2; do
      pacman -Qq "$p" &>/dev/null || missing+=("$p"); done
  elif command -v apt    &>/dev/null; then pm="apt"
    for p in qml-module-qtquick2 qml-module-qtgraphicaleffects qml-module-qtquick-controls2; do
      dpkg -l "$p" &>/dev/null || missing+=("$p"); done
  elif command -v dnf    &>/dev/null; then pm="dnf"
    for p in qt5-qtdeclarative qt5-qtgraphicaleffects qt5-qtquickcontrols2; do
      rpm -q "$p" &>/dev/null || missing+=("$p"); done
  elif command -v zypper &>/dev/null; then pm="zypper"
    for p in libqt5-qtdeclarative qt5-graphicaleffects; do
      rpm -q "$p" &>/dev/null || missing+=("$p"); done
  fi
  [[ ${#missing[@]} -gt 0 ]] \
    && { [[ -n "$pm" ]] && install_missing "$pm" "${missing[@]}" \
                        || warn "Missing Qt5 packages: ${missing[*]}"; } \
    || ok "All Qt5 dependencies satisfied"
}

[[ "$QT_VER" == "6" ]] && check_deps_qt6 || check_deps_qt5

# ── Gather themes ────────────────────────────────────────
THEMES=()
for d in "$THEMES_DIR"/*/; do
  [[ -f "$d/metadata.desktop" ]] && THEMES+=("$(basename "$d")")
done
TOTAL=${#THEMES[@]}

# ── Category colour ──────────────────────────────────────
theme_colour() {
  case "$1" in
    marvel|deadpool|joker|spiderverse|spiderman) echo "$BR" ;;
    bmw|bmw-m3|classic-jdm|drag-racer|dodge|mazda-mx5|nissan|nissan-skyline) echo "$BY" ;;
    neon-gif|alienx|hoodie|oni-robot|cosmic-gateway|mountain-sunset) echo "$BC" ;;
    gojo|kawaii|neko-anime|zoro-dragon|zoro-blue|oni-anime-girl|hitagi-senjougahara|hilda-and-tepig|neverness-to-everness|purrple-cat|moonlit-rooftop-cat|sakura-lake|pokeball|pixel-sakura-city) echo "$BM" ;;
    pixel-gaming-room|super-mario-pixel) echo "$BG" ;;
    cat-pond|everest|fish-in-rock-pond|mount-fuji|ocean-in-jar|pink-bloom) echo "$MNT" ;;
    rdr2|the-dark-river|pirates-of-the-caribbean) echo "$ORG" ;;
    *) echo "$BW" ;;
  esac
}

# ── Theme menu ───────────────────────────────────────────
THEME="${1:-}"

if [[ -z "$THEME" ]]; then
  echo ""
  bline "-"
  ctr "${B}${BW}  AVAILABLE THEMES  ${R}"
  bline "-"
  echo ""

  num=$TOTAL
  half=$(( (num + 1) / 2 ))

  for (( i=0; i<half; i++ )); do
    j=$(( i + half ))
    t1="${THEMES[$i]}"
    c1=$(theme_colour "$t1")
    n1=$(printf "%2d" $((i+1)))

    # left column: fixed 40-char wide
    left=$(printf "  ${BK}%s${R} ${c1}%-36s${R}" "$n1" "$t1")

    if [[ $j -lt $num ]]; then
      t2="${THEMES[$j]}"
      c2=$(theme_colour "$t2")
      n2=$(printf "%2d" $((j+1)))
      right=$(printf "${BK}%s${R} ${c2}%s${R}" "$n2" "$t2")
      echo -e "${left}  ${right}"
    else
      echo -e "${left}"
    fi
  done

  echo ""
  bline "-"
  echo ""

  # Prompt
  echo -e "  ${GLD}+---------------------------------------+${R}"
  echo -e "  ${GLD}|${R}  ${BY}${B}Enter theme number (1-${TOTAL}):${R}           ${GLD}|${R}"
  printf  "  ${GLD}|${R}  ${BW}> ${R}"; read -r choice
  echo -e "  ${GLD}+---------------------------------------+${R}"
  echo ""

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || \
     [[ "$choice" -lt 1 ]] || \
     [[ "$choice" -gt "$num" ]]; then
    die "Invalid selection: '${choice}'"
  fi
  THEME="${THEMES[$((choice-1))]}"
fi

# ── Validate ─────────────────────────────────────────────
THEME_SRC="$THEMES_DIR/$THEME"
[[ -d  "$THEME_SRC" ]]                  || die "Theme '${THEME}' not found."
[[ -f  "$THEME_SRC/Main.qml" ]]         || die "Theme '${THEME}' missing Main.qml"
[[ -f  "$THEME_SRC/metadata.desktop" ]] || die "Theme '${THEME}' missing metadata.desktop"

DEST="$SDDM_THEMES/$THEME"
[[ "$DEST" == /usr/share/sddm/themes/* ]] \
  || die "Destination path looks wrong: ${DEST}"

# ── Install header ────────────────────────────────────────
echo ""
TC=$(theme_colour "$THEME")
printf "${TC}${B}"
line "*"
echo ""
ctr "${BW}${B}  Installing  >>  ${TC}${THEME^^}${R}"
echo ""
printf "${TC}${B}"
line "*"
printf "${R}"
echo ""

# ── Backup ────────────────────────────────────────────────
if [[ -d "$DEST" ]]; then
  BACKUP="${DEST}.bak.$(date +%Y%m%d_%H%M%S)"
  step "Backing up existing theme"
  cp -r "$DEST" "$BACKUP"
  ok  "Saved  ->  ${D}${BACKUP}${R}"
fi
[[ -f "$SDDM_CONF" ]] && cp "$SDDM_CONF" "${SDDM_CONF}.bak.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true

# ── Copy files ────────────────────────────────────────────
step "Copying theme files"
rm -rf "$DEST"
mkdir -p "$DEST"

file_total=$(find "$THEME_SRC" -type f | wc -l)
copied=0

while IFS= read -r -d '' src; do
  rel="${src#$THEME_SRC/}"
  dst="$DEST/$rel"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  (( copied++ )) || true
  pct=$(( copied * 100 / file_total ))
  fill=$(( copied * 24 / file_total ))
  empty=$(( 24 - fill ))
  bar="${BG}$(printf '%0.s#' $(seq 1 $fill) 2>/dev/null)${BK}$(printf '%0.s-' $(seq 1 $empty) 2>/dev/null)${R}"
  printf "\r  ${BK}[${R}%s${BK}]${R} ${B}%3d%%${R}  %s" "$bar" "$pct" "$rel"
done < <(find "$THEME_SRC" -type f -print0)

fill=24
bar="${BG}$(printf '%0.s#' $(seq 1 $fill))${R}"
printf "\r  ${BK}[${R}%s${BK}]${R} ${B}100%%${R}  done                              \n" "$bar"

# ── Qt patches ────────────────────────────────────────────
transpile_for_qt5() {
  step "Patching QML imports for Qt5"
  find "$DEST" -name "*.qml" | while read -r f; do
    perl -i -pe '
      s/^(\s*import\s+QtQuick\s*)(\n|$)/${1}2.15\n/;
      s/^(\s*import\s+QtQuick\.Controls\s*)(\n|$)/${1}2.15\n/;
      s/^(\s*import\s+QtQuick\.Layouts\s*)(\n|$)/${1}1.15\n/;
      s/^(\s*import\s+Qt5Compat\.GraphicalEffects\b)/import QtGraphicalEffects 1.0/;
    ' "$f"
  done
  ok "Qt5 patches applied"
}

if [[ "$QT_VER" == "6" ]]; then
  if ! grep -q "^QtVersion=" "$DEST/metadata.desktop"; then
    echo "QtVersion=6" >> "$DEST/metadata.desktop"
    ok "QtVersion=6 added to metadata.desktop"
  else
    ok "metadata.desktop already has QtVersion"
  fi
else
  transpile_for_qt5
fi

# ── Permissions ───────────────────────────────────────────
step "Setting permissions"
chmod -R a+rX "$DEST"
ok  "Permissions set (a+rX)"

# ── sddm.conf ─────────────────────────────────────────────
step "Updating SDDM configuration"
touch "$SDDM_CONF"
if grep -q '^\[Theme\]' "$SDDM_CONF"; then
  grep -q '^Current=' "$SDDM_CONF" \
    && sed -i "s|^Current=.*|Current=$THEME|" "$SDDM_CONF" \
    || sed -i "/^\[Theme\]/a Current=$THEME" "$SDDM_CONF"
else
  printf '\n[Theme]\nCurrent=%s\n' "$THEME" >> "$SDDM_CONF"
fi

CONFD="/etc/sddm.conf.d"
if [[ -d "$CONFD" ]]; then
  for f in "$CONFD"/*.conf; do
    [[ -f "$f" ]] && grep -q '^Current=' "$f" && \
      sed -i "s|^Current=.*|Current=$THEME|" "$f" && \
      ok "Updated ${D}$f${R}"
  done
fi
ok "SDDM will use ${B}${BC}${THEME}${R} on next login"

# ── Success ───────────────────────────────────────────────
echo ""
printf "${BG}${B}"
line "="
echo ""
ctr "${BW}${B}  ** INSTALLATION COMPLETE **  ${R}"
echo ""
ctr "${BG}${B}  ${THEME^^}  is now your login screen  ${R}"
echo ""
printf "${BG}${B}"
line "="
printf "${R}"
echo ""

echo -e "  ${BY}NEXT STEPS${R}"
bline "-"
echo ""
echo -e "  ${SKY}>>  Preview without rebooting:${R}"
echo -e "      ${BC}sddm-greeter-qt6 --test-mode --theme ${DEST}${R}"
echo ""
echo -e "  ${SKY}>>  Apply permanently:${R}"
echo -e "      ${BG}reboot${R}  ${BK}(recommended)${R}"
echo -e "      ${D}-- or --${R}  ${BC}systemctl restart sddm${R}  ${BK}(from TTY only)${R}"
echo ""
bline "-"
echo -e "  ${BK}  github.com/KADHIRAVANEG/sddm-themes${R}"
echo ""