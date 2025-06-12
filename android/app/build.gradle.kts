plugins {
    id("com.android.application")
    id("kotlin-android")

    // ✅ Add Google Services plugin
    id("com.google.gms.google-services")

    // Flutter plugin (must come after android/kotlin plugins)
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.expensetracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.expensetracker"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {

    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

    // ✅ Firebase SDKs you want to use (version is handled by BoM)
    implementation("com.google.firebase:firebase-analytics")
    // Add other Firebase products here if needed:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
    // implementation("com.google.firebase:firebase-database")
}
