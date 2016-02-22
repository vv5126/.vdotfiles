#!/bin/bash

. ~/.bin/lib/lib.list
. ../.project_info

have_root=($(ls -l ramdisk |grep ^d | awk '{print $9}'))

BOOTFS=
for i in "${have_root[@]}"; do
    [[ $i =~ "${forOS%_*}" ]] && [[ $i =~ "${forBOARD%_*}" ]] \
        && [[ $i =~ "${forOS##*_}" ]] && [[ $i =~ "${forBOARD##*_}" ]] && { BOOTFS=$i; break; }
done

echo -e "\n  Make bootfs for OS \"$forOS\" and BOARD_NAME is \"$forBOARD\""
RAMDISK=ramdisk-$BOOTFS.img
KERNEL=zImage-$BOOTFS
OUT=$target_name
# echo RAMDISK=$RAMDISK
# echo KERNEL=$KERNEL
# echo OUT=$target_name
# exit

# case $forBOARD in
# 'dorado'*)
#     CMD="mem=256M@0x0 mem=752M@0x30000000 console=ttyS3,57600n8 ip=off root=/dev/ram0 rw rdinit=/init"
#     ;;
# 'mercury'*)
#     CMD="console=ttyS3,57600n8 mem=255M@0x0 mem=256M@0x30000000 ip=off root=/dev/ram0 rw rdinit=/init rd_start=0x81A00000 rd_size=0x000EA8EF"
#     ;;
# *)
#     CMD="mem=256M@0x0 mem=752M@0x30000000 console=ttyS3,57600n8 ip=off root=/dev/ram0 rw rdinit=/init"
#     ;;
# esac

[ -f ../arch/mips/boot/compressed/zImage ] && \
    cp ../arch/mips/boot/compressed/zImage  kernel/$KERNEL || \
    { echo "couldn't find the right zImage!"; exit 1; }

if [ -n $BOOTFS ]; then
    echo -e "\n  here will use ramdisk \"$RAMDISK\"."
    [ ! -f ramdisk/$RAMDISK ] && { ./tools/mkbootfs ramdisk/$BOOTFS | ./tools/minigzip > ramdisk/$RAMDISK; }
else
    { echo "couldn't find the ramdisk dir!"; exit 1; }
fi

./tools/mkbootimg  --kernel "kernel/$KERNEL" --ramdisk "ramdisk/$RAMDISK" --base 0x80000000  --output out/$OUT

exit $?
