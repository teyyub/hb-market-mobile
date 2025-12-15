import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "az.hb.market"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "az.hb.market"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Empty for now - will be filled in afterEvaluate
        }
        getByName("debug") {
            // Default debug config
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    afterEvaluate {
        val keystorePropertiesFile = rootProject.file("key.properties")
        if (keystorePropertiesFile.exists()) {
            val keystoreProperties = Properties().apply {
                load(FileInputStream(keystorePropertiesFile))
            }

            signingConfigs.getByName("release").apply {
                keyAlias = keystoreProperties.getProperty("keyAlias", "")
                keyPassword = keystoreProperties.getProperty("keyPassword", "")
                val storeFilePath = keystoreProperties.getProperty("storeFile", "")
                if (storeFilePath.isNotEmpty()) {
                    storeFile = file(storeFilePath)
                } else {
                    println("⚠️ Warning: storeFile path is empty in key.properties")
                }

                storePassword = keystoreProperties.getProperty("storePassword", "")
            }
        } else {
            // Fall back to debug signing if no key.properties
            buildTypes.getByName("release").signingConfig = signingConfigs.getByName("debug")
        }
    }
}
flutter {
    source = "../.."
}