#ifndef WINDOWS_CONFIG_H
#define WINDOWS_CONFIG_H

// Windows-specific Configuration for REChain VC Lab

// Windows Version Support
#define MIN_WINDOWS_VERSION_MAJOR 10
#define MIN_WINDOWS_VERSION_MINOR 0
#define MIN_WINDOWS_BUILD 19041

// DPI Awareness
#define DPI_AWARENESS_CONTEXT DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2

// Window Styles
#define WINDOW_STYLE WS_OVERLAPPEDWINDOW
#define WINDOW_EX_STYLE WS_EX_APPWINDOW

// Registry Settings
#define REGISTRY_ROOT HKEY_CURRENT_USER
#define REGISTRY_APP_KEY L"SOFTWARE\\REChain VC Lab"
#define REGISTRY_SETTINGS_KEY L"SOFTWARE\\REChain VC Lab\\Settings"
#define REGISTRY_CACHE_KEY L"SOFTWARE\\REChain VC Lab\\Cache"

// File System
#define APP_DATA_FOLDER L"REChain VC Lab"
#define CACHE_FOLDER L"Cache"
#define LOGS_FOLDER L"Logs"
#define TEMP_FOLDER L"Temp"

// File Extensions
#define PROJECT_FILE_EXTENSION L".rechain"
#define CONFIG_FILE_EXTENSION L".config"
#define LOG_FILE_EXTENSION L".log"

// URL Schemes
#define URL_SCHEME_RECHAIN L"rechain"
#define URL_SCHEME_RECHAINVC L"rechainvc"
#define URL_SCHEME_WEB3 L"web3"

// Windows Features
#define ENABLE_WINDOWS_NOTIFICATIONS true
#define ENABLE_WINDOWS_TASKBAR true
#define ENABLE_WINDOWS_JUMP_LISTS true
#define ENABLE_WINDOWS_SEARCH true
#define ENABLE_WINDOWS_SHARING true

// Security
#define ENABLE_ASLR true
#define ENABLE_DEP true
#define ENABLE_CFG true

// Performance
#define ENABLE_HARDWARE_ACCELERATION true
#define ENABLE_GPU_ACCELERATION true
#define ENABLE_MULTI_THREADING true

#endif // WINDOWS_CONFIG_H
