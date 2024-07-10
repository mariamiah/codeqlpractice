# Use an official Android SDK image as the base image
FROM openjdk:11

# Install necessary tools
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Android SDK
RUN mkdir -p /opt/android-sdk && \
    cd /opt/android-sdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d /opt/android-sdk/cmdline-tools && \
    rm cmdline-tools.zip

# Set environment variables
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV PATH $ANDROID_SDK_ROOT/cmdline-tools/bin:$PATH

# Accept licenses
RUN yes | sdkmanager --licenses

# Install necessary Android SDK components
RUN sdkmanager "platforms;android-30" "build-tools;30.0.3"

# Copy Gradle wrapper and project files
COPY . /mnt/volume/

# Set working directory
WORKDIR /mnt/volume/

# Run Gradle build
CMD ["./gradlew", "build"]
