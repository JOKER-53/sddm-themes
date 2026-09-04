#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  cozylock — SDDM theme installer
#  Usage:  sudo ./install.sh <theme-id>
#  Example: sudo ./install.sh marvel
# ─────────────────────────────────────────────────────────────
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$REPO_DIR"
SDDM_THEMES="/usr/share/sddm/themes"
SDDM_CONF="/etc/sddm.conf"

# ── colours ──────────────────────────────────────────────────
RED='\033[0;31m'; YEL='\033[1;33m'; GRN='\033[0;32m'
CYN='\033[0;36m'; BLD='\033[1m'; RST='\033[0m'

info()  { echo -e "${CYN}→${RST} $*"; }
ok()    { echo -e "${GRN}✓${RST} $*"; }
warn()  { echo -e "${YEL}⚠${RST} $*"; }
die()   { echo -e "${RED}✗${RST} $*" >&2; exit 1; }

# ── root check ───────────────────────────────────────────────
[[ $EUID -eq 0 ]] || die "Run as root: sudo $0 ${1:-<theme-id>}"

# ── theme arg ────────────────────────────────────────────────
THEME="${1:-}"
if [[ -z "$THEME" ]]; then
  echo -e "${BLD}Available themes:${RST}"
  for d in "$THEMES_DIR"/*/; do
    [[ -f "$d/metadata.desktop" ]] && echo "  • $(basename "$d")"
  done
  echo
  echo "Usage: sudo $0 <theme-id>"
  exit 1
fi

# ── validate theme exists ────────────────────────────────────
THEME_SRC="$THEMES_DIR/$THEME"
[[ -d "$THEME_SRC" ]]            || die "Theme '$THEME' not found in $THEMES_DIR"
[[ -f "$THEME_SRC/Main.qml" ]]   || die "Theme '$THEME' is missing Main.qml — broken theme folder"
[[ -f "$THEME_SRC/metadata.desktop" ]] || die "Theme '$THEME' is missing metadata.desktop — SDDM won't load it"

# ── path safety: never rm -rf outside /usr/share/sddm/themes ─
DEST="$SDDM_THEMES/$THEME"
[[ "$DEST" == /usr/share/sddm/themes/* ]] \
  || die "Destination path looks wrong: $DEST — aborting for safety"

# ── detect Qt version used by SDDM ───────────────────────────
detect_qt_version() {
  # Try sddm binary first
  if command -v sddm &>/dev/null; then
    local v
    v=$(sddm --version 2>/dev/null | grep -oP 'Qt \K[\d]+' || true)
    [[ -n "$v" ]] && { echo "$v"; return; }
  fi
  # Fallback: check which qt6/qt5 sddm package is installed
  if pacman -Qq sddm &>/dev/null 2>&1; then
    # Arch — check if sddm depends on qt6
    pacman -Qi sddm 2>/dev/null | grep -q 'qt6' && { echo "6"; return; }
    echo "5"; return
  fi
  if dpkg -l sddm &>/dev/null 2>&1; then
    dpkg -l | grep -q 'sddm-qt6\|qt6-sddm' && { echo "6"; return; }
    echo "5"; return
  fi
  # Default assumption: modern systems use Qt6
  echo "6"
}

QT_VER=$(detect_qt_version)
info "Detected SDDM Qt version: Qt${QT_VER}"

# ── check dependencies ────────────────────────────────────────
install_missing() {
  local pm=$1
  shift
  local pkgs=("$@")
  info "Installing missing dependencies: ${pkgs[*]}"
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
    ok "All Qt6 dependencies satisfied."
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
    ok "All Qt5 dependencies satisfied."
  fi
}

if [[ "$QT_VER" == "6" ]]; then
  check_deps_qt6
else
  check_deps_qt5
fi

# ── Qt5 transpile: patch import lines if needed ───────────────
# Qt6 QML uses:  import QtQuick               (unversioned)
#                import Qt5Compat.GraphicalEffects
# Qt5 QML needs: import QtQuick 2.15
#                import QtGraphicalEffects 1.0
transpile_for_qt5() {
  local dest_qml="$1"
  info "Patching QML imports for Qt5 compatibility…"

  find "$dest_qml" -name "*.qml" | while read -r f; do
    # Unversioned "import QtQuick" → "import QtQuick 2.15"
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
  ok "Backup saved: $BACKUP"
fi

if [[ -f "$SDDM_CONF" ]]; then
  CONF_BACKUP="${SDDM_CONF}.backup.$(date +%Y%m%d_%H%M%S)"
  info "Backing up sddm.conf to $CONF_BACKUP"
  cp "$SDDM_CONF" "$CONF_BACKUP" || true
fi

# ── copy theme ────────────────────────────────────────────────
info "Installing '$THEME' → $DEST"
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
info "Setting Current=$THEME in $SDDM_CONF"
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

# ── also check /etc/sddm.conf.d/ ─────────────────────────────
CONFD="/etc/sddm.conf.d"
if [[ -d "$CONFD" ]]; then
  for f in "$CONFD"/*.conf; do
    [[ -f "$f" ]] && grep -q '^Current=' "$f" && \
      sed -i "s|^Current=.*|Current=$THEME|" "$f" && \
      info "Also updated $f"
  done
fi

# ── done ─────────────────────────────────────────────────────
echo
ok "Done! Theme '${BLD}${THEME}${RST}' installed."
echo
echo -e "  ${CYN}Test without rebooting:${RST}"
echo -e "    sddm-greeter --test-mode --theme $DEST"
echo -e "  ${CYN}Or for Qt6 systems:${RST}"
echo -e "    sddm-greeter-qt6 --test-mode --theme $DEST"
echo
echo -e "  ${CYN}Apply permanently:${RST}"
echo -e "    systemctl restart sddm   (or reboot)"
echo
