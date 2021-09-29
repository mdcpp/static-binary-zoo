# static-binary-zoo

A set of Dockerfiles to statically cross-compile various "hacker tools" using [musl-cross-make](https://github.com/richfelker/musl-cross-make). This is a work in progress, and I'll be adding recipes and further documentation over time.

## Usage

Run `make MUSL_TARGET=some_target_tuple` to compile everything. Tested targets so far:

* `aarch64-linux-musl`
* `mips-linux-muslsf`
* `mipsel-linux-muslsf`
* `x86_64-linux-musl`

But others are very likely to work. Building everything currently needs about 2GB of disk per target and it helps to have a big machine with NVMe storage and plenty of RAM. A complete build for a single architecture currently takes about 15 minutes on a Ryzen 4750U.

You can build individual binaries by specifying the recipe name as an argument to `make`. Dependency resolution will be handled automatically. These recipes are included at the moment:

* `busybox-1.33.1`
* `curl-7.79.1`
* `git-2.33.0` (git binary needs to be renamed to `git` to work)
* `loggedfs-0.9`
* `nmap-7.90`
* `openssl-0.9.8zh` (insecure, not for general use)
* `openssl-1.1.1k`
* `socat-1.7.4.1`
* `tcpdump-4.99.1`

More tools and documentation will be added over time.

To validate that all your binaries came out right, run `make check`. This will list any binaries in the `output` directory which don't seem to have been statically linked.

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
