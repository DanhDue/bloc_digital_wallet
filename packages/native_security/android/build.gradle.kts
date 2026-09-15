group = "com.danhdue.native_security"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.1.0"
    val agpVersion = "8.13.2"

    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:$agpVersion")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

apply(plugin = "com.android.library")
apply(plugin = "org.jetbrains.kotlin.android")

android {
    namespace = "com.danhdue.native_security"
    compileSdk = 35

    defaultConfig {
        minSdk = 24
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = "21"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
        getByName("test").java.srcDirs("src/test/kotlin")
    }

    externalNativeBuild {
        cmake {
            path("CMakeLists.txt")
        }
    }

    testOptions {
        unitTests.isReturnDefaultValues = true
    }
}

repositories {
    google()
    mavenCentral()
    maven {
        url = uri("https://storage.googleapis.com/download.flutter.io")
    }
}

dependencies {
    implementation(project(":logger_native_bridge"))
    testImplementation("junit:junit:4.13.2")
}
