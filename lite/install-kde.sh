#!/bin/bash
# tech-0s | KDE Plasma 6 - Modernización completa
# Convierte tech-0s Cinnamon en tech-0s KDE Plasma 6 optimizado
# Diseñado para 3.7GB RAM + Intel HD Graphics 500

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "  tech-0s | KDE Plasma 6 Moderno"
echo "=========================================="
echo ""
echo "Este script actualizará tu sistema a KDE Plasma 6 con:"
echo "  • Wayland por defecto (moderno, fluido)"
echo "  • Tema Breeze oscuro + iconos modernos"
echo "  • Optimizado para Intel HD Graphics 500"
echo "  • zram + earlyoom + preload"
echo "  • ~400-500MB RAM en reposo"
echo ""
read -p "¿Deseas continuar? (s/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado."
    exit 0
fi

# Verificar RAM disponible
RAM_GB=$(free -g | awk '/^Mem:/ {print $2}')
echo "RAM detectada: ${RAM_GB}GB"
if [ "$RAM_GB" -lt 2 ]; then
    echo "ADVERTENCIA: Tienes menos de 2GB RAM. KDE Plasma puede ir lento."
    read -p "¿Continuar? (s/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 0
    fi
fi

# --- Fase 1: Instalar KDE Plasma 6 ---
echo ""
echo "[1/7] Instalando KDE Plasma 6..."
echo "  Esto puede tardar 10-20 minutos..."

sudo apt update

# Paquetes principales de KDE Plasma 6
sudo apt install -y \
    kde-plasma-desktop \
    kde-standard \
    plasma-desktop \
    plasma-workspace \
    plasma-nm \
    plasma-pa \
    kwin-x11 \
    kwin-wayland \
    kwin-wayland-backend-drm \
    kde-config-gtk-style \
    kde-config-gtk-style-preview \
    kde-config-screenlocker \
    kde-config-sddm \
    khotkeys \
    kgamma \
    kscreen \
    kscreenlocker \
    ksystemstats \
    kaskpass \
    ksshaskpass \
    kde-spectacle \
    kdeconnect \
    kde-cli-tools \
    kde-config-mailer \
    kde-config-pim \
    kde-config-touchpad \
    kde-config-tablet

# Aplicaciones KDE modernas
sudo apt install -y \
    dolphin \
    konsole \
    kate \
    kwrite \
    okular \
    gwenview \
    kcalc \
    kcharselect \
    kfind \
    krdc \
    krfb \
    ksystemlog \
    ktimetracker \
    kaddressbook \
    kalarm \
    korganizer \
    ktnef \
    kdf \
    filelight \
    kdiskmark \
    partitionmanager \
    krename \
    kompare \
    kdiff3 \
    ark \
    karchive \
    kcoreaddons \
    kio \
    kio-extras \
    kio-admin

# SDDM (gestor de login moderno de KDE)
sudo apt install -y \
    sddm \
    sddm-theme-breeze

# Fuentes modernas
sudo apt install -y \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-hack-ttf \
    fonts-firacode \
    fonts-jetbrains-mono \
    fonts-inter

# --- Fase 2: Temas y look moderno ---
echo ""
echo "[2/7] Instalando temas y look moderno..."

# Temas GTK modernos para apps no-KDE
sudo apt install -y \
    orchis-kde \
    papirus-icon-theme \
    papirus-folders \
    bibata-cursor-theme \
    qt5-gtk-platformtheme \
    qt6-gtk-platformtheme \
    kde-style-breeze \
    kde-oxygen \
    kvantum \
    kvantum-theme-orchis \
    kvantum-theme-layan \
    layan-cursor-theme

