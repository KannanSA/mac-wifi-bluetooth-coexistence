#!/bin/bash

set -euo pipefail

LABEL="com.github.kannansa.wifi-bluetooth-coexistence"
DESTINATION="/Library/LaunchDaemons/${LABEL}.plist"

if [[ "$(uname -s)" != "Darwin" ]]; then
    printf 'This workaround supports macOS only.\n' >&2
    exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
    exec /usr/bin/sudo -- "$0" "$@"
fi

if [[ -f "${DESTINATION}" ]]; then
    /bin/launchctl bootout system "${DESTINATION}" >/dev/null 2>&1 || true
    /bin/rm -- "${DESTINATION}"
fi

if /sbin/ifconfig awdl0 >/dev/null 2>&1; then
    /sbin/ifconfig awdl0 up
fi

printf 'Uninstalled %s\n' "${LABEL}"
printf 'AWDL is enabled again. Restart macOS if a nearby-device feature does not return immediately.\n'
