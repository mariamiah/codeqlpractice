# Use an official OpenJDK image as the base image
FROM openjdk:11

# Install necessary tools
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Android SDK command line tools
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O commandlinetools.zip && \
    unzip commandlinetools.zip && \
    rm commandlinetools.zip && \
    mkdir -p /opt/android-sdk/cmdline-tools/latest && \
    mv cmdline-tools/* /opt/android-sdk/cmdline-tools/latest

# Set environment variables
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV PATH $ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

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
