sudo dnf update

# Enable RPM Fusion
sudo rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable Fastest Mirror, Maximum Parallel Downloads and Delta RPM
echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=5" | sudo tee -a /etc/dnf/dnf.conf
echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf

# Reduce Battery Usage
sudo dnf install tlp tlp-rdw
sudo systemctl enable tlp

# Lenovo Thinkpad specific packages for TLP which gives you more info and control on your battery.
# sudo dnf install https://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm
# sudo dnf install kernel-devel akmod-acpi_call akmod-tp_smapi
# After installation, run the command below to view the Battery informations and status.
sudo tlp-stat -b

echo "Updating default fedora groups"
sudo dnf group upgrade --with-optional Multimedia

sudo dnf groupinstall "Development Tools" "Development Libraries"

echo "Updating flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

echo "Install zsh & shell custom";
sudo dnf install zsh \ 
	vim \
	util-linux-user \
	tmux;

echo "Installing KVM"
sudo dnf install qemu-kvm bridge-utils libvirt virt-install -y

echo "Installing devtools, java, python, ruby"
sudo dnf install java-openjdk 
sudo dnf install docker docker-compose podman containerd 
sudo dnf install distrobox toolbox

sudo systemctl start docker 
sudo groupadd dockerwheel
sudo usermod -aG docker $USER






# ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh plugins 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed 's/robbyrussell/powerlevel10k\/powerlevel10k/g' -i ~/.zshrc


echo "Installing hyprland and misc";
sudo dnf install hyprland \
	mako \ 
	qt5-qtwayland \ 
	pipewire \ 
	polkit-kde \ 
	hyprlock \ 
	hypridle \ 


echo "Setuping xdg packages";
sudo dnf install xdg-desktop-portal \
	xdg-desktop-portal-gtk \
	xdg-desktop-portalp-hyprland;

gsettings set org.gnome.desktop.interface color-scheme prefer dark


echo "Installing extra tools"
sudo dnf install rclone \
       openssl \ 
       baloosearch

sudo dnf install pandoc ShellCheck ocrmypdf pdftk wkhtmltopdf aspell ncdu zeal peek Thunar screenkey flameshot syncthing -y


python3 -m pip install --user youtube-dl        
# OCR images
python3 -m pip install --user Tesseract 

# Shell gpt


