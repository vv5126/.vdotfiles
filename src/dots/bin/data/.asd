
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

set ipaddr 192.168.10.203
set bootargs mem=256M@0x0 mem=256M@0x30000000 console=ttyS3,115200 ip=192.168.10.203:192.168.4.13:192.168.10.1:255.255.255.0 nfsroot=192.168.4.13:/home/nfsroot/fpga/rootfs/root_ok rw 
tftp 0x80600000 192.168.4.13:fpga/user/wgao/uImage; bootm 0x80600000

set bootargs mem=128M@0x0 mem=128M@0x30000000 console=ttyS3,115200 ip=192.168.10.203:192.168.4.13:192.168.10.1:255.255.255.0 nfsroot=192.168.4.13:/home/nfsroot/fpga/rootfs/root_ok rw 

-------------------------------------------------------------------------------
FPGA T10:
set bootargs 'console=ttyS2,115200n8 mem=32M@0x0 loglevel=7 ip=192.168.4.254:192.168.4.1:192.168.4.1:255.255.255.0 rootdelay=2 nfsroot=192.168.4.13:user/bliu/root_ok rw'
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

cmdline: console=ttyS1,57600n8 mem=255M@0x0 mem=256M@0x30000000 ip=off root=/dev/ram0 rw rdinit=/init rd_start=0x81A00000 rd_size=0x000BCC44
console=ttyS1,115200n8 mem=255M@0x0 mem=256M@0x30000000 rootdelay=2 init=/linuxrc root=/dev/mmcblk0p7 rw
