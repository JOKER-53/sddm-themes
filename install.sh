#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  SDDM theme installer (Interactive)
#  Usage:  sudo ./install.sh [theme-id]
# ─────────────────────────────────────────────────────────────
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$REPO_DIR"
SDDM_THEMES="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"

# ── colours ──────────────────────────────────────────────────
RED='\033[0;31m'; YEL='\033[1;33m'; GRN='\033[0;32m'
CYN='\033[0;36m'; BLU='\033[0;34m'; MAG='\033[0;35m'
BLD='\033[1m'; RST='\033[0m'

info()  { echo -e "${CYN}→${RST} $*"; }
ok()    { echo -e "${GRN}✓${RST} $*"; }
warn()  { echo -e "${YEL}⚠${RST} $*"; }
die()   { echo -e "${RED}✗${RST} $*" >&2; exit 1; }

# ── root check ───────────────────────────────────────────────
[[ $EUID -eq 0 ]] || die "Run as root: sudo $0 ${1:-}"

echo -e "\n${BLD}${MAG}✦ SDDM Theme Installer ✦${RST}\n"

# ── detect Qt version used by SDDM ───────────────────────────
detect_qt_version() {
  if command -v sddm &>/dev/null; then
    local v
    v=$(sddm --version 2>/dev/null | grep -oP 'Qt \K[\d]+' || true)
    [[ -n "$v" ]] && { echo "$v"; return; }
  fi
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
info "Detected SDDM Qt version: ${BLD}Qt${QT_VER}${RST}"

# ── check dependencies ────────────────────────────────────────
install_missing() {
  local pm=$1
  shift
  local pkgs=("$@")
  info "Installing missing dependencies: ${BLD}${pkgs[*]}${RST}"
  case "$pm" in
    pacman) pacman -S --noconfirm "${pkgs[@]}" ;;
    apt)    apt update && apt install -y "${pkgs[@]}" ;;
    dnf)    dnf install -y "${pkgs[@]}" ;;
    zypper) zypper install -y "${pkgs[@]}" ;;
  esac
}

check_deps_qt6() {
  local pm=""
  local missing=()
  if command -v pacman &>/dev/null; then
    pm="pacman"
    for pkg in qt6-declarative qt6-5compat qt6-svg; do
      pacman -Qq "$pkg" &>/dev/null || missing+=("$pkg")
    done
  elif command -v apt &>/dev/null; then
    pm="apt"
    for pkg in qml6-module-qtquick qml6-module-qt5compat-graphicaleffects libqt6svg6; do
      dpkg -l "$pkg" &>/dev/null || missing+=("$pkg")
    done
  elif command -v dnf &>/dev/null; then
    pm="dnf"
    for pkg in qt6-qtdeclarative qt6-qt5compat qt6-qtsvg; do
      rpm -q "$pkg" &>/dev/null || missing+=("$pkg")
    done
  elif command -v zypper &>/dev/null; then
    pm="zypper"
    for pkg in qt6-declarative qt6-5compat qt6-svg; do
      rpm -q "$pkg" &>/dev/null || missing+=("$pkg")
    done
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    if [[ -n "$pm" ]]; then
      install_missing "$pm" "${missing[@]}"
    else
      warn "Missing Qt6 packages: ${missing[*]} (Install manually)"
    fi
  else
    ok "All required system dependencies are installed."
  fi
}

