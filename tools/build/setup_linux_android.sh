#!/bin/bash
#
# Copyright 2018 The Outline Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu

# Since the command-line Android development tools are poorly
# documented, these steps are cobbled together from lots of
# trial and error, old pinball machine parts, and various
# Dockerfiles lying around Github. Bitrise, in particular,
# maintains images with many useful hints:
#   https://github.com/bitrise-docker/android

# Download Android Command Line Tools:
#   https://developer.android.com/studio/command-line
# This is version 2.1.
ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-"/opt/android-sdk"}

# Android SDK Build Tools:
#   https://developer.android.com/studio/releases/build-tools.html
# To find the latest version's label:
#   sdkmanager --list|grep build-tools
ANDROID_BUILD_TOOLS_VERSION=${ANDROID_BUILD_TOOLS_VERSION:-"30.0.2"}

# NDK (side by side) version must be kept in sync with the default build tools NDK version.
NDK_VERSION=${NDK_VERSION:-"21.0.6113669"}

cd /opt

wget \
  -q https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip \
  -O android-commandline-tools.zip

mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools
unzip -q android-commandline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools

rm android-commandline-tools.zip

PATH="${PATH}:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin"

yes | sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "ndk;${NDK_VERSION}"
