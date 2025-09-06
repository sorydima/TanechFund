#ifndef APP_CONFIG_H
#define APP_CONFIG_H

// Application Configuration for REChain VC Lab Linux

// Application Information
#define APP_NAME "REChain VC Lab"
#define APP_DESCRIPTION "Web3 Venture Capital Laboratory"
#define APP_VERSION "1.0.0"
#define APP_COMPANY "REChain VC Lab"
#define APP_COPYRIGHT "Copyright (C) 2025 REChain VC Lab. All rights reserved."

// Application ID
#define APP_ID "com.rechain.vc"

// Window Configuration
#define DEFAULT_WINDOW_WIDTH 1280
#define DEFAULT_WINDOW_HEIGHT 720
#define MIN_WINDOW_WIDTH 800
#define MIN_WINDOW_HEIGHT 600

// File System
#define APP_DATA_DIR ".local/share/rechain-vc-lab"
#define CONFIG_DIR ".config/rechain-vc-lab"
#define CACHE_DIR ".cache/rechain-vc-lab"
#define LOGS_DIR ".local/share/rechain-vc-lab/logs"

// File Extensions
#define PROJECT_FILE_EXTENSION ".rechain"
#define CONFIG_FILE_EXTENSION ".config"
#define LOG_FILE_EXTENSION ".log"

// URL Schemes
#define URL_SCHEME_RECHAIN "rechain"
#define URL_SCHEME_RECHAINVC "rechainvc"
#define URL_SCHEME_WEB3 "web3"

// Features
#define ENABLE_DARK_MODE true
#define ENABLE_NOTIFICATIONS true
#define ENABLE_FILE_ASSOCIATIONS true
#define ENABLE_URL_SCHEMES true
#define ENABLE_GNOME_INTEGRATION true
#define ENABLE_KDE_INTEGRATION true

#endif // APP_CONFIG_H