check_deps_qt5() {
  local pm=""
  local missing=()
  if command -v pacman &>/dev/null; then
    pm="pacman"
    for pkg in qt5-declarative qt5-graphicaleffects qt5-quickcontrols2; do
      pacman -Qq "$pkg" &>/dev/null || missing+=("$pkg")
    done
  elif command -v apt &>/dev/null; then
    pm="apt"
    for pkg in qml-module-qtquick2 qml-module-qtgraphicaleffects qml-module-qtquick-controls2; do
      dpkg -l "$pkg" &>/dev/null || missing+=("$pkg")
    done
  elif command -v dnf &>/dev/null; then
    pm="dnf"
    for pkg in qt5-qtdeclarative qt5-qtgraphicaleffects qt5-qtquickcontrols2; do
      rpm -q "$pkg" &>/dev/null || missing+=("$pkg")
    done
  elif command -v zypper &>/dev/null; then
    pm="zypper"
    for pkg in libqt5-qtdeclarative qt5-graphicaleffects; do
      rpm -q "$pkg" &>/dev/null || missing+=("$pkg")
    done
  fi

  if [[ ${#missing[@]} -gt 0 ]]; then
    if [[ -n "$pm" ]]; then
      install_missing "$pm" "${missing[@]}"
    else
      warn "Missing Qt5 packages: ${missing[*]} (Install manually)"
    fi
  else
    ok "All required system dependencies are installed."
  fi
}

if [[ "$QT_VER" == "6" ]]; then
  check_deps_qt6
else
  check_deps_qt5
fi
echo ""

# ── gather themes ────────────────────────────────────────────
THEMES=()
for d in "$THEMES_DIR"/*/; do
  if [[ -f "$d/metadata.desktop" ]]; then
    THEMES+=("$(basename "$d")")
  fi
done

# ── menu or argument ─────────────────────────────────────────
THEME="${1:-}"

if [[ -z "$THEME" ]]; then
  echo -e "${BLD}Available themes to install:${RST}\n"
  
  num_themes=${#THEMES[@]}
  half=$(( (num_themes + 1) / 2 ))
  
  for ((i=0; i<half; i++)); do
    j=$((i + half))
    t1="${THEMES[$i]}"
    # format index nicely
    idx1=$(printf "%2d" $((i+1)))
    pad1=$(printf '%*s' $(( 32 - ${#t1} )) '')
    col1="  ${BLD}${CYN}${idx1})${RST} ${t1}${pad1}"
    
    if [[ $j -lt $num_themes ]]; then
      t2="${THEMES[$j]}"
      idx2=$(printf "%2d" $((j+1)))
      col2="  ${BLD}${CYN}${idx2})${RST} ${t2}"
      echo -e "$col1 $col2"
    else
      echo -e "$col1"
    fi
  done
  
  echo ""
  read -p "$(echo -e "${BLD}Enter the number of the theme you want to install:${RST} ")" choice
  
  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "$num_themes" ]; then
    die "Invalid selection."
  fi
  THEME="${THEMES[$((choice-1))]}"
  echo ""
fi

# ── validate theme exists ────────────────────────────────────
THEME_SRC="$THEMES_DIR/$THEME"
[[ -d "$THEME_SRC" ]]            || die "Theme '$THEME' not found."
[[ -f "$THEME_SRC/Main.qml" ]]   || die "Theme '$THEME' is missing Main.qml — broken theme folder"
[[ -f "$THEME_SRC/metadata.desktop" ]] || die "Theme '$THEME' is missing metadata.desktop — SDDM won't load it"

# ── path safety: never rm -rf outside /usr/share/sddm/themes ─
DEST="$SDDM_THEMES/$THEME"
[[ "$DEST" == /usr/share/sddm/themes/* ]] \
  || die "Destination path looks wrong: $DEST — aborting for safety"

# ── Qt5 transpile: patch import lines if needed ───────────────
transpile_for_qt5() {
  local dest_qml="$1"
  info "Patching QML imports for Qt5 compatibility…"

  find "$dest_qml" -name "*.qml" | while read -r f; do
    perl -i -pe '
      s/^(\s*import\s+QtQuick\s*)(\n|$)/${1}2.15\n/;
      s/^(\s*import\s+QtQuick\.Controls\s*)(\n|$)/${1}2.15\n/;
      s/^(\s*import\s+QtQuick\.Layouts\s*)(\n|$)/${1}1.15\n/;
      s/^(\s*import\s+Qt5Compat\.GraphicalEffects\b)/import QtGraphicalEffects 1.0/;
    ' "$f"
  done
  ok "Qt5 import patching done"
}

# ── backup existing theme & config ────────────────────────────
if [[ -d "$DEST" ]]; then
  BACKUP="${DEST}.backup.$(date +%Y%m%d_%H%M%S)"
  info "Backing up existing theme to $BACKUP"
  cp -r "$DEST" "$BACKUP" || true
fi

if [[ -f "$SDDM_CONF" ]]; then
  CONF_BACKUP="${SDDM_CONF}.backup.$(date +%Y%m%d_%H%M%S)"
  info "Backing up sddm.conf to $CONF_BACKUP"
  cp "$SDDM_CONF" "$CONF_BACKUP" || true
fi

# ── copy theme ────────────────────────────────────────────────
info "Installing '${BLD}${THEME}${RST}' → $DEST"
rm -rf "$DEST"
mkdir -p "$DEST"
cp -r "$THEME_SRC"/. "$DEST"/

# ── patch for Qt5 if needed ───────────────────────────────────
if [[ "$QT_VER" == "5" ]]; then
  transpile_for_qt5 "$DEST"
fi

# ── fix permissions so sddm user can read ────────────────────
chmod -R a+rX "$DEST"

# ── update /etc/sddm.conf ────────────────────────────────────
info "Setting Current=${BLD}${THEME}${RST} in $SDDM_CONF"
touch "$SDDM_CONF"

if grep -q '^\[Theme\]' "$SDDM_CONF"; then
  if grep -q '^Current=' "$SDDM_CONF"; then
    sed -i "s|^Current=.*|Current=$THEME|" "$SDDM_CONF"
  else
    sed -i "/^\[Theme\]/a Current=$THEME" "$SDDM_CONF"
  fi
else
  printf '\n[Theme]\nCurrent=%s\n' "$THEME" >> "$SDDM_CONF"
fi

CONFD="/etc/sddm.conf.d"
if [[ -d "$CONFD" ]]; then
  for f in "$CONFD"/*.conf; do
    [[ -f "$f" ]] && grep -q '^Current=' "$f" && \
      sed -i "s|^Current=.*|Current=$THEME|" "$f" && \
      info "Also updated $f"
  done
fi

# ── done ─────────────────────────────────────────────────────
echo -e "\n${BLD}${MAG}✦ Success! ✦${RST}"
echo -e "${GRN}Enjoy your gorgeous new ${BLD}${THEME}${RST}${GRN} login screen!${RST}\n"

echo -e "  ${CYN}Preview without rebooting:${RST}"
echo -e "    sddm-greeter --test-mode --theme $DEST"
echo -e "  ${CYN}Or for Qt6 systems:${RST}"
echo -e "    sddm-greeter-qt6 --test-mode --theme $DEST\n"

echo -e "  ${CYN}Apply permanently:${RST}"
echo -e "    systemctl restart sddm   (or reboot)\n"
