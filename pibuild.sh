#!/bin/bash
function pause()
{
  read -p "Press key to continue.. " -n1 -s
  echo -e "\n"
}

function basepackages()
{
  apt -y install git
  apt -y install gcc
  apt -y install g++
  apt -y install make
  apt -y install cmake
  apt -y install libasound2-dev
  apt -y install libudev-dev
  apt -y install libavahi-client-dev
  apt -y install alsa-utils
  apt -y install acl
  apt -y install zlib1g-dev
  apt -y install tmux

  pause
}

function installdw()
{
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
  pause
}

function configaccess()
{
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

  pause
}

function configbbs()
{
  cd ~
  git clone https://github.com/tekkon7tech/packetradiopi

  mkdir /opt/direwolf
  chmod -R g+rwx /opt/direwolf
  setfacl -d -m g:packetradio:rwx /opt/direwolf
  setfacl -m g:packetradio:rwx /opt/direwolf
  mkdir /opt/direwolf/log
  mkdir /opt/linbpq
  chmod -R g+rwx /opt/linbpq
  setfacl -d -m g:packetradio:rwx /opt/linbpq
  setfacl -m g:packetradio:rwx /opt/linbpq
  mkdir /opt/linbpq/log
  mkdir /opt/hamtrek
  chmod -R g+rwx /opt/hamtrek
  setfacl -d -m g:packetradio:rwx /opt/hamtrek
  setfacl -m g:packetradio:rwx /opt/hamtrek

  cd ~
  git clone https://github.com/g8bpq/linbpq
  git clone https://github.com/tekkon7tech/hamtrek
  apt -y install libconfig-dev
  apt -y install libpcap-dev
  apt -y install libminiupnpc-dev
  cd ~/linbpq
  make
  cp ~/linbpq/linbpq /opt/linbpq
  cd ~/hamtrek/src
  make
  cp ~/hamtrek/src/hamtrek /opt/hamtrek

  cp ~/packetradiopi/direwolf.service /etc/systemd/system/
  cp ~/packetradiopi/direwolf.conf /opt/direwolf
  cp ~/packetradiopi/linbpq.service /etc/systemd/system/
  cp ~/packetradiopi/bpq32.cfg /opt/linbpq
  cp ~/packetradiopi/hamtrek@.service /etc/systemd/system/
  cp ~/packetradiopi/hamtrek.socket /etc/systemd/system/

  cp ~/packetradiopi/direwolf.conf /opt/direwolf
  cp ~/packetradiopi/bpq32.cfg /opt/linbpq

  systemctl daemon-reload
  systemctl enable hamtrek.socket
  systemctl enable direwolf.service
  systemctl enable linbpq.service
#  systemctl start hamtrek.socket
#  systemctl start direwolf.service
#  systemctl start linbpq.service
}

function menu()
{
  echo "Linux / PI Packet Radio Build"
  echo " [A] - Build all"
  echo " [P] - Install base packages"
  echo " [D] - Build/Install Direwolf"
  echo " [G] - Configure Group Access"
  echo " [B] - Install BBS"
  echo " [Q] - Quit"
  read -p "Choose an option:  " -n1 -s menuin

  case $menuin in
    A|a)
      basepackages
      installdw
      configaccess
      configbbs
      ;;
    P|p)
      basepackages
      ;;
    D|d)
      installdw
      ;;
    G|g)
      echo "Config Access"
      configaccess
      ;;
    B|b)
      configbbs
      ;;
  esac
}
menu
