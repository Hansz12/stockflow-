plugins {
    id "com.android.application"
    id "kotlin-android"
    // Plugin Flutter wajib ada
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

android {
    namespace "com.example.stockflow" // Pastikan ini sama dengan package anda
    compileSdkVersion flutter.compileSdkVersion
            ndkVersion flutter.ndkVersion

            compileOptions {
                sourceCompatibility JavaVersion.VERSION_1_8
                        targetCompatibility JavaVersion.VERSION_1_8
            }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        // ID Unik App Anda
        applicationId "com.example.stockflow"

        // --- PEMBETULAN UTAMA (WAJIB 21 KE ATAS) ---
        minSdkVersion 21
        // ------------------------------------------

        targetSdkVersion flutter.targetSdkVersion
                versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            // Signing config untuk release mode
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    // Tambahan dependencies jika perlu (biasanya kosong untuk basic flutter)
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
}