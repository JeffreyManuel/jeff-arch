#! /bin/sh
#Installing Basic Packages
sudo pacman -Syu --needed base-devel rsync reflector
#Enable parellel Downloads
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
#Setting Mirrors for fast downloads 
"
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
echo -ne "


#Installing yay aur helper

git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

#Creating a few directories
mkdir ~/Pictures
mkdir ~/.config
mkdir ~/.fonts

#Installing the dependencies and the window manager bspwm

yay -S noto-fonts-emoji variety feh ttf-font-awesome jq polybar redshift sddm nano vim sxhkd neofetch psmisc lxappearance papirus-icon-theme noto-fonts-emoji bspwm kitty  polybar picom thunar nitrogen  xorg unzip yad wget pulseaudio pavucontrol qt5-quickcontrols qt5-quickcontrols2 qt5-svg rofi font-awesome-5 lxpolkit-git ttf-font-awesome brave-bin 

#Themeing
cd ~/jeff-arch
cp -r bg.jpg ~/Pictures/bg.jpg
cp -r dotfonts/* ~/.fonts 
cp -r dotconfig/* ~/.config

git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
bash install.sh
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
sudo unzip FiraCode.zip -d /home/$username/.fonts/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
sudo unzip Meslo.zip -d /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*
cd /usr/share/themes/ || exit
sudo git clone https://github.com/EliverLara/Nordic.git
sudo systemctl enable sddm
fc-cache -vf
sudo reboot
