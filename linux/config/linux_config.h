#ifndef LINUX_CONFIG_H
#define LINUX_CONFIG_H

// Linux-specific Configuration for REChain VC Lab

// Desktop Environment Support
#define ENABLE_GNOME_SUPPORT true
#define ENABLE_KDE_SUPPORT true
#define ENABLE_XFCE_SUPPORT true
#define ENABLE_MATE_SUPPORT true
#define ENABLE_CINNAMON_SUPPORT true
#define ENABLE_UNITY_SUPPORT true

// Window Manager Support
#define ENABLE_X11_SUPPORT true
#define ENABLE_WAYLAND_SUPPORT true
#define ENABLE_MIR_SUPPORT false

// File System
#define APP_DATA_DIR ".local/share/rechain-vc-lab"
#define CONFIG_DIR ".config/rechain-vc-lab"
#define CACHE_DIR ".cache/rechain-vc-lab"
#define LOGS_DIR ".local/share/rechain-vc-lab/logs"
#define TEMP_DIR "/tmp/rechain-vc-lab"

// File Extensions
#define PROJECT_FILE_EXTENSION ".rechain"
#define CONFIG_FILE_EXTENSION ".config"
#define LOG_FILE_EXTENSION ".log"

// URL Schemes
#define URL_SCHEME_RECHAIN "rechain"
#define URL_SCHEME_RECHAINVC "rechainvc"
#define URL_SCHEME_WEB3 "web3"

// Linux Features
#define ENABLE_LINUX_NOTIFICATIONS true
#define ENABLE_LINUX_TASKBAR true
#define ENABLE_LINUX_SEARCH true
#define ENABLE_LINUX_SHARING true
#define ENABLE_LINUX_INTEGRATION true

// Security
#define ENABLE_SANDBOXING false
#define ENABLE_APPARMOR false
#define ENABLE_SELINUX false

// Performance
#define ENABLE_HARDWARE_ACCELERATION true
#define ENABLE_GPU_ACCELERATION true
#define ENABLE_MULTI_THREADING true

#endif // LINUX_CONFIG_H
