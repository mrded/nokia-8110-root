#!/tmp/busybox sh

SETTINGSFILE='/system/b2g/defaults/settings.json'
PREFFILE='/system/b2g/defaults/pref/user.js'

# mount /system and /sdcard
/tmp/busybox mount -t ext4 -o rw /dev/block/bootdevice/by-name/system /system
/tmp/busybox mount -t vfat -o rw /dev/block/mmcblk1p1 /sdcard

# create a backup file on memory card
TIMESTAMP=`date +%s`
/tmp/busybox cp $SETTINGSFILE /sdcard/b2g-settings-backup.$TIMESTAMP.json
/tmp/busybox cp $PREFFILE /sdcard/b2g-pref-backup.$TIMESTAMP.json

# unmount /sdcard after creating the backup
/tmp/busybox umount /sdcard

# replace the developer menu setting entries
/tmp/busybox sed -i 's/"developer.menu.enabled":false/"developer.menu.enabled":true/g' $SETTINGSFILE
/tmp/busybox sed -i 's/"debug.console.enabled":false/"debug.console.enabled":true/g' $SETTINGSFILE
echo "pref('developer.menu.enabled', true);" >> $PREFFILE
echo "pref('debug.console.enabled', true);" >> $PREFFILE

# unmount /system
/tmp/busybox umount /system
echo "Changes applied"
