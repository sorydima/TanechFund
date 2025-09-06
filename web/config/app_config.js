// Application Configuration for REChain VC Lab Web

const AppConfig = {
    // Application Information
    name: 'REChain VC Lab',
    description: 'Web3 Venture Capital Laboratory',
    version: '1.0.0',
    company: 'REChain VC Lab',
    copyright: 'Copyright (C) 2025 REChain VC Lab. All rights reserved.',

    // Application ID
    id: 'com.rechain.vc',

    // Window Configuration
    defaultWindowWidth: 1280,
    defaultWindowHeight: 720,
    minWindowWidth: 800,
    minWindowHeight: 600,

    // File System
    appDataDir: '.local/share/rechain-vc-lab',
    configDir: '.config/rechain-vc-lab',
    cacheDir: '.cache/rechain-vc-lab',
    logsDir: '.local/share/rechain-vc-lab/logs',

    // File Extensions
    projectFileExtension: '.rechain',
    configFileExtension: '.config',
    logFileExtension: '.log',

    // URL Schemes
    urlSchemeRechain: 'rechain',
    urlSchemeRechainvc: 'rechainvc',
    urlSchemeWeb3: 'web3',

    // Features
    enableDarkMode: true,
    enableNotifications: true,
    enableFileAssociations: true,
    enableUrlSchemes: true,
    enablePwa: true,
    enableOfflineMode: true
};

export default AppConfig;
