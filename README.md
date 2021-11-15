# static-binary-zoo

A set of Dockerfiles to statically cross-compile various "hacker tools" using [musl-cross-make](https://github.com/richfelker/musl-cross-make). This is a work in progress, and I'll be adding recipes and further documentation over time.

## Usage

Run `make MUSL_TARGET=some_target_tuple` to compile everything. Tested targets so far:

* `aarch64-linux-musl`
* `mips-linux-muslsf`
* `mipsel-linux-muslsf`
* `x86_64-linux-musl`

But others are very likely to work. Building everything currently needs about 2GB of disk per target and it helps to have a big machine with NVMe storage and plenty of RAM. A complete build for a single architecture currently takes about 15 minutes on a Ryzen 4750U, or a bit less on an Apple M1.

You can build individual binaries by specifying the recipe name as an argument to `make`. Dependency resolution will be handled automatically.

To validate that all your binaries came out right, run `make check`. This will list any binaries in the `output` directory which don't seem to have been statically linked.

More tools and documentation will be added over time.

### Supported tools

These are the tools that build cleanly without too many caveats and are generally usable.

* `busybox-1.33.1`
* `curl-7.79.1`
* `dropbear-2020.81` (`dropbear`, `dropbearclient` and `dropbearkey`)
* `loggedfs-0.9`
* `nmap-7.90` (some extra functionality is missing as it requires additional data files)
* `openssl-0.9.8zh` (insecure, not for general use)
* `openssl-1.1.1k`
* `socat-1.7.4.1`
* `tcpdump-4.99.1`

### Experimental tools

These are tools which have significant caveats.

* `git-2.33.0` (`git-...` binary needs to be renamed to just `git` to work, generally this isn't very useful because even when compiled statically it's not very standalone due to all the scripts and helpers required)
* `nsjail-3.0` (currently only builds on 64 bit ARM, 32 and 64 bit x86 due to using Google's static `protoc` compiler binaries)

### Supported libraries

These libraries are built automatically as required by the above tools.

* `musl-cross-make-0.9.9`
* `expat-2.4.1`
* `fuse-2.9.9`
* `gettext-0.21` (not currently required for anything)
* `kafel-20200831` (as part of `nsjail-3.0`)
* `libcurl-7.79.1` (as part of `curl-7.79.1`)
* `libnl-3.2.25`
* `libpcap-1.10.1`
* `libssl-0.9.8zh` (as part of `openssl-0.9.8zh`, don't use this, just here for compatibility)
* `libssl-1.1.1k` (as part of `openssl-1.1.1k`)
* `libxml2-2.9.12`
* `ncurses-6.2`
* `pcre-8.45`
* `protobuf-3.19.1` (C++ support only)
* `readline-8.1`
* `zlib-1.2.11`

## Rationale

There are numerous projects and approaches for building static tool binaries, but this one is mine. Sometimes you just find yourself on a little-endian softfloat MIPS box and you really need a specific tool!

Some goals of the project:

* Re-use dependencies between recipes where possible.
* Ensure that only the necessary modifications are made to packages to get them to build and be useful.
* Up-to-date versions.
* Try and make things builds relatively quickly and efficiently (e.g. auto-detect number of cores, skip unhelpful build stages etc)
* Build tools with useful features enabled (e.g. `socat` has `OpenSSL`)

And yet to be added:

* Update notification feature (this may involve switching package sources to come from Debian).

## Feedback? Questions?

E-mail michael@hotplate.co.nz. I'd love to receive your improvements. No, I don't really know how to use Docker.
