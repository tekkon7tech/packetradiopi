apt -y install git
apt -y install gcc
apt -y install g++
apt -y install make
apt -y install cmake
apt -y install libasound2-dev
apt -y install libudev-dev
apt -y install libavahi-client-dev
apt -y install alsa-utils

cd ~
git clone https://www.github.com/wb2osz/direwolf
cd direwolf
git checkout dev
mkdir build && cd build
cmake ..
make -j4
sudo make install
make install-conf
cd ~

read -p ' Enter Username: ' username

groupadd packetradio
usermod -a -G dialout $username
usermod -aG pulse-access $username
usermod -aG audio $username
usermod -aG plugdev $username
usermod -aG packetradio $username
useradd prad
usermod -aG dialout prad
usermod -aG pulse-access prad
usermod -aG audio prad
usermod -aG plugdev prad
usermod -aG packetradio prad

mkdir /opt/direwolf
mkdir /opt/linbpq
mkdir /opt/hamtrek
setfacl -d -m g:packetradio:rwx /opt/direwolf
setfacl -d -m g:packetradio:rwx /opt/linbpq
setfacl -d -m g:packetradio:rwx /opt/hamtrek

cd ~
git clone https://github.com/g8bpq/linbpq
git clone https://github.com/tekkon7tech/hamtrek
apt -y install libconfig-dev
apt -y install libpcap-dev
apt -y install libminiupnpc-dev
cd ~/linbpq
make
cp ~/linbpq/linbpq /opt/linbpq
cd ~/hamtrek
make
cp ~/hamtrek/hamtrek /opt/hamtrek
