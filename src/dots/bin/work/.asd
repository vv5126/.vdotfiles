
-------------------------------------------------------------------------------
我给AVS做了repo工程，下载方式如下：

repo init -u ssh://192.168.1.26:29418/Manhattan/platform/manifest -b 
mozart-avs
repo sync

1. 首先执行envsetup.sh脚本配置编译环境
    source build/envsetup.sh

2.直接全编整个系统：
v23板子：
        #make v23
V10板子：
        #make v10
-------------------------------------------------------------------------------
mkfs:
sudo mkfs.jffs2 -e 0x8000 -p0xa00000 -d $ROOTFS_DIR -o $ROOTFS_TARGET
-------------------------------------------------------------------------------
mount:

mount -t vfat /dev/sda1 /mnt/usb/

mount_nfs:
serverip=10.220.4.120
serverpath=/home/gaowei
localpath=/mnt/nfs
mount -o nolock,wsize=1024,rsize=1024 $serverip:$serverpath $localpath
-------------------------------------------------------------------------------
wifi no mac:
#define BOOTARGS_COMMON BOOTARGS_BASE " wifi_mac=94A1A284903C "
-------------------------------------------------------------------------------
ctags -R .  -exclude=./Documentation/ -exclude=./.git/ -exclude=./arch/ -recurse=./arch/mips/xburst/
ctags -vR * --exclude="./arch/" --exclude="./drivers/"
-------------------------------------------------------------------------------
arecord -d 10 -f S16_LE -t wav -c 1 -D hw0,0 -r 16000 foobar.wav

amixer cset numid=6,iface=MIXER,name='Mic Volume' 4

amixer cset numid=1 10; aplay /tmp/1Khz.wav &


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


#auto get ip
#udhcpc

#config ip netmask gw
#ifconfig eth0 172.20.223.123 netmask 255.255.255.0 up
#route add default gw 172.20.223.254

find . -not -wholename '*.svn*' -not -regex '.*\.\(png\|gif\)' -type f -printf "%f\t%p\t1\n" | sort -f >> tags.filename

mipsel-linux-android:
ssh://192.168.1.26:29418/toolchains/install/mipsel-linux-android-4.7

mkdir build
cd build
cmake -D CMAKE_EXPORT_COMPILE_COMMANDS=ON ..

cmake -D CMAKE_INSTALL_PREFIX=/usr "CMakeLists.txt dir"



下面的下载方式可以将molib库下载并编译，供开发人员使用，由于molib库是保密的，请勿外传！
> repo init -u ssh://192.168.1.26:29418/Manhattan/platform/manifest -b dev/mozart-avs 

echo mem > /sys/power/state


http://192.168.1.59/Citrix/XenApp/site/default.aspx
kernel

set ipaddr 192.168.10.203
set bootargs mem=256M@0x0 mem=256M@0x30000000 console=ttyS3,115200 ip=192.168.10.203:192.168.4.13:192.168.10.1:255.255.255.0 nfsroot=192.168.4.13:/home/nfsroot/fpga/rootfs/root_ok rw 
tftp 0x80600000 192.168.4.13:fpga/user/wgao/uImage; bootm 0x80600000

set bootargs mem=128M@0x0 mem=128M@0x30000000 console=ttyS3,115200 ip=192.168.10.203:192.168.4.13:192.168.10.1:255.255.255.0 nfsroot=192.168.4.13:/home/nfsroot/fpga/rootfs/root_ok rw 

-------------------------------------------------------------------------------
FPGA T10:
scp ~/t10-fpga/kernel-3.0.8/arch/mips/boot/compressed/uImage fpga@192.168.4.13:/home/nfsroot/fpga/user/wgao/uImage

ssh -X fpga@192.168.4.13

tftp 0x80600000 192.168.4.13:fpga/user/wgao/fpga/t10_lcd/f-Image; bootm 0x80600000
tftp 0x80600000 192.168.4.13:fpga/user/wgao/uImage; bootm 0x80600000
tftp 0x80800000 user/wgao/uImage; bootm 0x80800000