# Plugins de Plasma modernos
sudo apt install -y \
    plasma-browser-integration \
    plasma-disks \
    plasma-firewall \
    plasma-systemmonitor \
    plasma-thunderbolt \
    plasma-vault \
    plasma-workspace-wallpapers \
    plasma-runners-nepomuk \
    kdeplasma-addons \
    plasma-widgets-addons \
    plasma-applets-weather-widget \
    plasma-applets-systemload-widget \
    plasma-applets-netload-widget \
    plasma-applets-colorpicker \
    plasma-applets-modernclock \
    plasma-applets-partitionmanager \
    plasma-applets-thermalmonitor \
    plasma-applets-simplemenu \
    plasma-applets-virtual-desktop-bar

# --- Fase 3: Optimización de RAM ---
echo ""
echo "[3/7] Aplicando optimizaciones de RAM..."

# zram
sudo apt install -y zram-tools earlyoom preload

# Configurar zram (50% de RAM)
sudo tee /etc/default/zramswap > /dev/null <<'EOF'
ALGO=zstd
PERCENT=50
PRIORITY=100
EOF

# Configurar earlyoom
sudo tee /etc/default/earlyoom > /dev/null <<'EOF'
EARLYOOM_ARGS="-r 60 -m 4 -s 100 --prefer '^(Web Content|firefox|electron|chrome|plasma|krunner|kwin)' --avoid '^(plasma-desktop|Xorg|wayland|sddm|systemd)$'"
EOF

# sysctl para poca RAM
sudo tee /etc/sysctl.d/99-tech0s-kde.conf > /dev/null <<'EOF'
# tech-0s KDE: optimización de memoria
vm.swappiness=10
vm.dirty_ratio=15
vm.dirty_background_ratio=5
vm.vfs_cache_pressure=50
vm.overcommit_memory=1
vm.overcommit_ratio=50
net.ipv4.tcp_slow_start_after_idle=0
net.core.rmem_default=1048576
net.core.wmem_default=1048576
EOF

# journald ligero
sudo mkdir -p /etc/systemd/journald.conf.d
sudo tee /etc/systemd/journald.conf.d/tech0s-kde.conf > /dev/null <<'EOF'
[Journal]
SystemMaxUse=128M
SystemMaxFileSize=16M
Compress=yes
EOF

# apport desactivado
sudo tee /etc/default/apport > /dev/null <<'EOF'
enabled=0
EOF

# tmpfiles
sudo mkdir -p /etc/tmpfiles.d
sudo tee /etc/tmpfiles.d/tech0s-kde.conf > /dev/null <<'EOF'
d /tmp 1777 root root 10d
d /var/tmp 1777 root root 30d
EOF

# --- Fase 4: Desactivar servicios innecesarios ---
echo ""
echo "[4/7] Desactivando servicios innecesarios..."

for svc in bluetooth cups cups-browsed avahi-daemon ModemManager apport whoopsie speech-dispatcher kerneloops; do
    sudo systemctl disable "$svc" 2>/dev/null || true
    sudo systemctl mask "$svc" 2>/dev/null || true
done

# --- Fase 5: Configurar SDDM y Wayland ---
echo ""
echo "[5/7] Configurando SDDM y Wayland..."

# SDDM como gestor de login
sudo systemctl disable lightdm 2>/dev/null || true
sudo systemctl mask lightdm 2>/dev/null || true
sudo systemctl enable sddm

# Configurar SDDM para Wayland
sudo tee /etc/sddm.conf.d/tech0s-wayland.conf > /dev/null <<'EOF'
[General]
DisplayServer=greeter
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
CompositorCommand=kwin_wayland --no-lockscreen --no-kactivities --drm

[Users]
MaximumUid=60000
MinimumUid=1000
HideUsers=root

[Theme]
Current=breeze
CursorTheme=Breeze
CursorSize=24

[General]
InputMethod=qtvirtualkeyboard
EOF

# Forzar sesión Wayland en SDDM
echo "Session=plasmawayland" | sudo tee /var/lib/AccountsService/users/$(whoami) 2>/dev/null || true

# --- Fase 6: Configurar tema KDE moderno ---
echo ""
echo "[6/7] Configurando tema KDE moderno..."

# Crear configs de KDE para todos los usuarios
sudo mkdir -p /etc/xdg

