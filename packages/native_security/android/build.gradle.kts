// Copyright 2024 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

group = "com.danhdue.native_security"
version = "1.0-SNAPSHOT"

plugins {
    // Versions are managed by pluginManagement in the host app's settings.gradle.kts.
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

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
