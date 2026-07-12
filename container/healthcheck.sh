#!/usr/bin/env bash
set -euo pipefail
supervisorctl -s unix:///tmp/supervisor.sock status desktop | grep -q RUNNING
supervisorctl -s unix:///tmp/supervisor.sock status novnc | grep -q RUNNING
curl -fsS --max-time 2 http://127.0.0.1:6080/vnc.html >/dev/null
