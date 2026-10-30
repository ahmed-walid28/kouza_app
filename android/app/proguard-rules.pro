# Preserve TensorFlow Lite GPU classes
-keep class org.tensorflow.** { *; }
-keepclassmembers class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# Preserve TensorFlow Lite JNI native methods
-keepclassmembers class * {
    native <methods>;
}

# Prevent shrinking of all classes related to TensorFlow Lite
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**
