# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Dio Network Library
-keep class dio.** { *; }
-keepclassmembers class * {
    @retrofit2.http.* <methods>;
}

# JSON serialization with built_value or json_annotation
-keep class **$serializer { *; }
-keepclassmembers class * {
  *** fromJson(...);
  *** toJson(...);
}

# Keep all model classes that might be used in JSON serialization
-keep class com.onebrain.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# Platform channel methods
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.plugin.common.EventChannel { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# OkHttp platform used by Dio
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Retrofit (if used by Dio)
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Prevent obfuscation of Flutter method channels
-keep class ** {
    public void onMethodCall(**);
}

# Keep classes with native methods
-keepclasseswithmembers class * {
    native <methods>;
}

# Google Play Core (fix for missing classes)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Additional Flutter fixes
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# General ProGuard rules for release builds
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception