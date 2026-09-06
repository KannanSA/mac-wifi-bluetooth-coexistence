#!/bin/bash

set -euo pipefail

LABEL="com.github.kannansa.wifi-bluetooth-coexistence"
DESTINATION="/Library/LaunchDaemons/${LABEL}.plist"

if [[ "$(uname -s)" != "Darwin" ]]; then
    printf 'This status check supports macOS only.\n' >&2
    exit 1
fi

if [[ -f "${DESTINATION}" ]] && /bin/launchctl print "system/${LABEL}" >/dev/null 2>&1; then
    printf 'Workaround: installed and loaded\n'
else
    printf 'Workaround: not installed\n'
fi

if ! AWDL_LINE="$(/sbin/ifconfig awdl0 2>/dev/null | /usr/bin/head -n 1)"; then
    printf 'AWDL interface: unavailable\n'
elif [[ "${AWDL_LINE}" == *"<UP,"* ]]; then
    printf 'AWDL interface: enabled\n'
else
    printf 'AWDL interface: disabled\n'
fi
