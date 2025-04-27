buildscript {
    dependencies {
        // ✅ Firebase Gradle Plugin for google-services
        classpath("com.google.gms:google-services:4.3.15")
    }

    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Optional – set custom build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ✅ Optional NDK config block – can be uncommented if needed
// android {
//     ndkVersion = "27.2.12479018"
// }
