FROM alpine:latest

RUN apk add --no-cache --virtual .build-deps automake autoconf cmake make git
RUN apk add --no-cache bash libusb libtool fftw-dev libusb-dev musl-dev linux-headers gcc g++

#RUN git clone https://github.com/steve-m/kalibrate-rtl.git
RUN git clone https://github.com/viraptor/kalibrate-rtl.git
RUN git clone https://github.com/osmocom/rtl-sdr.git

WORKDIR /rtl-sdr
WORKDIR build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release && make && make install
WORKDIR /
RUN rm -rf rtl-sdr

WORKDIR /kalibrate-rtl
RUN ./bootstrap && CXXFLAGS='-W -Wall -O3' && ./configure && make && make install
WORKDIR /
RUN rm -rf kalibrate-rtl

RUN apk del .build-deps

CMD [ "/bin/bash" ]
EXPOSE 22
