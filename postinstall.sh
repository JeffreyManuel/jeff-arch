#! /bin/sh
set -e
# Installing Basic Packages
sudo pacman -Syu --needed --noconfirm archlinux-keyring pacman-contrib terminus-font base-devel rsync reflector
sudo setfont ter-v22b
iso=$(curl -4 ifconfig.co/country-iso)

# Enable parellel Downloads
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
# Setting Mirrors for fast downloads 
sudo reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

# Installing yay aur helper
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
cd ..

# Creating a few directories
sudo mkdir /home/$USERNAME/Pictures
sudo mkdir /home/$USERNAME/.config
sudo mkdir /home/$USERNAME/.fonts

# Installing the dependencies and the window manager bspwm
yay -S nerd-fonts-complete-starship noto-fonts-emoji netctl variety feh ttf-font-awesome jq polybar redshift sddm nano vim sxhkd neofetch psmisc lxappearance papirus-icon-theme noto-fonts-emoji bspwm kitty polybar picom thunar nitrogen xorg unzip yad wget pulseaudio pavucontrol qt5-quickcontrols qt5-quickcontrols2 qt5-svg rofi lxpolkit-git ttf-font-awesome brave-bin --noconfirm

# Theming
cd ~/jeff-arch || exit
sudo cp -r bg.jpg /home/$USER/Pictures/bg.jpg
sudo cp -r dotfonts/* /home/$USER/.fonts/
sudo cp -r dotconfig/* /home/$USER/.config/

git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors 
sudo bash install.sh
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
sudo mv dotfonts/fontawesome/*.otf /home/$USER/.fonts/
sudo unzip FiraCode.zip -d /home/$USER/.fonts/
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
sudo unzip Meslo.zip -d /home/$USER/.fonts/
sudo chown $USER:$USER /home/$USER/.fonts/*
cd /usr/share/themes/ 
sudo git clone https://github.com/EliverLara/Nordic.git
sudo systemctl enable sddm
sudo fc-cache -vf