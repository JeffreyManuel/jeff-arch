#! /bin/sh

set -e

# Installing Basic Packages
sudo pacman -Syu --needed --noconfirm archlinux-keyring pacman-contrib terminus-font base-devel rsync reflector
setfont ter-v22b
iso=$(curl -4 ifconfig.co/country-iso)
sudo timedatectl set-ntp true

# Enable parallel Downloads
sed -i "s/^#ParallelDownloads/ParallelDownloads/" /etc/pacman.conf

# Setting Mirrors for fast downloads 
reflector -a 48 -c "$iso" -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

# Installing yay aur helper
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

# Creating a few directories
mkdir "$HOME"/Pictures
mkdir "$HOME"/.config
mkdir "$HOME"/.fonts

# Installing the dependencies and the window manager bspwm
yay -S nerd-fonts-complete-starship noto-fonts-emoji netctl brave variety feh ttf-font-awesome jq polybar redshift sddm nano vim sxhkd neofetch psmisc lxappearance papirus-icon-theme noto-fonts-emoji bspwm kitty polybar picom thunar nitrogen xorg unzip yad wget pulseaudio pavucontrol qt5-quickcontrols qt5-quickcontrols2 qt5-svg rofi lxpolkit-git ttf-font-awesome brave-git --noconfirm

# Theming
cd ~/jeff-arch
cp bg.jpg "$HOME"/Pictures/bg.jpg
cp -r dotfonts/* "$HOME"/.fonts/
cp -r dotconfig/* "$HOME"/.config/

git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
bash install.sh
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
mv dotfonts/fontawesome/*.otf "$HOME"/.fonts/
unzip FiraCode.zip -d "$HOME"/.fonts/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d "$HOME"/.fonts/
chown "$USER":"$USER" "$HOME"/.fonts/*
cd /usr/share/themes/ && sudo git clone https://github.com/EliverLara/Nordic.git
sudo systemctl enable sddm
fc-cache -vf
#Reboot
sleep 10
reboot