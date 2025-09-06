// Build Configuration for REChain VC Lab Web

const BuildConfig = {
    // Build Information
    versionMajor: 1,
    versionMinor: 0,
    versionPatch: 0,
    versionBuild: 0,

    // Build Type Detection
    buildType: process.env.NODE_ENV === 'production' ? 'Release' : 'Debug',
    buildConfiguration: process.env.NODE_ENV === 'production' ? 'Release' : 'Debug',

    // Compiler Information
    compilerName: 'Webpack',
    compilerVersion: '5.0.0',

    // Platform Information
    platformName: 'Web',
    platformArchitecture: 'web',

    // Feature Flags
    featureWeb3Integration: true,
    featureBlockchainSupport: true,
    featureVcTools: true,
    featureAnalytics: true,
    featureCrashReporting: true,

    // Debug Features
    enableDebugLogging: false, // Disabled for production
    enablePerformanceMonitoring: true, // Keep for production monitoring
    enableMemoryLeakDetection: false, // Disabled for production

    // Production Optimizations
    enableMinification: true,
    enableTreeShaking: true,
    enableCodeSplitting: true,
    enableCompression: true,
    enableCaching: true
};

export default BuildConfig;
