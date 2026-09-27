#!/bin/bash
# tech-0s-lite | script de post-instalación
# Aplica optimizaciones a un sistema Linux Mint existente para convertirlo en tech-0s-lite
# ATENCIÓN: Haz backup antes de ejecutar. Este script purga paquetes de Mint.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "  tech-0s-lite | Post-instalación"
echo "=========================================="
echo ""
echo "Este script optimizará tu sistema para usar XFCE y consumir menos de 1GB de RAM."
echo "Se purgarán paquetes de Linux Mint y se instalará XFCE."
echo ""
read -p "¿Deseas continuar? (s/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado."
    exit 0
fi

# Verificar que estamos en Linux Mint
if [ ! -f /etc/linuxmint/info ]; then
    echo "ADVERTENCIA: No se detectó Linux Mint. Este script está diseñado para Linux Mint."
    read -p "¿Deseas continuar de todos modos? (s/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Cancelado."
        exit 0
    fi
fi

# Actualizar sistema
echo "[1/8] Actualizando sistema..."
sudo apt update
sudo apt upgrade -y

# Instalar XFCE
echo "[2/8] Instalando XFCE..."
sudo apt install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xfce4-power-manager \
    xfce4-notifyd \
    xfconf \
    xfdesktop4 \
    xfwm4 \
    gtk3-engines-xfce \
    xfce4-pulseaudio-plugin \
    xfce4-screenshooter \
    xfce4-taskmanager \
    xfce4-clipman-plugin \
    xfce4-whiskermenu-plugin \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    tumbler \
    gvfs \
    gvfs-backends \
    gvfs-fuse \
    network-manager \
    network-manager-gnome \
    wpasupplicant \
    rfkill \
    pulseaudio \
    pulseaudio-utils \
    pavucontrol \
    volumeicon-alsa \
    evince \
    mousepad \
    ristretto \
    galculator \
    xarchiver \
    firefox-esr \
    orchis-gtk-theme \
    papirus-icon-theme \
    bibata-cursor-theme \
    zram-tools \
    earlyoom \
    preload \
    htop \
    neofetch \
    gnome-disk-utility \
    gdebi \
    synaptic \
    unattended-upgrades \
    apt-listchanges \
    debsums \
    deborphan \
    bleachbit \
    fonts-inter \
    fonts-dejavu \
    ffmpeg \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    x264 \
    x265 \
    xfce4-battery-plugin \
    xfce4-cpugraph-plugin \
    xfce4-netload-plugin \
    xfce4-systemload-plugin \
    xfce4-weather-plugin \
    xfce4-datetime-plugin \
    xfce4-mailwatch-plugin \
    xfce4-mount-plugin \
    xfce4-places-plugin \
    xfce4-verve-plugin \
    xfce4-xkb-plugin

# Purgar paquetes de Mint
echo "[3/8] Purgando paquetes de Linux Mint..."
sudo apt purge -y --purge \
    mintupdate \
    mintinstall \
    mintreport \
    mintwelcome \
    mintstick \
    mintlocale \
    mintmenu \
    mint-common \
    mint-artwork \
    mint-backgrounds-wallpapers \
    mint-themes \
    mint-x-icons \
    mint-y-icons \
    mint-cursor-themes \
    mint-l-icons \
    mint-l-theme \
    mint-meta-cinnamon \
    mint-meta-core \
    mint-mirrors \
    mintsources \
    mintsysadm \
    mintsystem \
    mint-translations \
    mint-upgrade-info \
    mintbackup \
    mintchat \
    mint-info-cinnamon \
    cinnamon \
    cinnamon-common \
    cinnamon-control-center \
    cinnamon-daemon \
    cinnamon-desktop-environment \
    cinnamon-desktop-data \
    cinnamon-menus \
    cinnamon-session \
    cinnamon-settings-daemon \
    cinnamon-screensaver \
    nemo \
    nemo-fileroller \
    xed \
    xreader \
    pix \
    warpinator \
    celluloid \
    hypnotix \
    thingy \
    sticky \
    timeshift \
    grub2-theme-mint \
    2>/dev/null || true

sudo apt autoremove -y --purge