# Configuración de Plasma
sudo tee /etc/xdg/plasma-workspace/env/tech0s-env.sh > /dev/null <<'EOF'
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME=gtk2
export GTK_THEME=Orchis-dark
export XCURSOR_THEME=Breeze
export XCURSOR_SIZE=24
EOF

# KWin - compositor moderno
sudo tee /etc/xdg/kwinrc > /dev/null <<'EOF'
[Compositing]
OpenGLIsUnsafe=false
Backend=OpenGL
GLCore=true
GLTextureFilter=0
HiddenPreviews=5
MaxFPS=60
MinFPS=10
RedirectToFrontBuffer=false
UnredirectFullscreen=true
XRenderSmoothScale=false

[Effect-blur]
NoiseStrength=0
Strength=10

[Effect-desktopgrid]
DesktopLayoutMode=1

[Effect-fade]
Duration=200

[Effect-logout]
UseCustomImageLocation=false

[Effect-mousemark]
Error=2
LineWidth=2
MaxWidth=8
MinWidth=2
Width=3

[Effect-notebook]
CloseOnDesktop=1
MaxRows=2
SnapBackOnStart=0

[Effect-screenshot]
InitialDelay=250
TakePictures=true

[Effect-sheet]
Duration=200

[Effect-slide]
Duration=300

[Effect-squash]
FadeDuration=150
GrowDuration=350
MoveDuration=150

[Effect-translucency]
Menus=85

[Effect-windowview]
BorderActivateAll=1
BorderMoveAll=1
Mode=0
TabBox=true
TabBoxAlternative=false

[Effect-wobblywindows]
AdvanceWobble=2
Drag=85
RigidWobbles=false
Stiffness=10
Wobble=20

[Plugins]
blurEnabled=true
contrastEnabled=true
desktopchangeosdEnabled=true
highlightwindowEnabled=true
magiclampEnabled=true
osdEnabled=true
scripterrorEnabled=true
screenshotEnabled=true
sheetEnabled=true
slideEnabled=true
squashEnabled=true
switchdesktopEnabled=true
windowviewEnabled=true
wobblywindowsEnabled=true

[TabBox]
LayoutName=thumbnails
MultiScreenMode=1
SelectedDesktopMode=2
ShowTabBox=true

[org.kde.kdecoration2]
BorderSize=Large
ButtonsOnLeft=MSA
ButtonsOnRight=HIAX
CloseOnDoubleClickOnMenu=false
library=org.kde.kwin.aurorae
theme=__aurorae__svg__WhiteSur

[Wayland]
InputMethod=/usr/share/applications/org.fcitx.Fcitx.desktop

[Windows]
TitlebarDoubleClickCommand=Maximize
ActiveFont=Noto Sans,11,-1,5,75,0,0,0,0,0,Bold

[org.kde.kwin.rule.AlwaysOnTop]
Description=Always On Top
above=true
aboverule=2

[org.kde.kwin.rule.AlwaysOnBottom]
Description=Always On Bottom
below=true
belowrule=2

[org.kde.kwin.rule.Focus]
Description=Focus
active=true
focus=true
focusrule=2
EOF

# Kvantum theme manager
sudo tee /etc/xgamerc > /dev/null <<'EOF'
[General]
name=Orchis
color_scheme=default
theme_style=Orchis
EOF

# Tema GTK
sudo tee /etc/gtk-3.0/settings.ini > /dev/null <<'EOF'
[Settings]
gtk-theme-name=Orchis-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans 11
gtk-cursor-theme-name=Breeze
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
EOF

# Tema GTK2
sudo tee /etc/gtk-2.0/gtkrc > /dev/null <<'EOF'
gtk-theme-name="Orchis-dark"
gtk-icon-theme-name="Papirus-Dark"
gtk-font-name="Noto Sans 11"
gtk-cursor-theme-name="Breeze"
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintslight"
gtk-xft-rgba="rgb"
EOF

