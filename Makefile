MUSL_TARGET ?= x86_64-linux-musl

DOCKER_BUILD = docker build --build-arg MUSL_TARGET=$(MUSL_TARGET) -f Dockerfile.$@ -t $@-$(MUSL_TARGET) .
GRABBY_HANDS = docker run --rm --mount type=bind,source=$(shell pwd)/output/$(MUSL_TARGET),target=/grabby $@-$(MUSL_TARGET) install -g $(shell id -g) -o $(shell id -u) 

all: socat-1.7.4.1 nmap-7.90 tcpdump-4.99.1 openssl-1.1.1k

check:
	@echo "These binaries are not built properly:"
	@echo $(shell find output/ -type f -exec file {} \; | grep -E -v "statically linked, stripped$$")

musl-cross-make:
	mkdir -p output/$(MUSL_TARGET)
	$(DOCKER_BUILD)

ncurses-6.2: musl-cross-make
	$(DOCKER_BUILD)

readline-8.1: ncurses-6.2
	$(DOCKER_BUILD)

zlib-1.2.11: musl-cross-make
	$(DOCKER_BUILD)

pcre-8.45: musl-cross-make
	$(DOCKER_BUILD)

libxml2-2.9.12: musl-cross-make
	$(DOCKER_BUILD)

libpcap-1.10.1: musl-cross-make
	$(DOCKER_BUILD)

# libfuse >= 3.x uses meson/ninja as a build system so for the time being I am sticking with 2.x
fuse-2.9.9: musl-cross-make
	$(DOCKER_BUILD)

# Don't use this EOL version of OpenSSL for anything important, it's just provided here in case it's needed to e.g. decrypt an old file
openssl-0.9.8zh: zlib-1.2.11
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/openssl /grabby/$@

openssl-1.1.1k: zlib-1.2.11
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/openssl /grabby/$@

socat-1.7.4.1: readline-8.1 openssl-1.1.1k
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/socat /grabby/$@

nmap-7.90: openssl-1.1.1k libpcap-1.10.1
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/nmap /grabby/$@

tcpdump-4.99.1: libpcap-1.10.1
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/tcpdump /grabby/$@

loggedfs-0.9: pcre-8.45 libxml2-2.9.12 fuse-2.9.9
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/loggedfs /grabby/$@

busybox-1.33.1: musl-cross-make
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/busybox /grabby/$@