# Copiar configuraciones
echo "[4/8] Aplicando configuraciones..."
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/dconf/db/local.d/00-tech-0s-lite" /etc/dconf/db/local.d/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/dconf/profile/user" /etc/dconf/profile/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/lightdm/lightdm.conf.d/tech0s-lite.conf" /etc/lightdm/lightdm.conf.d/ 2>/dev/null || sudo mkdir -p /etc/lightdm/lightdm.conf.d && sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/lightdm/lightdm.conf.d/tech0s-lite.conf" /etc/lightdm/lightdm.conf.d/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/default/grub.d/51-tech0s-lite.cfg" /etc/default/grub.d/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/sysctl.d/99-tech0s-lite.conf" /etc/sysctl.d/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/default/zramswap" /etc/default/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/default/earlyoom" /etc/default/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/systemd/journald.conf.d/tech0s-lite.conf" /etc/systemd/journald.conf.d/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/modprobe.d/tech0s-lite-blacklist.conf" /etc/modprobe.d/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/default/apport" /etc/default/
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/tmpfiles.d/tech0s-lite.conf" /etc/tmpfiles.d/

# Copiar binarios
sudo cp "$SCRIPT_DIR/config/includes.chroot/usr/local/bin/tech-0s-lite" /usr/local/bin/
sudo cp "$SCRIPT_DIR/config/includes.chroot/usr/local/bin/tech-0s-lite-welcome" /usr/local/bin/
sudo chmod +x /usr/local/bin/tech-0s-lite
sudo chmod +x /usr/local/bin/tech-0s-lite-welcome

# Copiar autostart
sudo mkdir -p /etc/xdg/autostart
sudo cp "$SCRIPT_DIR/config/includes.chroot/etc/xdg/autostart/tech-0s-lite-welcome.desktop" /etc/xdg/autostart/

# Copiar sesión XFCE
sudo mkdir -p /usr/share/xsessions
sudo cp "$SCRIPT_DIR/config/includes.chroot/usr/share/xsessions/xfce-tech-0s-lite.desktop" /usr/share/xsessions/

# Copiar wallpapers
sudo mkdir -p /usr/share/backgrounds/tech-os
sudo cp -r /home/jose/tech-0s/config/includes.chroot/usr/share/backgrounds/tech-os/* /usr/share/backgrounds/tech-os/ 2>/dev/null || true

# Actualizar dconf
echo "[5/8] Actualizando dconf..."
dconf update 2>/dev/null || true

# Actualizar GRUB
echo "[6/8] Actualizando GRUB..."
sudo update-grub 2>/dev/null || true

# Habilitar servicios
echo "[7/8] Habilitando servicios de optimización..."
sudo systemctl enable zramswap 2>/dev/null || true
sudo systemctl enable earlyoom 2>/dev/null || true
sudo systemctl enable preload 2>/dev/null || true

# Desactivar servicios innecesarios
echo "[8/8] Desactivando servicios innecesarios..."
for svc in bluetooth cups avahi-daemon ModemManager apport whoopsie speech-dispatcher; do
    sudo systemctl disable "$svc" 2>/dev/null || true
    sudo systemctl mask "$svc" 2>/dev/null || true
done

# Limpiar
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*

echo ""
echo "=========================================="
echo "  tech-0s-lite | Instalación completada"
echo "=========================================="
echo ""
echo "Optimizaciones aplicadas:"
echo "  • Escritorio XFCE instalado"
echo "  • zram: compresión de memoria (50% RAM)"
echo "  • earlyoom: protección contra OOM"
echo "  • preload: precarga de aplicaciones"
echo "  • Servicios innecesarios desactivados"
echo "  • Kernel optimizado para poca RAM"
echo "  • journald ligero (128MB max)"
echo ""
echo "RAM estimada en reposo: ~300-400MB"
echo ""
echo "Comandos útiles:"
echo "  tech-0s-lite --help      - Mostrar ayuda"
echo "  tech-0s-lite --status    - Ver estado de optimizaciones"
echo "  tech-0s-lite --optimize  - Ejecutar optimización manual"
echo "  tech-0s-lite --clean     - Limpiar archivos temporales"
echo ""
echo "Reinicia el equipo para aplicar todos los cambios."
echo ""
