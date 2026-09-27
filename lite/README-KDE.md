# tech-0s-kde

Versión **moderna** de tech-0s con **KDE Plasma 6** y **Wayland**.

## Características

| Característica | Detalle |
|----------------|---------|
| **Escritorio** | KDE Plasma 6 (moderno, altamente personalizable) |
| **Display Server** | Wayland por defecto (X11 opcional) |
| **Login Manager** | SDDM (tema Breeze) |
| **Tema** | Breeze oscuro + Orchis-dark GTK + Papirus-Dark |
| **RAM estimada** | ~400-500MB en reposo |
| **Ideal para** | 3-4GB RAM, Intel HD Graphics |

## Instalación rápida

```bash
cd /home/jose/tech-0s-lite
chmod +x install-kde.sh
./install-kde.sh
```

## Cambiar entre Wayland y X11

Al iniciar sesión, en SDDM:
- **Plasma (Wayland)** - Moderno, fluido, mejor soporte táctil
- **Plasma (X11)** - Compatibilidad con apps antiguas

## Personalización

### Temas KDE
```bash
systemsettings5  # Configuración completa de KDE
kvantummanager   # Gestor de temas Kvantum (GTK apps)
```

### Comandos tech-0s-kde

| Comando | Descripción |
|---------|-------------|
| `tech-0s-kde --help` | Ayuda |
| `tech-0s-kde --info` | Info del sistema |
| `tech-0s-kde --status` | Estado de optimizaciones |
| `tech-0s-kde --optimize` | Optimización manual |
| `tech-0s-kde --clean` | Limpiar temporales |
| `tech-0s-kde --session` | Ver sesión actual |
| `tech-0s-kde --themes` | Abrir config de temas |

## Comparativa

| Escritorio | RAM reposo | Modernidad | Wayland |
|------------|------------|------------|---------|
| Cinnamon (tech-0s actual) | ~600-800MB | ⭐⭐⭐ | ❌ |
| **KDE Plasma 6 (tech-0s-kde)** | **~400-500MB** | **⭐⭐⭐⭐⭐** | **✅** |
| XFCE (tech-0s-lite) | ~300-400MB | ⭐⭐⭐ | ❌ |
| GNOME 47 | ~800MB-1GB | ⭐⭐⭐⭐⭐ | ✅ |

## Optimizaciones incluidas

1. **zram** - 50% RAM comprimida (zstd)
2. **earlyoom** - Protección OOM
3. **preload** - Precarga apps
4. **SDDM** - Login moderno con Wayland
5. **Servicios desactivados** - Bluetooth, CUPS, Avahi, etc.
6. **sysctl** - swappiness=10, overcommit_memory=1
7. **journald** - 128MB máximo
8. **Limpieza automática** - /tmp cada 10 días

## Estructura

```
tech-0s-lite/
├── install-kde.sh          # Instalación KDE Plasma 6
├── post-install.sh         # Instalación XFCE ligero
├── build.sh                # Build ISO con live-build
├── README.md               # Versión XFCE
├── README-KDE.md           # Este archivo (KDE)
└── config/                 # Configuración de live-build
    ├── hooks/              # Hooks de optimización
    ├── package-lists/      # Lista de paquetes
    └── includes.chroot/    # Archivos del sistema
```

---

**tech-0s-kde** - La evolución moderna de tech-0s. Wayland, Plasma 6, y optimizado para tu hardware.
