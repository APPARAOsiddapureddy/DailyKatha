allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Keep Android build outputs under `mobile/build/` (Flutter tooling expects this default layout).
rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)
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
    delete(rootProject.buildDir)
}
