#!/bin/bash

script=run_once

echo '#!/bin/bash' > $script
echo "scp -r $@ icsw@192.168.10.222:~" >> $script
echo "rm aa.sh" >> $script
chmod +x $script

scp -r $@ $script fpga@192.168.4.13:~
ssh fpga@192.168.4.13 "$script"
