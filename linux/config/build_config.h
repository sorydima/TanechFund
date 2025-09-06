#ifndef BUILD_CONFIG_H
#define BUILD_CONFIG_H

// Build Configuration for REChain VC Lab Linux

// Build Information
#define BUILD_VERSION_MAJOR 1
#define BUILD_VERSION_MINOR 0
#define BUILD_VERSION_PATCH 0
#define BUILD_VERSION_BUILD 0

// Build Type Detection
#ifdef DEBUG
#define BUILD_TYPE "Debug"
#define BUILD_CONFIGURATION "Debug"
#elif defined(NDEBUG)
#define BUILD_TYPE "Release"
#define BUILD_CONFIGURATION "Release"
#else
#define BUILD_TYPE "Profile"
#define BUILD_CONFIGURATION "Profile"
#endif

// Compiler Information
#ifdef __GNUC__
#define COMPILER_NAME "GCC"
#define COMPILER_VERSION __GNUC__
#elif defined(__clang__)
#define COMPILER_NAME "Clang"
#define COMPILER_VERSION __clang_major__
#else
#define COMPILER_NAME "Unknown"
#define COMPILER_VERSION 0
#endif

// Platform Information
#ifdef __x86_64__
#define PLATFORM_NAME "Linux x64"
#define PLATFORM_ARCHITECTURE "x64"
#elif defined(__i386__)
#define PLATFORM_NAME "Linux x86"
#define PLATFORM_ARCHITECTURE "x86"
#elif defined(__aarch64__)
#define PLATFORM_NAME "Linux ARM64"
#define PLATFORM_ARCHITECTURE "arm64"
#elif defined(__arm__)
#define PLATFORM_NAME "Linux ARM"
#define PLATFORM_ARCHITECTURE "arm"
#else
#define PLATFORM_NAME "Linux"
#define PLATFORM_ARCHITECTURE "unknown"
#endif

// Feature Flags
#define FEATURE_WEB3_INTEGRATION true
#define FEATURE_BLOCKCHAIN_SUPPORT true
#define FEATURE_VC_TOOLS true
#define FEATURE_ANALYTICS true
#define FEATURE_CRASH_REPORTING true

// Debug Features
#ifdef DEBUG
#define ENABLE_DEBUG_LOGGING true
#define ENABLE_PERFORMANCE_MONITORING true
#define ENABLE_MEMORY_LEAK_DETECTION true
#else
#define ENABLE_DEBUG_LOGGING false
#define ENABLE_PERFORMANCE_MONITORING false
#define ENABLE_MEMORY_LEAK_DETECTION false
#endif

#endif // BUILD_CONFIG_H
