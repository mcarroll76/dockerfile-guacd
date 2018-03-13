FROM alpine
MAINTAINER Degenerate76

# Update git tags here for new releases
ENV GUACD_VERSION      0.9.14
ENV FREERDP_VERSION    1.0.2
ENV PULSEAUDIO_VERSION HEAD
ENV CXX='gcc'
RUN                                                                                         \
     apk add --update --no-cache                                                            \
        cairo                                                                               \
        libjpeg-turbo                                                                       \
        libpng                                                                              \
        pango                                                                               \
        libssh2                                                                             \
        libvncserver                                                                        \
        openssl                                                                             \
        libvorbis                                                                           \
        libwebp                                                                             \
        libsndfile                                                                       && \
     apk add --update --no-cache --virtual .build-deps                                      \
        git                                                                                 \
        make                                                                                \
        automake                                                                            \
        autoconf                                                                            \
        cmake                                                                               \
        gcc                                                                                 \
        libtool                                                                             \
        build-base                                                                          \
        linux-headers                                                                       \
        bsd-compat-headers                                                                  \
        intltool                                                                            \
        musl-dev                                                                            \
        cairo-dev                                                                           \
        libjpeg-turbo-dev                                                                   \
        libpng-dev                                                                          \
        pango-dev                                                                           \
        libssh2-dev                                                                         \
        libvncserver-dev                                                                    \
        openssl-dev                                                                         \
        libvorbis-dev                                                                       \
        libwebp-dev                                                                         \
        libsndfile-dev                                                                   && \
                                                                                            \
     mkdir /tmp/build                                                                    && \
     cd /tmp/build                                                                       && \
                                                                                            \
     git clone https://github.com/sean-/ossp-uuid.git                                    && \
     cd ossp-uuid                                                                        && \
     ./configure                                                                         && \
     make                                                                                && \
     make install                                                                        && \
     cd ..                                                                               && \
     ln -s /usr/local/lib/libuuid.so.16.0.22 /lib/libossp-uuid.so                        && \
                                                                                            \
     git clone https://github.com/seanmiddleditch/libtelnet.git                          && \
     cd libtelnet                                                                        && \
     autoreconf -i                                                                       && \
     autoconf                                                                            && \
     ./configure                                                                         && \
     make                                                                                && \
     make install                                                                        && \
     cd ..                                                                               && \
                                                                                            \
     git clone --branch $PULSEAUDIO_VERSION https://github.com/pulseaudio/pulseaudio.git && \
     cd pulseaudio                                                                       && \
     ./bootstrap.sh --without-caps                                                       && \
     make                                                                                && \
     make install                                                                        && \
     cd ..                                                                               && \
                                                                                            \
     git clone --branch $FREERDP_VERSION https://github.com/FreeRDP/FreeRDP.git          && \
     cmake -DCMAKE_BUILD_TYPE=Release -DWITH_SSE2=ON -DWITH_PULSEAUDIO=ON                   \
     -DWITH_CUPS=OFF -DWITH_FFMPEG=OFF -DWITH_ALSA=OFF -DWITH_X11=OFF -DWITH_XKBFILE=OFF && \
     make                                                                                && \
     make install                                                                        && \
     cd ..                                                                               && \
                                                                                            \
     git clone --branch $GUACD_VERSION https://github.com/apache/guacamole-server.git    && \
     cd guacamole-server                                                                 && \
     autoreconf -i                                                                       && \
     autoconf                                                                            && \
     ./configure                                                                         && \
     make                                                                                && \
     make install                                                                        && \
     cd ..                                                                               && \
                                                                                            \     
     apk del .build-deps                                                                 && \
     rm -Rf /tmp/build                                                                   && \
     rm -f /var/cache/apk/*                                                              && \
     mkdir -p /usr/share/fonts/TTF
     COPY LiberationMono-Regular.ttf /usr/share/fonts/TTF/
     EXPOSE 4822
     CMD ["/usr/local/sbin/guacd", "-b", "0.0.0.0", "-f"]
