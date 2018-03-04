FROM alpine
MAINTAINER Degenerate76

# Update git tags here for new releases
ENV GUACD_VERSION       0.9.14
#ENV FREERDP_VERSION    stable-1.1
#ENV PULSEAUDIO_VERSION
ENV CXX='gcc'
RUN                                                                                   \
                                                                                      \
# Install build prerequisites                                                         \
     apk add --update                                                                 \
        cairo                                                                         \
        libjpeg-turbo                                                                 \
        libpng                                                                        \
        ffmpeg                                                                        \
        pango                                                                         \
        libssh2                                                                       \
        libvncserver                                                                  \
        openssl                                                                       \
        libvorbis                                                                     \
        libwebp                                                                       \
        terminus-font                                                                 \
        git                                                                           \
        make                                                                          \
        automake                                                                      \
        autoconf                                                                      \
        cmake                                                                         \
        gcc                                                                           \
        libtool                                                                       \
        build-base                                                                    \
        linux-headers                                                                 \
        bsd-compat-headers                                                            \
        musl-dev                                                                      \
        cairo-dev                                                                     \
        libjpeg-turbo-dev                                                             \
        libpng-dev                                                                    \
        ffmpeg-dev                                                                    \
        pango-dev                                                                     \
        libssh2-dev                                                                   \
        libvncserver-dev                                                              \
        openssl-dev                                                                   \
        libvorbis-dev                                                                 \
        libwebp-dev                                                                   \&&
                                                                                      \
# Setup build environment                                                             \
     mkdir /tmp/build                                                                 \&&
     cd /tmp/build                                                                    \&&
                                                                                      \
# Build & install ossp-uuid                                                           \
     git clone https://github.com/sean-/ossp-uuid.git                                 \&&
     cd ossp-uuid                                                                     \&&
     ./configure                                                                      \&&
     make                                                                             \&&
     make install                                                                     \&&
     cd ..                                                                            \&&
     ln -s /usr/local/lib/libuuid.so.16.0.22 /lib/libossp-uuid.so                     \&&
                                                                                      \
# Build & install libtelnet                                                           \
     git clone https://github.com/seanmiddleditch/libtelnet.git                       \&&
     cd libtelnet                                                                     \&&
     autoreconf -i                                                                    \&&
     autoconf                                                                         \&&
     ./configure                                                                      \&&
     make                                                                             \&&
     make install                                                                     \&&
     cd ..                                                                            \&&
                                                                                      \
# Build & install FreeRDP                                                             \
#    git clone https://github.com/FreeRDP/FreeRDP.git                                 \&&
#    cd FreeRDP                                                                       \&&
#    cmake -DCMAKE_BUILD_TYPE=Debug -DWITH_SSE2=ON                                    \&&
#    make                                                                             \&&
#    make install                                                                     \&&
#    cd ..                                                                            \&&
#    ln -s /usr/local/lib64/libfreerdp2.so.2.0.0 /lib/libfreerdp-core.so              \&&
                                                                                      \
# Build & install pulseaudio                                                          \
#    git clone https://github.com/pulseaudio/pulseaudio.git                           \&&
#    cd pulseaudio                                                                    \&&
#    ./configure                                                                      \&&
#    make                                                                             \&&
#    make install                                                                     \&&
#    cd ..                                                                            \&&
                                                                                      \
# Build & install guacd                                                               \
     git clone --branch $GUACD_VERSION https://github.com/apache/guacamole-server.git \&&
     cd guacamole-server                                                              \&&
     autoreconf -i                                                                    \&&
     autoconf                                                                         \&&
     ./configure                                                                      \&&
     make                                                                             \&&
     make install                                                                     \&&
     cd ..                                                                            \&&
                                                                                      \
# Clean up                                                                            \
     rm -Rf /tmp/build                                                                \&&
        apk del                                                                       \
        git                                                                           \
        make                                                                          \
        automake                                                                      \
        autoconf                                                                      \
        cmake                                                                         \
        gcc                                                                           \
        libtool                                                                       \
        build-base                                                                    \
        linux-headers                                                                 \
        bsd-compat-headers                                                            \
        musl-dev                                                                      \
        cairo-dev                                                                     \
        libjpeg-turbo-dev                                                             \
        libpng-dev                                                                    \
        ffmpeg-dev                                                                    \
        pango-dev                                                                     \
        libssh2-dev                                                                   \
        libvncserver-dev                                                              \
        openssl-dev                                                                   \
        libvorbis-dev                                                                 \
        libwebp-dev                                                                   \&&
     rm -f /var/cache/apk/*                                                           \&&
     mkdir /usr/share/fonts/TTF

# Final Configuration
     COPY *.ttf /usr/share/fonts/TTF/
     EXPOSE 4822
     CMD ["/usr/local/sbin/guacd", "-b", "0.0.0.0", "-f"]
