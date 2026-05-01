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
subprojects {
    project.evaluationDependsOn(":app")
}

// AGP 8+ requires every Android module to declare a `namespace`.
// Some pub packages still omit it; patch them here without touching pub-cache.
subprojects {
    // Intentionally left empty: keep subproject hooks available if needed.
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
