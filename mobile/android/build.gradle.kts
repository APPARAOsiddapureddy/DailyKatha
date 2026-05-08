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
// Keep this hook available if future pub packages need patching.
subprojects {}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
