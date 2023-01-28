# set up gnome
gsettings set org.gnome.desktop.peripherals.keyboard delay 200
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20

# remove screen tearing
touch /etc/X11/xorg.conf.d/20-intel.conf
echo '
Section "Device"
 
    Identifier "Intel Graphics"
 
    Driver "intel"
 
    Option "TearFree" "true"
 
EndSection
' >> /etc/X11/xorg.conf.d/20-intel.conf

# speed up dnf
echo "
fastermirror=True
max_parallel_downloads=10
" >> /etc/dnf/dnf.conf

# update installed
sudo dnf update

# install zsh
dnf install util-linux # contains the chsh
dnf install zsh
chsh -s $(which zsh)

# setup font
curl -OJL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip
unzip Hack.zip -d Hack/
rm Hack.zip
mv Hack/ /usr/share/fonts/Hack/

# install packages
dnf install xclip
dnf install xset # to set up a repeat rate xset r rate 220 20
dnf install brightnessctl # change brightness brightnessctl set 5%- | brightnessctl set +5%
dnf install ripgrep
dnf install fd-find
dnf install alacritty
dnf install g++
dnf install luarocks
dnf install git-delta
dnf install stow
dnf install btop
