group = "com.danhdue.{{name.snakeCase()}}"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.1.0"
    val agpVersion = "8.13.2"
    val kspVersion = "2.1.0-1.0.29"

    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:$agpVersion")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        classpath("com.google.devtools.ksp:com.google.devtools.ksp.gradle.plugin:$kspVersion")
        {{#has_ui}}
        classpath("org.jetbrains.kotlin:compose-compiler-gradle-plugin:$kotlinVersion")
        {{/has_ui}}
    }
}

apply(plugin = "com.android.library")
apply(plugin = "org.jetbrains.kotlin.android")
apply(plugin = "com.google.devtools.ksp")
{{#has_ui}}
apply(plugin = "org.jetbrains.kotlin.plugin.compose")
{{/has_ui}}

android {
    namespace = "com.danhdue.{{name.snakeCase()}}"
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

    {{#has_ui}}
    buildFeatures {
        compose = true
    }
    {{/has_ui}}

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
        getByName("test").java.srcDirs("src/test/kotlin")
    }

    testOptions {
        unitTests.isReturnDefaultValues = true
        unitTests.isIncludeAndroidResources = true
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
    // Pure Dagger 2
    implementation("com.google.dagger:dagger:2.51.1")
    add("ksp", "com.google.dagger:dagger-compiler:2.51.1")

    // Background WorkManager (Zero Flutter Engine)
    implementation("androidx.work:work-runtime-ktx:2.10.0")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0")

    {{#has_ui}}
    // Jetpack Compose (Pure, No Hilt)
    implementation(platform("androidx.compose:compose-bom:2024.09.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.runtime:runtime")
    implementation("androidx.compose.foundation:foundation")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.activity:activity-compose:1.9.2")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.5")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.5")
    {{/has_ui}}

    // Testing
    testImplementation("junit:junit:4.13.2")
    testImplementation("io.mockk:mockk:1.13.12")
    testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:1.9.0")
    testImplementation("androidx.work:work-testing:2.10.0")
    {{#has_ui}}
    testImplementation("app.cash.turbine:turbine:1.1.0")
    testImplementation("org.robolectric:robolectric:4.13")
    {{/has_ui}}
}
