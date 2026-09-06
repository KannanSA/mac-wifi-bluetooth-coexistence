# Mac Wi-Fi/Bluetooth Coexistence Workaround

A small, reversible macOS workaround for Macs whose Wi-Fi disconnects when Bluetooth is enabled.

The utility keeps the Apple Wireless Direct Link interface (`awdl0`) down. AWDL is used for nearby peer-to-peer features and can trigger Wi-Fi/Bluetooth coexistence faults on affected hardware or driver versions. Normal Wi-Fi and ordinary Bluetooth accessories continue to work.

## Before installing

This workaround disables features that depend on AWDL:

- AirDrop
- Sidecar
- Universal Control
- peer-to-peer AirPlay
- some Handoff and nearby-device functions

Apple's first recommendation is to use 5 GHz Wi-Fi and reduce wireless interference. Try that before installing this workaround: [Resolve Wi-Fi and Bluetooth issues caused by wireless interference](https://support.apple.com/102319).

## Requirements

- macOS
- an administrator account
- a built-in `awdl0` interface

## Install

```sh
git clone https://github.com/KannanSA/mac-wifi-bluetooth-coexistence.git
cd mac-wifi-bluetooth-coexistence
./install.sh
```

The installer asks for the administrator password, installs one launch daemon, and disables AWDL immediately. The daemon reapplies the setting after startup and every 30 seconds in case macOS recreates the interface.

## Check status

```sh
./status.sh
```

## Uninstall

```sh
./uninstall.sh
```

The uninstaller removes the launch daemon and brings `awdl0` back up. Restart the Mac if an Apple nearby-device feature does not return immediately.

## What it changes

The installer adds only this file:

```text
/Library/LaunchDaemons/com.github.kannansa.wifi-bluetooth-coexistence.plist
```

It does not modify saved Wi-Fi networks, passwords, DNS settings, Bluetooth pairings, or system files.

## When to seek service

If Wi-Fi still disconnects while this workaround is active, run [Apple Diagnostics](https://support.apple.com/102550). A repeatable failure across different Wi-Fi networks can indicate a fault in the shared Wi-Fi/Bluetooth hardware.

## License

2026 Copyright Kannan Sekar Annu Radha
