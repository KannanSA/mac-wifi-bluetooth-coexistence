#!/bin/bash

set -euo pipefail

LABEL="com.github.kannansa.wifi-bluetooth-coexistence"
DESTINATION="/Library/LaunchDaemons/${LABEL}.plist"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${SCRIPT_DIR}/launchd/${LABEL}.plist"

if [[ "$(uname -s)" != "Darwin" ]]; then
    printf 'This workaround supports macOS only.\n' >&2
    exit 1
fi

if [[ ! -f "${SOURCE}" ]]; then
    printf 'Missing launch daemon: %s\n' "${SOURCE}" >&2
    exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
    exec /usr/bin/sudo -- "$0" "$@"
fi

if [[ -f "${DESTINATION}" ]]; then
    /bin/launchctl bootout system "${DESTINATION}" >/dev/null 2>&1 || true
fi

/usr/bin/install -o root -g wheel -m 644 "${SOURCE}" "${DESTINATION}"
/bin/launchctl bootstrap system "${DESTINATION}"

if /sbin/ifconfig awdl0 >/dev/null 2>&1; then
    /sbin/ifconfig awdl0 down
fi

printf 'Installed %s\n' "${LABEL}"
printf 'Wi-Fi and ordinary Bluetooth remain available. AirDrop and other AWDL features are disabled.\n'
