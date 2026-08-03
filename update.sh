#!/bin/bash

echo "Stopping Klipper Service"
sudo service klipper stop

echo "Making Backup of Current Klipper"
cd ~
rm -rf ~/klipper_backup
cp -r ~/klipper ~/klipper_backup

echo "Checking for Klipper Updates"
cd ~/klipper
git pull origin

echo "Copying Klipper Files to BTT Octopus"
cp -r ~/klipper/* ~/update_configs/klipper_octopus/
echo "Copying Klipper Files to BTT SB2209"
cp -r ~/klipper/* ~/update_configs/klipper_sb2209/
echo "Copying Klipper Files to BTT MMB 1.0"
cp -r ~/klipper/* ~/update_configs/klipper_mmbv10/
echo "Copying Klipper Files to BTT MMB 1.1"
cp -r ~/klipper/* ~/update_configs/klipper_mmbv11/

echo "Making BTT Octopus klipper.bin"
cd ~/update_configs/klipper_octopus/
make clean
make
echo "Making BTT SB2209 klipper.bin"
cd ~/update_configs/klipper_sb2209/
make clean
make
echo "Making BTT MMB v1.0 klipper.bin"
cd ~/update_configs/klipper_mmbv10/
make clean
make
echo "Making BTT MMB v1.1 klipper.bin"
cd ~/update_configs/klipper_mmbv11/
make clean
make

echo "Querying CAN Devices"
cd ~/katapult/scripts/
python3 flash_can.py -i can0 -q
echo "Updating MMU on BTT Octopus"
python3 flash_can.py -i can0 -f ~/update_configs/klipper_octopus/out/klipper.bin -u 3ef2c3113c4b
echo "Updating MMU on BTT SB2209"
python3 flash_can.py -i can0 -f ~/update_configs/klipper_sb2209/out/klipper.bin -u bd9b2215b06b
echo "Updating MMU on BTT MMB 1.0"
python3 flash_can.py -i can0 -f ~/update_configs/klipper_mmbv10/out/klipper.bin -u a99262006fa1
echo "Updating MMU on BTT MMB 1.1"
python3 flash_can.py -i can0 -f ~/update_configs/klipper_mmbv11/out/klipper.bin -u 640de98b9de1

echo "Starting Happy Hare Config"
cd ~/Happy-Hare/
./install.sh
cd ~
echo "Restarting System"
sudo reboot
