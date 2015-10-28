#!/bin/bash
ZIMAGE=arch/mips/boot/zcompressed/zImage

[ -f $ZIMAGE ] && rm $ZIMAGE
make zImage -j32

if [ -f $ZIMAGE ]; then
   cd build_bootimage
   bash m.sh
fi

