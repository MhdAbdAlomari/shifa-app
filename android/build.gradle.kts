allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Force a single NDK version across the whole build, including plugin
// sub-projects pulled in via pub. Flutter's Gradle helper defaults
// `flutter.ndkVersion` to a specific value (currently 28.2.13676358 —
// see D:\flutter\packages\flutter_tools\gradle\...\FlutterExtension.kt).
// If that NDK isn't installed cleanly the build dies with CXX1101 /
// CXX1104. Concretely the offender here is transitive `jni-1.0.3`,
// whose `android/build.gradle` reads `ndkVersion flutter.ndkVersion`
// inside its own `android {}` block.
//
// Registering `afterEvaluate` here — *before* the pre-existing
// `subprojects { evaluationDependsOn(":app") }` below actually triggers
// subproject evaluation — queues our override so it runs at the tail of
// each subproject's evaluation, after the plugin's own `android {}`
// block. That's what makes it win over the value the plugin sets.
val forcedNdkVersion = "27.0.12077973"
subprojects {
    afterEvaluate {
        extensions.findByType(
            com.android.build.gradle.BaseExtension::class.java
        )?.ndkVersion = forcedNdkVersion
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
