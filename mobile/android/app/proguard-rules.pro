# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# App classes (JSON/serialization safety)
-keep class com.dailykatha.daily_katha.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Dio / OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# FlutterSecureStorage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# image_picker
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# image_cropper / UCrop
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

# permission_handler
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# connectivity_plus
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# Play Core (fixes R8 warnings)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Keep all annotations + line numbers
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# Kotlin
-keep class kotlin.** { *; }
-dontwarn kotlin.**
