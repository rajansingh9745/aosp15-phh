#!/bin/bash

# Clone each repository
echo "Cloning TrebleDroid/vendor_hardware_overlay..."
git clone https://github.com/TrebleDroid/vendor_hardware_overlay -b pie vendor/hardware_overlay

echo "Cloning TrebleDroid/vendor_interfaces..."
git clone https://github.com/TrebleDroid/vendor_interfaces -b android-14.0 vendor/interfaces

echo "Cloning TrebleDroid/treble_app..."
git clone https://github.com/TrebleDroid/treble_app -b master treble_app

echo "Cloning phhusson/vendor_magisk..."
git clone https://github.com/phhusson/vendor_magisk -b android-10.0 vendor/magisk

echo "Cloning AndyCGYan/android_packages_apps_QcRilAm..."
git clone https://github.com/AndyCGYan/android_packages_apps_QcRilAm -b master packages/apps/QcRilAm

echo "Cloning platform/prebuilts/vndk/v28..."
git clone https://github.com/rajansingh9745/prebuilts_vndk_v28-modified --depth=1 prebuilts/vndk/v28

echo "All repositories cloned successfully."
