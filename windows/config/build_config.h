#ifndef BUILD_CONFIG_H
#define BUILD_CONFIG_H

// Build Configuration for REChain VC Lab Windows

// Build Information
#define BUILD_VERSION_MAJOR 1
#define BUILD_VERSION_MINOR 0
#define BUILD_VERSION_PATCH 0
#define BUILD_VERSION_BUILD 0

// Build Type Detection
#ifdef _DEBUG
#define BUILD_TYPE L"Debug"
#define BUILD_CONFIGURATION L"Debug"
#elif defined(NDEBUG)
#define BUILD_TYPE L"Release"
#define BUILD_CONFIGURATION L"Release"
#else
#define BUILD_TYPE L"Profile"
#define BUILD_CONFIGURATION L"Profile"
#endif

// Compiler Information
#ifdef _MSC_VER
#define COMPILER_NAME L"Microsoft Visual C++"
#define COMPILER_VERSION _MSC_VER
#else
#define COMPILER_NAME L"Unknown"
#define COMPILER_VERSION 0
#endif

// Platform Information
#ifdef _WIN64
#define PLATFORM_NAME L"Windows x64"
#define PLATFORM_ARCHITECTURE L"x64"
#else
#define PLATFORM_NAME L"Windows x86"
#define PLATFORM_ARCHITECTURE L"x86"
#endif

// Feature Flags
#define FEATURE_WEB3_INTEGRATION true
#define FEATURE_BLOCKCHAIN_SUPPORT true
#define FEATURE_VC_TOOLS true
#define FEATURE_ANALYTICS true
#define FEATURE_CRASH_REPORTING true

// Debug Features
#ifdef _DEBUG
#define ENABLE_DEBUG_LOGGING true
#define ENABLE_PERFORMANCE_MONITORING true
#define ENABLE_MEMORY_LEAK_DETECTION true
#else
#define ENABLE_DEBUG_LOGGING false
#define ENABLE_PERFORMANCE_MONITORING false
#define ENABLE_MEMORY_LEAK_DETECTION false
#endif

#endif // BUILD_CONFIG_H
