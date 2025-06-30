FROM ubuntu:22.04 as base
RUN apt-get update
RUN useradd -m openttd
WORKDIR /openttd/
RUN chown -R openttd:openttd /openttd/

FROM base as base-empty
USER openttd

FROM base as base-download
RUN apt-get install -y wget
USER openttd

FROM base as base-xz
RUN apt-get install -y xz-utils
USER openttd

FROM base as base-zip
RUN apt-get install -y zip unzip
USER openttd

FROM base-download as base-download-game
RUN wget -O openttd.tar.xz https://cdn.openttd.org/openttd-releases/14.1/openttd-14.1-linux-generic-amd64.tar.xz

FROM base-xz as base-xz-game
COPY --from=base-download-game /openttd/openttd.tar.xz openttd.tar.xz
RUN tar -xvf openttd.tar.xz
RUN mv openttd-14.1-linux-generic-amd64 openttd

FROM base-download as base-download-gfx
RUN wget https://cdn.openttd.org/opengfx-releases/7.1/opengfx-7.1-all.zip

FROM base-zip as base-zip-gfx
COPY --from=base-download-gfx /openttd/opengfx-7.1-all.zip opengfx-7.1-all.zip
RUN unzip opengfx-7.1-all.zip

FROM base-xz as base-xz-gfx
COPY --from=base-zip-gfx /openttd/opengfx-7.1.tar opengfx-7.1.tar
RUN tar -xf opengfx-7.1.tar

FROM base-empty as game
COPY --from=base-xz-game /openttd/openttd openttd
WORKDIR /openttd/openttd/
COPY --from=base-xz-gfx /openttd/opengfx-7.1 baseset/opengfx-7.1

FROM game
CMD [ "./openttd", "-D" ]
