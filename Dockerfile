FROM alpine
MAINTAINER Degenerate76

# Update git tags here for new releases
ENV GUACD_VERSION       0.9.14
#ENV FREERDP_VERSION    stable-1.1
#ENV PULSEAUDIO_VERSION
ENV CXX='gcc'
RUN                                                                                   \
                                                                                      \
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
     mkdir /tmp/build                                                                 \&&
     cd /tmp/build                                                                    \&&
                                                                                      \
     git clone https://github.com/sean-/ossp-uuid.git                                 \&&
     cd ossp-uuid                                                                     \&&
     ./configure                                                                      \&&
     make                                                                             \&&
     make install                                                                     \&&
     cd ..                                                                            \&&
     ln -s /usr/local/lib/libuuid.so.16.0.22 /lib/libossp-uuid.so                     \&&
                                                                                      \
     git clone https://github.com/seanmiddleditch/libtelnet.git                       \&&
     cd libtelnet                                                                     \&&
     autoreconf -i                                                                    \&&
     autoconf                                                                         \&&
     ./configure                                                                      \&&
     make                                                                             \&&
     make install                                                                     \&&
     cd ..                                                                            \&&
                                                                                      \
     git clone --branch $GUACD_VERSION https://github.com/apache/guacamole-server.git \&&
     cd guacamole-server                                                              \&&
     autoreconf -i                                                                    \&&
     autoconf                                                                         \&&
     ./configure                                                                      \&&
     make                                                                             \&&
     make install                                                                     \&&
     cd ..                                                                            \&&
                                                                                      \
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

     COPY *.ttf /usr/share/fonts/TTF/
     EXPOSE 4822
     CMD ["/usr/local/sbin/guacd", "-b", "0.0.0.0", "-f"]
