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
        println("=== DEBUG: afterEvaluate START ===")
        println("Project directory: $projectDir")

        // Check environment variables
        println("KEY_ALIAS env: ${System.getenv("KEY_ALIAS")}")
        println("KEY_PASSWORD env: ${System.getenv("KEY_PASSWORD")?.take(3)}...") // Show first 3 chars
        println("KEYSTORE_PASSWORD env: ${System.getenv("KEYSTORE_PASSWORD")?.take(3)}...")

        // Try multiple approaches
        val possiblePaths = listOf(
            "${projectDir}/android/app/key.jks",
            "android/app/key.jks",
            file("key.jks").absolutePath,
            rootProject.file("android/app/key.jks").absolutePath,
            file("${projectDir}/key.jks").absolutePath
        )

        var keystoreFile: File? = null
        for ((index, path) in possiblePaths.withIndex()) {
            val file = file(path)
            println("Checking path $index: $path")
            println("  File exists: ${file.exists()}")
            println("  Absolute path: ${file.absolutePath}")
            if (file.exists()) {
                keystoreFile = file
                println("✅ Found keystore at: ${file.absolutePath}")
                break
            }
        }

        if (keystoreFile != null && System.getenv("KEY_ALIAS") != null) {
            println("✅ Configuring release signing...")
            signingConfigs.getByName("release").apply {
                keyAlias = System.getenv("KEY_ALIAS") ?: ""
                keyPassword = System.getenv("KEY_PASSWORD") ?: ""
                storeFile = keystoreFile
                storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""

                println("  keyAlias set: ${keyAlias.isNotEmpty()}")
                println("  keyPassword set: ${keyPassword.isNotEmpty()}")
                println("  storeFile set: ${storeFile != null}")
                println("  storeFile path: ${storeFile?.absolutePath}")
                println("  storePassword set: ${storePassword.isNotEmpty()}")
            }
            println("✅ Release signing configured")
        } else {
            println("⚠️ Falling back to debug signing")
            println("  keystoreFile found: ${keystoreFile != null}")
            println("  KEY_ALIAS exists: ${System.getenv("KEY_ALIAS") != null}")
            buildTypes.getByName("release").signingConfig = signingConfigs.getByName("debug")
        }
        println("=== DEBUG: afterEvaluate END ===")
    }
}
flutter {
    source = "../.."
}