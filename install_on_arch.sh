#!/bin/bash

echo -e "\n [ Update System ] \n"
sudo pacman -Syyu --noconfirm


echo -e "\e[32m do you want to install bluetooth [y/n] \e[0m"
read bluez

echo -e "\e[32m do you want to install yay [y/n] \e[0m"
read yay

echo -e "\e[32m do you want to install flatpak [y/n] \e[0m"
read flatpak

echo -e "\e[32m are you using an amd or intel processor [amd/intel] \e[0m"
read amd
if [ "$amd" == "amd" ]; then
    sudo pacman -S amd-ucode --noconfirm
elif [ "$amd" == "intel" ]; then
    sudo pacman -S intel-ucode --noconfirm
else
    echo -e "\033[31m No valid input \033[0m"
    exit 1
fi


echo -e  "\n [ Install necessery packages ] \n"
sudo pacman -S dracut ly bluez zsh --noconfirm

echo -e "\n [ Install recommended cli-applications ] \n"
sudo pacman -S base-devel git neovim vi yazi bc unzip zip 7zip unrar btop ffmpeg imagemagick ripgrep fastfetch --noconfirm

echo -e  "\n [ Install wayland and grafic-drivers packages ] \n"
sudo pacman -S mesa wayland xorg-xwayland qt6-wayland qt5-wayland --noconfirm

echo -e  "\n [ Install GUI packages ] \n"
sudo pacman -S qt5 qt6 gtk3 gtk4 --noconfirm

echo -e  "\n [ Install Audio packages ] \n"
sudo pacman -S pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack pipewire-audio --noconfirm

echo -e  "\n [ Install Hyprland packages ] \n"
sudo pacman -S uwsm hyprland xdg-desktop-portal-hyprland hyprpolkitagent hyprutils hyprpaper hyprlock hyprland-qt-support hyprland-qtutils --noconfirm

echo -e  "\n [ Install grafic packages ] \n"
sudo pacman -S mesa wayland xorg-xwayland --noconfirm

if [ "$bluez" == "y" ]; then
    echo -e  "\n [ Install Bluetooth packages ] \n"
    sudo pacman -S bluez blueberry --noconfirm
    sudo systemctl enable bluetooth
fi

echo -e  "\n [ Install Desktop packages ] \n"
sudo pacman -S waybar rofi-wayland rofi-emoji udiskie brightnessctl swaync --noconfirm

echo -e  "\n [ Install recommended Desktop applications ] \n"
sudo pacman -S kitty qt6ct nwg-look pavucontrol thunar mpv amberol vivaldi vivaldi-ffmpeg-codecs --noconfirm

echo -e  "\n [ Install Thunar plugins ] \n"
sudo pacman -S file-roller thunar-archive-plugin thunar-media-tags-plugin gvfs ffmpegthumbnailer tumbler --noconfirm

echo -e  "\n [ Install common Fonts ] \n"
sudo pacman -S otf-font-awesome nerd-fonts --noconfirm 

echo -e  "\n [ Install Shenaniganz :3 ] \n"
sudo pacman -S sl uwufetch viu cowsay asciiquarium --noconfirm

if [ "$flatpak" == "y" ]; then
    echo -e  "\n [ Install Flatpak ] \n"
    sudo pacman -S xdg-desktop-portal-gtk flatpak --noconfirm
fi


if [ "$yay" == "y" ]; then
    echo -e  "\n [ Install yay ] \n"
    sudo pacman -S go --noconfirm

    git clone https://aur.archlinux.org/yay.git 
    cd yay/
    makepkg -si
    cd ..
    rm -fr yay

fi

echo -e  "\n [ Enable Display-Manager (ly-dm) ] \n"
sudo systemctl enable ly

echo -e  "\n [ enable polkit, hyprpaper and waybar ] \n"
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now waybar.service
systemctl --user enable --now hyprpaper.service

echo -e  "\n [ install dotfiles ] \n"
mkdir ~/.dotfiles
cp flavours/ ~/.dofiles -r 

echo -e  "\n [ apply Catppuccin-Flavour as Default ] \n"
cp -rf config/* ~/.config

echo -e  "\n [ install icons and cursor ] \n"
if [ ! -d ~/.icons ]; then
    mkdir ~/.icons
fi
sudo cp cursor/Bibata-Modern-Classic /usr/share/icons -r
sudo cp cursor/index.theme /usr/share/icons/default/index.theme

cp icons/ ~/.icons -r

echo -e  "\n [ install gtk themes ] \n"
if [ ! -d ~/.themes ]; then
    mkdir ~/.themes
fi
cp themes/* ~/.themes

echo -e  "\n [ install Oh-My-Zsh ] \n"
sudo chsh -s /bin/zsh $USER

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<EOF
N
EOF
cp zshrc ~/.zshrc

echo -e \n Installation Complete \n now you should reboot!\n and dont forget to switch to Hyprland (uwsm managed) in ly-dm \n
echo -e \n reboot now? [y/n] \n
read reb

if [ $reb == "y" ]; then
    reboot
fi