# Cursor del sistema
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/50-cursor.conf > /dev/null <<'EOF'
Section "InputClass"
    Identifier "cursor"
    MatchDriver "libinput"
    Option "AccelProfile" "adaptive"
    Option "AccelSpeed" "0.4"
    Option "NaturalScrolling" "false"
    Option "ScrollMethod" "twofinger"
EndSection
EOF

# Konsole profile moderno
sudo mkdir -p /etc/xdg/konsole
sudo tee /etc/xdg/konsole/tech0s.profile > /dev/null <<'EOF'
[Appearance]
ColorScheme=Breeze
Font=Noto Sans Mono,11,-1,5,50,0,0,0,0,0

[General]
Name=tech-0s
Parent=FALLBACK/

[Scrolling]
HistoryMode=2
EOF

# Dolphin config
sudo tee /etc/xdg/dolphinrc > /dev/null <<'EOF'
[General]
ShowFullPath=true
ShowToolTips=true
UseTabForSwitchingSplitView=true

[Settings]
HiddenFilesShown=true

[splitter]
SplitterState=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\0\xd2\0\0\0\xd2\x1\0\0\0\x1\x1)
EOF

# Plasma discovery
sudo tee /etc/xdg/feedbacksettings > /dev/null <<'EOF'
[General]
FeedbackLevel=32
EOF

# --- Fase 7: Comando tech-0s-kde ---
echo ""
echo "[7/7] Instalando comando tech-0s-kde..."

sudo tee /usr/local/bin/tech-0s-kde > /dev/null <<'CMDEOF'
#!/bin/bash
# tech-0s-kde | comando de información y gestión

