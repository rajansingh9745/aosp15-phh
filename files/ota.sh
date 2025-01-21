#!/system/bin/sh

set -ex

# Verify if the device supports dynamic partitions
if [ "$(getprop ro.boot.dynamic_partitions)" != "true" ]; then
    echo "OTA is supported only for devices with dynamic partitions!"
    exit 1
fi

# Get the device flavor
flavor=$(getprop ro.product.product.name)
if [ -f /system/phh/secure ]; then
    flavor="${flavor}-secure"
fi

# Define the base OTA path on the SD card
BASE_PATH="/sdcard/ota"
OTA_PATH="${BASE_PATH}/${flavor}"
NEXT_VERSION_FILE="${OTA_PATH}/date"
URL_FILE="${OTA_PATH}/url"
SIZE_FILE="${OTA_PATH}/size"

# Check for the existence of necessary OTA files
if [ ! -f "$NEXT_VERSION_FILE" ] || [ ! -f "$URL_FILE" ] || [ ! -f "$SIZE_FILE" ]; then
    echo "OTA files not found in ${OTA_PATH}"
    exit 1
fi

# Read the OTA details
nextVersion=$(cat "$NEXT_VERSION_FILE")
if [ -z "$nextVersion" ]; then
    echo "Invalid OTA version in ${NEXT_VERSION_FILE}"
    exit 1
fi

url=$(cat "$URL_FILE")
size=$(cat "$SIZE_FILE")

# Prevent installing the same version
if [ "$(getprop ro.product.build.date.utc)" = "$nextVersion" ]; then
    echo "Installing the same version ($nextVersion) is not allowed. Aborting."
    exit 1
fi

# Warn if the current build is not in known releases
if ! grep -q "$(getprop ro.product.build.date.utc)" "${OTA_PATH}/known_releases" 2>/dev/null; then
    echo "Warning: The current build is unknown. Type YES to proceed with OTA update from ${url}"
    read answer
    if [ "$answer" != "YES" ]; then
        exit 1
    fi
fi

# Warn about potential system image modifications
if [ -b /dev/tmp-phh ] && ! tune2fs -l /dev/tmp-phh | grep 'Last mount time' | grep -q n/a; then
    echo "Warning: It appears the system image has been modified. Flashing this OTA will revert those changes!"
    echo "Type YES to acknowledge and continue."
    read answer
    if [ "$answer" != "YES" ]; then
        exit 1
    fi
fi

# Start the flashing process
echo "Flashing OTA from ${url}..."

dmDevice=$(phh-ota new-slot)
cat "$url" | busybox_phh xz -d -c > "$dmDevice"
phh-ota switch-slot

# Reboot the device to complete the update
reboot
exit 0
