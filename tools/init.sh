#!/bin/bash
#
# Run as eg ./init.sg A1101
#
cd dev
sudo chown -R arkbg.pi *

# Create dev_id config file using command line param.
if [ -e dev_id.json ]; then
  echo "Delete existing dev_id.json file!"
  rm dev_id.json
fi
echo "{" >> dev_id.json
#echo "DEVICE_ID:$1" >> dev_id.json
echo "\"DEVICE_ID\":\"$1\"" >> dev_id.json
echo "}" >> dev_id.json
#
wget https://raw.githubusercontent.com/blugraph/blusense/master/tools/refactor.sh
chmod a+x refactor.sh
./refactor.sh
cd devsrc/blusense/tools
chmod a+x *
cd
cd dev
# Replace crontab and network config files with new ones.
wget https://raw.githubusercontent.com/blugraph/blusense/master/tools/crontab
#wget {url}/networking.conf
#sudo chmod 644 /etc/networking.conf
sudo chmod 644 crontab
sudo mv crontab /etc/crontab
sudo chown root.root /etc/crontab

wget https://raw.githubusercontent.com/blugraph/blusense/master/tools/interfaces
sudo chmod 644 interfaces
sudo mv interfaces /etc/interfaces

#sudo mv networking.conf /etc/networking.conf
#sudo chmod {444} /etc/networking.conf
#sudo chmod {444} /etc/crontab
#
