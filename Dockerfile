FROM cda0/alpine-openjdk:8u212

ENV VERSION_SDK_TOOLS=4333796
ENV ANDROID_HOME=/usr/local/android-sdk-linux

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN mkdir -p $ANDROID_HOME && chown -R root.root $ANDROID_HOME

RUN apk add --no-cache bash curl git openssl openssh-client

RUN wget -q -O sdk.zip http://dl.google.com/android/repository/sdk-tools-linux-$VERSION_SDK_TOOLS.zip && \
      unzip sdk.zip -d $ANDROID_HOME && \
      rm -f sdk.zip

ADD packages.txt $ANDROID_HOME

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg

RUN sdkmanager --update && yes | sdkmanager --licenses
RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < ${ANDROID_HOME}/packages.txt && \
    ${ANDROID_HOME}/tools/bin/sdkmanager ${PACKAGES}
