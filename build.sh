#!/bin/bash

# Platform Layer
docker build -t trustelem/xamarin-android:platform-only ./platform
# NDK Layer
docker build -t trustelem/xamarin-android:ndk-only ./ndk

# API Levels + NDK
# docker build -t trustelem/xamarin-android:30-ndk-latest ./30/ndk

# API Levels
docker build -t trustelem/xamarin-android:30-latest ./30
