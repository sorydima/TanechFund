plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.rechain.vc"
    compileSdk = 36 // Android 16 (latest)
    ndkVersion = flutter.ndkVersion
    
    // Disable lint for release builds
    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.rechain.vc"
        minSdk = 24 // Android 7.0 (Nougat) - increased for better performance
        targetSdk = 36 // Android 16 (latest)
        versionCode = 5
        versionName = "1.0.4"
        
        // Enable multidex for large apps
        multiDexEnabled = true
        
        // Vector drawable support
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        getByName("debug") {
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }
        
        getByName("release") {
            // Signing with debug keys for now (replace with release keys for production)
            signingConfig = signingConfigs.getByName("debug")
            
            // Disable lint for release build to avoid file locking issues
            isDebuggable = false
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Multidex support for large apps
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Core Android libraries - Updated to latest versions
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")
    implementation("androidx.activity:activity-compose:1.9.3")
    
    // Security - Updated to stable version
    implementation("androidx.security:security-crypto:1.1.0-alpha06")
    
    // Network - Updated to latest versions
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.retrofit2:retrofit:2.11.0")
    
    // JSON parsing - Updated
    implementation("com.google.code.gson:gson:2.11.0")
    
    // Image loading - Updated
    implementation("com.github.bumptech.glide:glide:4.16.0")
    
    // Additional modern Android libraries
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.constraintlayout:constraintlayout:2.2.0")
    implementation("com.google.android.material:material:1.12.0")
}
