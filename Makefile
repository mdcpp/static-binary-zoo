MUSL_TARGET ?= x86_64-linux-musl
UNAME_M := $(shell uname -m)

DOCKER_BUILD = docker build --build-arg MUSL_TARGET=$(MUSL_TARGET) -f Dockerfile.$@ -t $@-$(MUSL_TARGET) .
GRABBY_HANDS = docker run --rm --mount type=bind,source=$(shell pwd)/output/$(MUSL_TARGET),target=/grabby $@-$(MUSL_TARGET) install -g $(shell id -g) -o $(shell id -u) 

all: busybox-1.33.1 curl-7.79.1 dropbear-2020.81 loggedfs-0.9 nmap-7.90 openssl-1.1.1k socat-1.7.4.1 tcpdump-4.99.1

check:
	@echo "These binaries are not built properly:"
	@echo "$(shell file output/*/* | grep -E -v "\.tar\.gz|statically linked, stripped$$")"

## Dependencies

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

libnl-3.2.25: musl-cross-make
	$(DOCKER_BUILD)

protobuf-3.19.1: musl-cross-make
	$(DOCKER_BUILD)

expat-2.4.1: musl-cross-make
	$(DOCKER_BUILD)

# Produces both libcurl and the curl binary.
curl-7.79.1: openssl-1.1.1k
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/curl /grabby/$@

libxml2-2.9.12: musl-cross-make
	$(DOCKER_BUILD)

libpcap-1.10.1: musl-cross-make
	$(DOCKER_BUILD)

# Nothing uses this currently, it's an optional dependency for git though.
gettext-0.21: musl-cross-make
	$(DOCKER_BUILD)

# libfuse >= 3.x uses meson/ninja as a build system so for the time being I am sticking with 2.x
fuse-2.9.9: musl-cross-make
	$(DOCKER_BUILD)

# Don't use this EOL version of OpenSSL for anything important, it's just provided here in case it's needed to e.g. decrypt an old file
openssl-0.9.8zh: zlib-1.2.11
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/openssl /grabby/$@

# Produces both libssl and the openssl command line tool.
openssl-1.1.1k: musl-cross-make
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/openssl /grabby/$@

## Tools

dropbear-2020.81: zlib-1.2.11
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/dbclient /grabby/dbclient-2020.81
	$(GRABBY_HANDS) /output/bin/dropbearconvert /grabby/dropbearconvert-2020.81
	$(GRABBY_HANDS) /output/bin/dropbearkey /grabby/dropbearkey-2020.81
	$(GRABBY_HANDS) /output/sbin/dropbear /grabby/$@

socat-1.7.4.1: readline-8.1 openssl-1.1.1k
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/socat /grabby/$@

nmap-7.90: openssl-1.1.1k libpcap-1.10.1 zlib-1.2.11 pcre-8.45
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

# Currently this will only build on 64 bit ARM, 32 or 64 bit x86. This will be sorted out later.
nsjail-3.0: libnl-3.2.25 protobuf-3.19.1
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /build/nsjail-3.0/nsjail /grabby/$@

# By default just build the basic 'git' binary. If you want "everything" then set GIT_FULL as an environment variable. The 'git-versionnumber' binary will need to be renamed to just 'git' to work.
git-2.33.0: expat-2.4.1 openssl-1.1.1k curl-7.79.1 zlib-1.2.11
	$(DOCKER_BUILD)
	$(GRABBY_HANDS) /output/bin/git /grabby/$@
ifdef GIT_FULL
	$(GRABBY_HANDS) /output/full.tar.gz /grabby/$@.tar.gz
endif
