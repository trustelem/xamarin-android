FROM ubuntu:focal

LABEL maintainer="Trustelem <contact@trustelem.com>"

ENV TZ=Europe/Berlin

# Get command line tools version from here: https://developer.android.com/studio
ENV SDK_CMD_TOOLS=7302050
# Get BUILD ID from here: https://dev.azure.com/xamarin/public/_build?definitionId=48&_a=summary
# Click on the desired commit and extract the buildId from the url
ENV XAMARIN_OSS_BUILD_ID=31879

RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# .NET
RUN curl -k "https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb" -o dotnet.deb && \
    dpkg -i dotnet.deb

# MONO
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && apt-get install -y \
    mono-complete \
    dotnet-sdk-3.1 \
    nuget \
    && rm -rf /var/lib/apt/lists/*

# Xamarin Android OSS Linux
RUN apt-get update && apt-get install -y \
    unzip \
    jq \
    lxd \
    bzip2 \
    libzip5 \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/lib/xamarin.android && \
    mkdir /usr/lib/mono/xbuild/Xamarin/ && \
    mkdir /xamarin

RUN curl -k "https://dev.azure.com/xamarin/public/_apis/build/builds/{$XAMARIN_OSS_BUILD_ID}/artifacts?artifactName=Installers%20-%20Linux&api-version=5.1" | curl -L $(jq -r '.resource.downloadUrl') -o xamarin-linux.zip && \
    unzip -q xamarin-linux.zip -d /tmp/xamarin-linux && \
    rm xamarin-linux.zip && \
    cd "/tmp/xamarin-linux/Installers - Linux/" && \
    tar xjf ./xamarin.android-oss-v*.tar.bz2 --strip 1 -C /xamarin && \
    cp -a /xamarin/bin/Release/lib/xamarin.android/. /usr/lib/xamarin.android/ && \
    rm -rf /usr/lib/mono/xbuild/Xamarin/Android && \
    rm -rf /usr/lib/mono/xbuild-frameworks/MonoAndroid && \
    ln -s /usr/lib/xamarin.android/xbuild/Xamarin/Android/ /usr/lib/mono/xbuild/Xamarin/Android && \
    ln -s /usr/lib/xamarin.android/xbuild-frameworks/MonoAndroid/ /usr/lib/mono/xbuild-frameworks/MonoAndroid && \
    ln -s /usr/lib/x86_64-linux-gnu/libzip.so.5.0 /usr/lib/x86_64-linux-gnu/libzip.so.4 && \
    rm -rf /tmp/xamarin-linux

ENV PATH=/xamarin/bin/Release/bin:$PATH

# JAVA
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Android SDK
RUN apt-get update && apt-get install -y \
    unzip &&\
    rm -rf /var/lib/apt/lists/* &&\
    mkdir -p /usr/lib/android-sdk/cmdline-tools/latest && \
    curl -k "https://dl.google.com/android/repository/commandlinetools-linux-{$SDK_CMD_TOOLS}_latest.zip" -o commandlinetools-linux.zip && \
    unzip -q commandlinetools-linux.zip -d /usr/lib/android-sdk/tmp && \
    mv  /usr/lib/android-sdk/tmp/cmdline-tools/* /usr/lib/android-sdk/cmdline-tools/latest && \
    rm -rf /usr/lib/android-sdk/tmp/ && \
    rm commandlinetools-linux.zip 

ENV AndroidSdkDirectory=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools"

# Copy library scripts to execute
COPY library-scripts/common-debian.sh library-scripts/meta.env /tmp/library-scripts/
# [Option] Install zsh
ARG INSTALL_ZSH="false"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=build
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts
