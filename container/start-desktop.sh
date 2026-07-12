#!/usr/bin/env bash
set -euo pipefail
export HOME=/opt/data/home
mkdir -p "$HOME/.vnc" "$HOME/Desktop"
printf '%s\n' "${VNC_PASSWORD:-hermes}" | vncpasswd -f > "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"
cp -f /usr/share/applications/hermes-terminal.desktop "$HOME/Desktop/Hermes.desktop"
chmod +x "$HOME/Desktop/Hermes.desktop"
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
Xtigervnc :1 -geometry "${VNC_GEOMETRY:-1440x900}" -depth 24 \
  -rfbport 5901 -rfbauth "$HOME/.vnc/passwd" -localhost no \
  -SecurityTypes VncAuth -AlwaysShared -AcceptKeyEvents -AcceptPointerEvents &
vnc_pid=$!
trap 'kill "$vnc_pid" 2>/dev/null || true' EXIT INT TERM
for _ in {1..50}; do
  [[ -S /tmp/.X11-unix/X1 ]] && break
  sleep 0.1
done
[[ -S /tmp/.X11-unix/X1 ]] || { echo "VNC X server failed to create display :1" >&2; exit 1; }
dbus-launch --exit-with-session startxfce4
