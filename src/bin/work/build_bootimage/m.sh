#!/bin/bash

. ~/.bin/normal/lib/list

function get_board_name() {
	while read line; do
		[[ $line =~ "Kernel Configuration" ]] && {
		KERNEL_VERSION=$(echo "$line" | cut -d " " -f 3)
		}
		[[ $line =~ "CONFIG_BOARD_NAME" ]] && {
			line=${line#*\"}
			BOARD_NAME=${line%%\"*}
			break
		}
	done < ../.config
}

get_board_name
echo -e "\n  KERNEL_VERSION is \"$KERNEL_VERSION\" BOARD_NAME is \"$BOARD_NAME\""

#BOOTFS=$(showlist ramdisk/list)
#[ "$BOOTFS" -eq "0" ] && exit

BOOTFS=root-5.1-mercury
RAMDISK=ramdisk-$BOOTFS.img
KERNEL=zImage-$BOOTFS
OUT=boot-$BOOTFS.img

#dorado
#CMD="mem=256M@0x0 mem=752M@0x30000000 console=ttyS3,57600n8 ip=off root=/dev/ram0 rw rdinit=/init"

#mercury
CMD="console=ttyS3,57600n8 mem=255M@0x0 mem=256M@0x30000000 ip=off root=/dev/ram0 rw rdinit=/init rd_start=0x81A00000 rd_size=0x000EA8EF"

cp ../arch/mips/boot/compressed/zImage  kernel/$KERNEL
[ ! -f ramdisk/$RAMDISK ] && { echo no ramdisk.img; ./tools/mkbootfs ramdisk/$BOOTFS | ./tools/minigzip > ramdisk/$RAMDISK; }
./tools/mkbootimg  --kernel "kernel/$KERNEL" --ramdisk "ramdisk/$RAMDISK" --base 0x80000000  --output out/$OUT

echo 
echo "$PWD/out/$OUT"
echo 

OUT_IMAGE=bootimg/kernel4_4_$(date +%Y-%m-%d_%H:%M).img
#bootimg/newton2/kernel4_4.img
#dorado_v_21/android5.0/kernel5_0.img

echo "scp out/$OUT user@192.168.4.150:~/boards/mercury/"
scp "out/$OUT" user@192.168.4.150:~/boards/mercury/
