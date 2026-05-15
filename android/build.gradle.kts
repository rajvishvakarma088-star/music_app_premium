import com.android.build.gradle.BaseExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

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
    
    val applyFix = {
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.getByName("android") as BaseExtension
            
            // Fix missing namespace
            try {
                if (android.namespace == null) {
                    android.namespace = project.group.toString()
                }
            } catch (e: Exception) {}
        }
        
        // Specifically fix JVM target for on_audio_query_android if it exists
        if (project.name.contains("on_audio_query")) {
            tasks.withType<KotlinCompile>().configureEach {
                compilerOptions {
                    jvmTarget.set(JvmTarget.JVM_1_8)
                }
            }
        }
    }
    
    if (project.state.executed) {
        applyFix()
    } else {
        project.afterEvaluate {
            applyFix()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
