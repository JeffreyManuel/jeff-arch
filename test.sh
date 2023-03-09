#!/bin/bash

# List available drives
lsblk

# Prompt user for input
echo "Enter the drive to install Arch Linux on (e.g. /dev/sda):"
read DRIVE
echo "Enter the hostname for this system:"
read HOSTNAME
echo "Enter the username for the new user:"
read USERNAME
echo "Enter the password for the new user:"
read -s USERPASS
echo "Enter the root password:"
read -s ROOTPASS

# Verify UEFI boot mode
if [[ ! -d /sys/firmware/efi/efivars ]]; then
    echo "Error: UEFI boot mode not detected. Please boot in UEFI mode and run this script again."
    exit 1
fi

# Update system clock
timedatectl set-ntp true

# Create partitions
parted $DRIVE mklabel gpt
parted $DRIVE mkpart primary fat32 1MiB 261MiB
parted $DRIVE set 1 esp on
parted $DRIVE mkpart primary ext4 261MiB 100%

# Format partitions
mkfs.fat -F32 ${DRIVE}1
mkfs.ext4 ${DRIVE}2

# Mount partitions
mount ${DRIVE}2 /mnt
mkdir -p /mnt/boot/efi
mount ${DRIVE}1 /mnt/boot/efi

# Install essential packages
pacstrap /mnt base linux linux-firmware networkmanager git neofetch nano vim 

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Change root into new system
arch-chroot /mnt /bin/bash <<EOF
# Set timezone to UTC
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

#Enable network manger
systemctl enable NetworkManager

# Uncomment en_US.UTF-8 locale
sed -i '/^#en_US.UTF-8/s/^#//g' /etc/locale.gen
locale-gen

# Set hostname
echo "$HOSTNAME" > /etc/hostname

# Generate hosts file
cat >> /etc/hosts << END
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
END

# Set root password
echo "root:$ROOTPASS" | chpasswd

# Create user and set password
useradd -m -G wheel -s /bin/bash $USERNAME
echo "$USERNAME:$USERPASS" | chpasswd

# Uncomment %wheel ALL=(ALL) ALL in sudoers file
sed -i '/^# %wheel ALL=(ALL) ALL/s/^# //' /etc/sudoers

#Installing the gui 

# Installing Basic Packages
sudo pacman -Syu --needed --noconfirm archlinux-keyring pacman-contrib terminus-font base-devel rsync reflector
sudo setfont ter-v22b
iso=$(curl -4 ifconfig.co/country-iso)
sudo timedatectl set-ntp true
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
sudo mkdir /home/$USER/Pictures
sudo mkdir /home/$USER/.config
sudo mkdir /home/$USER/.fonts

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

# Install bootloader (systemd-boot)
bootctl install

# Generate bootloader configuration
echo "default arch" > /boot/loader/loader.conf
echo "timeout 4" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options root=${DRIVE}2 rw" >> /boot/loader/entries/arch.conf

EOF

# Exit the chroot environment and reboot
umount -R /mnt
reboot