set bootargs 'console=ttyS2,115200n8 mem=32M@0x0 loglevel=7 ip=192.168.4.254:192.168.4.1:192.168.4.1:255.255.255.0 rootdelay=2 nfsroot=192.168.4.13:user/bliu/root_ok rw'
tftpboot 0x80800000 user/wgao/uImage;bootm 0x80800000
-------------------------------------------------------------------------------
confprosh
cfg_open haps6x com:/dev/ttyUSB0
cfg_clock_get_frequency cfg0 fb1 pll1_1
cfg_clock_set_frequency cfg0 fb1 pll1_1 20000 (KHZ)
pll 1_ 1...3   gclk1-3
pll 2_ 1...3   gclk4-6
exit
-------------------------------------------------------------------------------
set bootargs mem=256M@0x0 mem=256M@0x30000000 console=ttyS3,115200 ip=192.168.10.201:192.168.4.4:192.168.10.1:255.255.255.0 nfsroot=192.168.4.4:/tftpboot/fpga/rootfs/root_ok rw

//right
---------------------LCDC-------------------------
LCD_LCDCFG              12000d0d                0b 00010010 00000000 00001101 00001101
LCD_LCDCTRL             c000000d                0b 11000000 00000000 00000000 00001101
LCD_LCDSTATE            00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDOSDC             0048000d                0b 00000000 01001000 00000000 00001101
LCD_LCDOSDCTRL          00000005                0b 00000000 00000000 00000000 00000101
LCD_LCDOSDS             00000000                0b 00000000 00000000 00000000 00000000
REG_LCDRGBC             00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDALPHA            0000ffff                0b 00000000 00000000 11111111 11111111
LCD_LCDBGC0             00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDBGC1             00000000                0b 00000000 00000000 00000000 00000000
--------------------------------------------------
LCD_LCDVAT              00f000f0                0b 00000000 11110000 00000000 11110000
LCD_LCDDAH              000000f0                0b 00000000 00000000 00000000 11110000
LCD_LCDDAV              000000f0                0b 00000000 00000000 00000000 11110000
LCD_LCDVSYNC            00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDHSYNC            00000000                0b 00000000 00000000 00000000 00000000
--------------------------------------------------
LCD_LCDXYP0             00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDSIZE0            00ef00ef                0b 00000000 11101111 00000000 11101111
LCD_LCDXYP1             00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDSIZE1            00ef00ef                0b 00000000 11101111 00000000 11101111
LCD_LCDIID              00000000                0b 00000000 00000000 00000000 00000000
--------------------------------------------------
LCD_LCDDA0              001d8280                0b 00000000 00011101 10000010 10000000
LCD_LCDSA0              001d8380                0b 00000000 00011101 10000011 10000000
LCD_LCDFID0             00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDCMD0             0400e100                0b 00000100 00000000 11100001 00000000
LCD_LCDOFFS0            00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDPW0              00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDCPOS0            00000004                0b 00000000 00000000 00000000 00000100
LCD_LCDDESSIZE0         00ef00ef                0b 00000000 11101111 00000000 11101111
--------------------------------------------------
LCD_LCDDA1              001d8080                0b 00000000 00011101 10000000 10000000
LCD_LCDSA1              00020700                0b 00000000 00000010 00000111 00000000
LCD_LCDFID1             00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDCMD1             0000e100                0b 00000000 00000000 11100001 00000000
LCD_LCDOFFS1            00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDPW1              00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDCPOS1            00000000                0b 00000000 00000000 00000000 00000000
LCD_LCDDESSIZE1         00ef00ef                0b 00000000 11101111 00000000 11101111
--------------------------------------------------
LCD_LCDPCFG             77ffffff                0b 01110111 11111111 11111111 11111111
LCD_LCDREV              00000000                0b 00000000 00000000 00000000 00000000
---------------------SLCD-------------------------
SLCD_REG_SLCD_MCFG              00001500                0b 00000000 00000000 00010101 00000000
SLCD_REG_SLCD_MCFG_NEW          00000101                0b 00000000 00000000 00000001 00000001
SLCD_REG_SLCD_MCTRL             00000001                0b 00000000 00000000 00000000 00000001
SLCD_REG_SLCD_MSTATE            00010001                0b 00000000 00000001 00000000 00000001
SLCD_REG_SLCD_MDATA             000000ef                0b 00000000 00000000 00000000 11101111
SLCD_REG_SLCD_WTIME             00000000                0b 00000000 00000000 00000000 00000000
SLCD_REG_SLCD_TASH              00000000                0b 00000000 00000000 00000000 00000000
SLCD_REG_SLCD_SMWT              00000000                0b 00000000 00000000 00000000 00000000
-------------------------------------------------
------------ DESC_COMMAND0 ---------801D8280---------
WORD [0]: next descriptor physical address              00020600                0b 00000000 00000010 00000110 00000000
WORD [1]: the buffer physical address                   00017180                0b 00000000 00000001 01110001 10000000
WORD [2]: the buffer ID value                           00000000                0b 00000000 00000000 00000000 00000000
WORD [3]: value for LCDCMDx.                            24000001                0b 00100100 00000000 00000000 00000001
WORD [4]: value for LCDOFFSx                            00000000                0b 00000000 00000000 00000000 00000000
WORD [5]: value for LCDPWx                              00000000                0b 00000000 00000000 00000000 00000000
WORD [6]: value for LCDCNUMx or for LCDCPOSx            00000004                0b 00000000 00000000 00000000 00000100
WORD [7]: contains the value for LCDDESSIZEx            00000000                0b 00000000 00000000 00000000 00000000
------------ descriptor0_1 ---------80020600-------
WORD [0]: next descriptor physical address              00020400                0b 00000000 00000010 00000100 00000000
WORD [1]: the buffer physical address                   001d8380                0b 00000000 00011101 10000011 10000000
WORD [2]: the buffer ID value                           00000000                0b 00000000 00000000 00000000 00000000
WORD [3]: value for LCDCMDx.                            0400e100                0b 00000100 00000000 11100001 00000000
WORD [4]: value for LCDOFFSx                            00000000                0b 00000000 00000000 00000000 00000000
WORD [5]: value for LCDPWx                              00000000                0b 00000000 00000000 00000000 00000000
WORD [6]: value for LCDCNUMx or for LCDCPOSx            2a000000                0b 00101010 00000000 00000000 00000000
WORD [7]: contains the value for LCDDESSIZEx            ff0ef0ef                0b 11111111 00001110 11110000 11101111
------------ DESC_COMMAND1 ---------80020400-------
WORD [0]: next descriptor physical address              00020500                0b 00000000 00000010 00000101 00000000
WORD [1]: the buffer physical address                   00017100                0b 00000000 00000001 01110001 00000000
WORD [2]: the buffer ID value                           00000000                0b 00000000 00000000 00000000 00000000
WORD [3]: value for LCDCMDx.                            24000001                0b 00100100 00000000 00000000 00000001
WORD [4]: value for LCDOFFSx                            00000000                0b 00000000 00000000 00000000 00000000
WORD [5]: value for LCDPWx                              00000000                0b 00000000 00000000 00000000 00000000
WORD [6]: value for LCDCNUMx or for LCDCPOSx            00000004                0b 00000000 00000000 00000000 00000100
WORD [7]: contains the value for LCDDESSIZEx            00000000                0b 00000000 00000000 00000000 00000000
------------ descriptor0_1 ---------80020500-------
WORD [0]: next descriptor physical address              001d8280                0b 00000000 00011101 10000010 10000000
WORD [1]: the buffer physical address                   00020700                0b 00000000 00000010 00000111 00000000
WORD [2]: the buffer ID value                           00000000                0b 00000000 00000000 00000000 00000000
WORD [3]: value for LCDCMDx.                            0400e100                0b 00000100 00000000 11100001 00000000
WORD [4]: value for LCDOFFSx                            00000000                0b 00000000 00000000 00000000 00000000
WORD [5]: value for LCDPWx                              00000000                0b 00000000 00000000 00000000 00000000
WORD [6]: value for LCDCNUMx or for LCDCPOSx            2a000000                0b 00101010 00000000 00000000 00000000
WORD [7]: contains the value for LCDDESSIZEx            ff0ef0ef                0b 11111111 00001110 11110000 11101111
des_using80020600
des_reday80020500
des_cmd0801D8280
des_cmd180020400
-----------------------------------------------------------------------------------------------------------------------
cmdline: console=ttyS1,57600n8 mem=255M@0x0 mem=256M@0x30000000 ip=off root=/dev/ram0 rw rdinit=/init rd_start=0x81A00000 rd_size=0x000
BCC44
console=ttyS1,115200n8 mem=255M@0x0 mem=256M@0x30000000 rootdelay=2 init=/linuxrc root=/dev/mmcblk0
p7 rw
