cd $1
make clean && make -j32 && scp fImage fpga@192.168.4.13:"/home/fpga/user/wgao/fpga/t10_lcd/f-Image"
