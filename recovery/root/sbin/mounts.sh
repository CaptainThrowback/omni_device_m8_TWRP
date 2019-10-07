#!/sbin/sh

# Remove /system bind mount
umount "$ANDROID_ROOT"
rm -f /system

# Symlink tzdata
mkdir -p /system/usr/share/zoneinfo
ln -s /sbin/tzdata /system/usr/share/zoneinfo/tzdata

exit 0