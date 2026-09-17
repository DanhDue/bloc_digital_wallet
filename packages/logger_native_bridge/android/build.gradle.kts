// Copyright 2024 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

group = "com.danhdue.logger_native_bridge"
version = "1.0-SNAPSHOT"

plugins {
    // Versions are managed by pluginManagement in the host app's settings.gradle.kts.
    // Using apply() in Kotlin DSL does NOT inject the android{} extension into the
    // type system — the plugins{} block is required.
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.danhdue.logger_native_bridge"
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
    testImplementation("junit:junit:4.13.2")
}
