# tech-0s-lite

Versión optimizada de **tech-0s** diseñada para equipos con **4GB de RAM o menos**.

## Características

- **Escritorio XFCE** - Entorno ligero que consume ~300-400MB RAM en reposo
- **zram** - Compresión de memoria en RAM (50% de la RAM disponible)
- **earlyoom** - Protección contra OOM kills catastróficos
- **preload** - Precarga inteligente de aplicaciones frecuentes
- **Servicios optimizados** - Bluetooth, CUPS, Avahi, ModemManager desactivados por defecto
- **Kernel optimizado** - Parámetros sysctl ajustados para poca RAM
- **journald ligero** - Límite de 128MB para logs del sistema
- **Tema visual tech-0s** - Orchis-Dark + Papirus-Dark + Bibata cursors

## Requisitos

- **RAM**: 2GB mínimo, 4GB recomendado
- **Disco**: 16GB mínimo
- **Procesador**: x86_64 (AMD64)
- **Base**: Debian Trixie / Linux Mint Debian Edition

## Instalación rápida (post-instalación)

Si ya tienes Linux Mint instalado y quieres convertirlo a tech-0s-lite:

```bash
# Haz backup de tus datos importantes primero
cd /home/jose/tech-0s-lite
chmod +x post-install.sh
./post-install.sh
```

Esto instalará XFCE, purgará paquetes de Mint, y aplicará todas las optimizaciones.

## Construir ISO desde cero

Para crear una ISO booteable de tech-0s-lite:

```bash
# Instalar dependencias
sudo apt install live-build

# Construir ISO
cd /home/jose/0s-lite
chmod +x build.sh
./build.sh
```

La ISO se generará en `build/` y podrás grabarla en USB con:

```bash
sudo dd if=build/tech-0s-lite_*.iso of=/dev/sdX bs=4M status=progress
```

## Comandos útiles

Después de instalar tech-0s-lite, tienes disponibles estos comandos:

| Comando | Descripción |
|---------|-------------|
| `tech-0s-lite --help` | Mostrar ayuda |
| `tech-0s-lite --info` | Información del sistema |
| `tech-0s-lite --status` | Estado de las optimizaciones |
| `tech-0s-lite --optimize` | Ejecutar optimización manual |
| `tech-0s-lite --clean` | Limpiar archivos temporales |
| `htop` | Monitor del sistema |
| `neofetch` | Info del sistema |
| `bleachbit` | Limpieza de archivos |

## Optimizaciones aplicadas

### 1. zram (compresión de memoria)
```bash
# Configuración: 50% de RAM como dispositivo zram con compresión zstd
ALGO=zstd
PERCENT=50
PRIORITY=100
```

### 2. earlyoom (protección OOM)
```bash
# Mata procesos cuando RAM < 4% y Swap < 10%
# Prioriza matar navegadores sobre sesiones de usuario
EARLYOOM_ARGS="-r 60 -m 4 -s 100 --prefer '^(Web Content|firefox|electron|chrome)' --avoid '^(xfce4-session|Xorg|lightdm|systemd)$'"
```

### 3. sysctl (kernel)
- `vm.swappiness=10` - Usar swap solo cuando sea necesario
- `vm.dirty_ratio=15` - Menos caché de escritura
- `vm.vfs_cache_pressure=50` - Reducir caché de inodos

### 4. journald (logs)
- Límite de 128MB para logs del sistema
- Compresión activada

### 5. Servicios desactivados
- Bluetooth
- CUPS (impresión)
- Avahi (descubrimiento de red)
- ModemManager (banda ancha móvil)
- Apport (reporte de errores)
- whoopsie (reporte de crash de Ubuntu)
- speech-dispatcher

### 6. Módulos del kernel desactivados
- Bluetooth (btusb, bluetooth, rfcomm, bnep)
- Webcam (uvcvideo)
- Lector de tarjetas (rtsx_pci_sdmmc)

## Estructura del proyecto

```
tech-0s-lite/
├── build.sh                    # Script de build con live-build
├── post-install.sh             # Script de post-instalación
├── config/
│   ├── hooks/
│   │   └── normal/
│   │       └── 01-lite-optimize.hook.chroot    # Hook de optimización
│   ├── package-lists/
│   │   └── tech0s-lite.list.chroot             # Lista de paquetes XFCE
│   └── includes.chroot/        # Archivos copiados al chroot
│       ├── etc/
│       │   ├── os-release
│       │   ├── dconf/...       # Defaults de XFCE
│       │   ├── lightdm/...     # Config login
│       │   ├── default/...     # GRUB, zram, earlyoom
│       │   ├── sysctl.d/...    # Optimizaciones kernel
│       │   ├── modprobe.d/...  # Módulos desactivados
│       │   ├── tmpfiles.d/...  # Limpieza automática
│       │   └── xdg/autostart/... # Bienvenida
│       └── usr/
│           ├── local/bin/...   # Comandos tech-0s-lite
│           └── share/...       # Temas, wallpapers, logo
```

## Comparativa de consumo de RAM

| Escritorio | RAM en reposo |
|------------|---------------|
| Cinnamon (tech-0s) | ~600-800MB |
| **XFCE (tech-0s-lite)** | **~300-400MB** |
| LXQt | ~250-350MB |
| i3wm | ~150-250MB |

## Créditos

Basado en **tech-0s** - Distribución basada en Linux Mint Debian Edition (LMDE 7 "Gigi") con rebranding completo.

## Licencia

Los scripts y configuraciones son de código libre. Los paquetes instalados mantienen sus respectivas licencias.

---

**tech-0s-lite** - Ligero, rápido y optimizado para tu hardware.
