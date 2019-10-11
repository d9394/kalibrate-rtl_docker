#This file is also on building and testing, Not complete.
FROM alpine:latest

RUN apk add --no-cache git bash libusb
#RUN git clone https://github.com/steve-m/kalibrate-rtl.git
RUN git clone https://github.com/viraptor/kalibrate-rtl.git
RUN git clone https://github.com/osmocom/rtl-sdr.git

RUN apk add --no-cache --virtual .build-deps libtool automake autoconf fftw-dev cmake gcc make libusb-dev cmake make gcc musl-dev g++ linux-headers

WORKDIR /rtl-sdr
WORKDIR build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release && make && make install
WORKDIR /
RUN rm -rf rtl-sdr

WORKDIR /kalibrate-rtl
RUN ./bootstrap && CXXFLAGS='-W -Wall -O3' && ./configure && make && make install
WORKDIR /
RUN rm -rf kalibrate-rtl

RUN apk del .build-deps git

CMD [ "/bin/bash" ]
EXPOSE 22
