#!/system/bin/sh

set -ex

# Verify if the device supports dynamic partitions
if [ "$(getprop ro.boot.dynamic_partitions)" != "true" ]; then
    echo "OTA is supported only for devices with dynamic partitions!"
    exit 1
fi

# Define the OTA path on the SD card
BASE_PATH="/sdcard/ota"
OTA_FILE="${BASE_PATH}/ota_file.img"

# Check if the OTA file exists
if [ ! -f "$OTA_FILE" ]; then
    echo "OTA file not found in ${BASE_PATH}"
    exit 1
fi

# Start the flashing process
echo "Flashing OTA from ${OTA_FILE}..."

dmDevice=$(phh-ota new-slot)
cat "$OTA_FILE" > "$dmDevice"
phh-ota switch-slot

# Reboot the device to complete the update
reboot
exit 0
