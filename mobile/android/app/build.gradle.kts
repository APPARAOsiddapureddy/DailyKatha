import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
val hasReleaseKeystore = keystorePropertiesFile.exists()
if (hasReleaseKeystore) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.dailykatha.daily_katha"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.dailykatha.daily_katha"
        // Truecaller OAuth requires API 24+. Keep the app on that floor for the login release.
        minSdk = maxOf(flutter.minSdkVersion, 24)
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Daily Katha (Dev)")
            manifestPlaceholders["usesCleartextTraffic"] = "true"
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Daily Katha (Staging)")
            manifestPlaceholders["usesCleartextTraffic"] = "false"
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Daily Katha")
            manifestPlaceholders["usesCleartextTraffic"] = "false"
        }
    }

    // Some environments (local or CI) can fail while stripping symbols from third-party native libs.
    // Keeping symbols avoids the strip step from breaking the release bundle.
    packaging {
        jniLibs {
            useLegacyPackaging = true
            keepDebugSymbols += setOf("**/*.so")
        }
    }

    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Play Store: add android/keystore.properties to switch this release build to your
            // real signing key. Until then, this stays signed with debug for local testing only.
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.truecaller.android.sdk:truecaller-sdk:3.2.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
