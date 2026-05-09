import com.android.build.gradle.LibraryExtension

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

// Must run *after* each library's `android { compileSdkVersion … }` block (e.g. image_gallery_saver2_fixed uses 30).
// Register this *before* `evaluationDependsOn(":app")` so we don't attach afterEvaluate too late.
subprojects {
    afterEvaluate {
        extensions.findByType(LibraryExtension::class.java)?.apply {
            compileSdk = maxOf(compileSdk ?: 0, 34)
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