case "$1" in
    --help|-h)
        echo "tech-0s-kde - Versión moderna de tech-0s con KDE Plasma 6"
        echo ""
        echo "Uso: tech-0s-kde [opción]"
        echo ""
        echo "Opciones:"
        echo "  --help, -h       Mostrar esta ayuda"
        echo "  --info           Mostrar información del sistema"
        echo "  --optimize       Ejecutar optimización manual"
        echo "  --clean          Limpiar archivos temporales"
        echo "  --status         Mostrar estado de optimizaciones"
        echo "  --session        Cambiar sesión (wayland/x11)"
        echo "  --themes         Abrir configuración de temas"
        echo ""
        ;;
    --info)
        echo "=== tech-0s-kde | KDE Plasma 6 ==="
        echo ""
        if command -v neofetch &>/dev/null; then
            neofetch --stdout
        else
            echo "Sistema: $(uname -s) $(uname -r)"
            echo "Escritorio: KDE Plasma 6"
            echo "Sesión: $(echo $XDG_SESSION_TYPE)"
            echo "RAM: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
            echo "Swap: $(free -h | awk '/^Swap:/ {print $3 "/" $2}')"
        fi
        echo ""
        ;;
    --optimize)
        echo "Ejecutando optimización de tech-0s-kde..."
        sudo sysctl -p /etc/sysctl.d/99-tech0s-kde.conf
        sudo systemctl restart zramswap 2>/dev/null || true
        sudo systemctl restart earlyoom 2>/dev/null || true
        echo "Optimización completada."
        ;;
    --clean)
        echo "Limpiando archivos temporales..."
        if command -v bleachbit &>/dev/null; then
            sudo bleachbit -c --preset 2>/dev/null || {
                sudo rm -rf /tmp/*
                sudo rm -rf /var/tmp/*
                sudo apt-get clean
                sudo apt-get autoremove -y --purge
            }
        else
            sudo rm -rf /tmp/*
            sudo rm -rf /var/tmp/*
            sudo apt-get clean
            sudo apt-get autoremove -y --purge
        fi
        echo "Limpieza completada."
        ;;
    --status)
        echo "=== Estado de optimizaciones tech-0s-kde ==="
        echo ""
        echo "zram: $(systemctl is-active zramswap 2>/dev/null || echo 'inactivo')"
        echo "earlyoom: $(systemctl is-active earlyoom 2>/dev/null || echo 'inactivo')"
        echo "preload: $(systemctl is-active preload 2>/dev/null || echo 'inactivo')"
        echo "sddm: $(systemctl is-active sddm 2>/dev/null || echo 'inactivo')"
        echo "Wayland: $(echo $XDG_SESSION_TYPE)"
        echo ""
        echo "RAM en uso: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        echo "Swap en uso: $(free -h | awk '/^Swap:/ {print $3 "/" $2}')"
        echo ""
        echo "Servicios desactivados:"
        for svc in bluetooth cups avahi-daemon ModemManager apport whoopsie speech-dispatcher; do
            status=$(systemctl is-active "$svc" 2>/dev/null || echo "inactivo")
            echo "  $svc: $status"
        done
        echo ""
        ;;
    --session)
        echo "Sesión actual: $(echo $XDG_SESSION_TYPE)"
        echo ""
        echo "Para cambiar de sesión:"
        echo "  1. Cierra la sesión"
        echo "  2. En SDDM, selecciona 'Plasma (Wayland)' o 'Plasma (X11)'"
        echo "  3. Inicia sesión"
        echo ""
        ;;
    --themes)
        kcmshell5 kcm_desktoptheme kcm_icons kcm_cursors kcm_style kcm_lookandfeel 2>/dev/null &
        echo "Abriendo configuración de temas de KDE..."
        ;;
    *)
        echo "tech-0s-kde: versión moderna de tech-0s con KDE Plasma 6"
        echo "Usa 'tech-0s-kde --help' para más información."
        ;;
esac
CMDEOF

sudo chmod +x /usr/local/bin/tech-0s-kde

# --- Limpiar Cinnamon si sigue instalado ---
echo ""
echo "¿Deseas purgar Cinnamon para liberar espacio? (recomendado)"
read -p "(s/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "Purgando Cinnamon..."
    sudo apt purge -y --purge \
        cinnamon \
        cinnamon-common \
        cinnamon-control-center \
        cinnamon-daemon \
        cinnamon-desktop-data \
        cinnamon-menus \
        cinnamon-screensaver \
        cinnamon-session \
        cinnamon-settings-daemon \
        nemo \
        nemo-fileroller \
        xed \
        xreader \
        pix \
        2>/dev/null || true
    sudo apt autoremove -y --purge
    echo "Cinnamon purgado."
fi

# Limpiar
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*

# Habilitar servicios
sudo systemctl enable zramswap 2>/dev/null || true
sudo systemctl enable earlyoom 2>/dev/null || true
sudo systemctl enable preload 2>/dev/null || true

echo ""
echo "=========================================="
echo "  tech-0s-kde | Instalación completada"
echo "=========================================="
echo ""
echo "Características instaladas:"
echo "  • KDE Plasma 6 (moderno, Wayland por defecto)"
echo "  • SDDM (gestor de login moderno)"
echo "  • Tema Breeze + Orchis-dark + Papirus-Dark"
echo "  • zram: compresión de memoria (50% RAM)"
echo "  • earlyoom: protección contra OOM"
echo "  • preload: precarga de aplicaciones"
echo "  • Servicios innecesarios desactivados"
echo "  • journald ligero (128MB max)"
echo ""
echo "RAM estimada en reposo: ~400-500MB"
echo ""
echo "Comandos útiles:"
echo "  tech-0s-kde --help       - Mostrar ayuda"
echo "  tech-0s-kde --status     - Ver estado de optimizaciones"
echo "  tech-0kde --optimize   - Ejecutar optimización manual"
echo "  tech-0s-kde --clean      - Limpiar archivos temporales"
echo "  tech-0s-kde --session    - Ver/cambiar sesión"
echo "  tech-0s-kde --themes     - Abrir configuración de temas"
echo "  systemsettings5          - Configuración de KDE"
echo "  kvantummanager           - Gestor de temas Kvantum"
echo ""
echo "Reinicia el equipo para aplicar todos los cambios."
echo "En SDDM, selecciona 'Plasma (Wayland)' para la experiencia más moderna."
echo ""
