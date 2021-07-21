#!/bin/bash

# Platform Layer
docker push trustelem/xamarin-android:platform-only
# NDK Layer
docker push trustelem/xamarin-android:ndk-only

# API Levels + NDK
docker push trustelem/xamarin-android:30-ndk-latest

# API Levels
docker push trustelem/xamarin-android:30-latest
