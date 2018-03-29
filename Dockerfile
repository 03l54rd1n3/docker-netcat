FROM alpine:latest AS build
RUN wget -q -O /root/netcat.tar.bz2 https://vorboss.dl.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.bz2 && \
    apk --no-cache add --update gcc g++ make
WORKDIR /root/
RUN tar xvjf /root/netcat.tar.bz2
WORKDIR /root/netcat-0.7.1/
RUN ./configure --enable-static && make && make install

FROM scratch
WORKDIR /bin/
COPY --from=build /usr/local/bin/netcat /bin/netcat
COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
ENTRYPOINT ["/bin/netcat"]