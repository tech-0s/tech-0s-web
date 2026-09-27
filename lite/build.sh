#!/bin/bash
# tech-0s-lite | script de build con live-build
# Crea una ISO optimizada de tech-0s-lite con XFCE

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
CONFIG_DIR="$SCRIPT_DIR/config"

echo "=========================================="
echo "  tech-0s-lite | Build con live-build"
echo "=========================================="
echo ""

# Verificar que live-build está instalado
if ! command -v lb &> /dev/null; then
    echo "ERROR: live-build no está instalado."
    echo "Instálalo con: sudo apt install live-build"
    exit 1
fi

# Verificar que estamos en Debian
if [ ! -f /etc/debian_version ]; then
    echo "ERROR: Este script debe ejecutarse en Debian."
    exit 1
fi

# Limpiar build anterior
echo "[1/4] Limpiando build anterior..."
sudo lb clean --all 2>/dev/null || true

# Configurar live-build
echo "[2/4] Configurando live-build..."
mkdir -p "$BUILD_DIR/auto"

# Crear auto/config (configuración unificada)
cat > "$BUILD_DIR/auto/config" <<'AUTOEOF'
#!/bin/bash
set -e

# tech-0s-lite - configuración de live-build

LB_DISTRIBUTION="trixie"
LB_ARCHITECTURES="amd64"
LB_MODE="debian"
LB_ISO_APPLICATION="tech-0s-lite"
LB_ISO_VOLUME="tech-0s-lite"
LB_BOOTLOADERS="grub-efi,grub-pc"
LB_BOOTSTRAP_INCLUDE="live-boot live-config"
LB_PACKAGE_LISTS="standard"
LB_APT_RECOMMENDS="false"
LB_SECURITY="true"
LB_UPDATES="true"
LB_ARCHIVE_INDICES="false"
LB_ISO_HYBRID="true"
LB_ISO_MEMTEST="none"
LB_FIRMWARE_CHROOT="false"
LB_FIRMWARE_BINARY="false"
LB_SQUASHFS_COMPRESSION="xz"
LB_INITRAMFS="live-boot"
LB_LOCALE="es_ES.UTF-8"
LB_KEYBOARD_LAYOUTS="es"
LB_TIMEZONE="America/Mexico_City"
LB_USERNAME="techos"
LB_USER_FULLNAME="tech-0s User"
LB_USER_PASSWORD="techos"
LB_HOSTNAME="tech-0s-lite"
LB_MIRROR_BOOTSTRAP="http://deb.debian.org/debian/"
LB_MIRROR_CHROOT="http://deb.debian.org/debian/"
LB_MIRROR_BINARY="http://deb.debian.org/debian/"
LB_APT_INDICES="false"
LB_APT_RECOMMENDS="false"
LB_APT_SECURE="true"
LB_DEBIAN_INSTALLER="false"
LB_TASKSEL="standard"
LB_SYSLINUX_MENU="true"
LB_GRUB_BOOT_MENU="true"
LB_CHROOT_FILESYSTEM="squashfs"
LB_BINARY_FILESYSTEM="fat32"
LB_BINARY_IMAGES="iso-hybrid"
LB_BINARY_INDICES="false"
LB_MEMTEST="none"
LB_WIN32_LOADER="false"
LB_NET_ROOT_PATH="/srv/debian-live"
LB_NET_ROOT_SERVER="deb.debian.org"
AUTOEOF

chmod +x "$BUILD_DIR/auto/config"

# Crear auto/clean
cat > "$BUILD_DIR/auto/clean" <<'CLEANEOF'
#!/bin/bash
set -e
rm -rf cache/ chroot/ binary/ build.log
CLEANEOF
chmod +x "$BUILD_DIR/auto/clean"

# Crear auto/build
cat > "$BUILD_DIR/auto/build" <<'BUILDEOF'
#!/bin/bash
set -e
echo "tech-0s-lite build completado: $(date)"
BUILDEOF
chmod +x "$BUILD_DIR/auto/build"

# Copiar configuración del proyecto
echo "[3/4] Copiando configuración..."
mkdir -p "$BUILD_DIR/config"
cp -r "$CONFIG_DIR"/* "$BUILD_DIR/config/"

# Ejecutar build
echo "[4/4] Ejecutando live-build (esto puede tardar 30-60 minutos)..."
echo ""
cd "$BUILD_DIR"
sudo lb build

echo ""
echo "=========================================="
echo "  tech-0s-lite | Build completado"
echo "=========================================="
echo ""
echo "La ISO se encuentra en: $BUILD_DIR/"
ls -lh "$BUILD_DIR"/*.iso 2>/dev/null || echo "Buscando ISO..."
find "$BUILD_DIR" -name "*.iso" -exec ls -lh {} \;
echo ""
echo "Para instalar en USB:"
echo "  sudo dd if=tech-0s-lite_*.iso of=/dev/sdX bs=4M status=progress"
echo ""
