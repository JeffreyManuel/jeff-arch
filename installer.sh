#! /bin/sh
sudo pacman -Syu base-devel
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
mkdir ~/Pictures
mkdir ~/.config
mkdir ~/.fonts
cp -r ./bg.jpg ~/Pictures/bg.jpg
cd /home/$username/jeff-arch
fc-cache -vf
yay -S noto-fonts-emoji ttf-font-awesome jq polybar redshift sddm nano vim rofi sxhkd neofetch flameshot psmisc vim lxappearance papirus-icon-theme lxappearance noto-fonts-emoji sddm feh bspwm sxhkd kitty rofi polybar picom thunar nitrogen  xorg unzip yad wget pulseaudio pavucontrol qt5-quickcontrols qt5-quickcontrols2 qt5-svg ttf-font-awesome-5 lxpolkit-git ttf-font-awesome firefox
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
sudo reboot
