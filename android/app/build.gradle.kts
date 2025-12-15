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
            val keystoreFile = file("${projectDir}/key.jks") // Path found in your debug output

            if (keystoreFile.exists()) {
                storeFile = keystoreFile
                // Read from environment variables
                keyAlias = System.getenv("KEY_ALIAS") ?: ""
                keyPassword = System.getenv("KEY_PASSWORD") ?: ""
                storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""

                println("✅ Release signing configured with keystore at: ${keystoreFile.absolutePath}")
            } else {
                println("⚠️ Keystore not found, release config will be incomplete")
            }
        }
        getByName("debug") {
            // Default debug config
        }
    }

    buildTypes {
        release {
            val releaseConfig = signingConfigs.getByName("release")
            if (releaseConfig.storeFile != null ) {
                signingConfig = releaseConfig
                println("✅ Using release signing configuration")
            } else {
                signingConfig = signingConfigs.getByName("debug")
                println("⚠️ Release config incomplete, falling back to debug signing")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

}
flutter {
    source = "../.."
}