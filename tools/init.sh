#!/bin/bash
#
#
cd dev
sudo chown -R arkbg.pi *
wget https://raw.githubusercontent.com/blugraph/blusense/master/tools/refactor.sh
chmod a+x refactor.sh
./refactor.sh
cd devsrc/blusense/tools
chmod a+x *
cd
