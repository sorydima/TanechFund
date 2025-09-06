// Web-specific Configuration for REChain VC Lab

const WebConfig = {
    // Browser Support
    enableChromeSupport: true,
    enableFirefoxSupport: true,
    enableSafariSupport: true,
    enableEdgeSupport: true,
    enableOperaSupport: true,

    // Web APIs
    enableServiceWorker: true,
    enableWebAppManifest: true,
    enablePushNotifications: true,
    enableGeolocation: true,
    enableCamera: true,
    enableMicrophone: true,
    enableFileSystem: true,
    enableIndexedDB: true,
    enableWebGL: true,
    enableWebRTC: true,

    // File System
    appDataDir: '.local/share/rechain-vc-lab',
    configDir: '.config/rechain-vc-lab',
    cacheDir: '.cache/rechain-vc-lab',
    logsDir: '.local/share/rechain-vc-lab/logs',
    tempDir: '/tmp/rechain-vc-lab',

    // File Extensions
    projectFileExtension: '.rechain',
    configFileExtension: '.config',
    logFileExtension: '.log',

    // URL Schemes
    urlSchemeRechain: 'rechain',
    urlSchemeRechainvc: 'rechainvc',
    urlSchemeWeb3: 'web3',

    // Web Features
    enableWebNotifications: true,
    enableWebTaskbar: true,
    enableWebSearch: true,
    enableWebSharing: true,
    enableWebIntegration: true,

    // Security
    enableSandboxing: false,
    enableCSP: true,
    enableHSTS: true,
    enableCORS: true,

    // Performance
    enableHardwareAcceleration: true,
    enableGpuAcceleration: true,
    enableMultiThreading: true
};

export default WebConfig;
