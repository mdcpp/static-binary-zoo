# static-binary-zoo

A set of Dockerfiles to statically cross-compile various "hacker tools" using `musl-cross-make` (https://github.com/richfelker/musl-cross-make). This is a work in progress and I'll be adding recipes and further documentation over time.

## Usage

Run `make MUSL_TARGET=some_target_tuple` to compile everything. Tested targets so far:

* x86_64-linux-musl
* mips-linux-muslsf

But others are very likely to work. Building everything currently needs about 2GB per target and it helps to have a big Ryzen machine with NVMe storage and plenty of RAM and so on.

## Rationale

There are numerous projects and approaches to building static tool binaries, but this one is mine. Sometimes you just find yourself on a little endian softfloat MIPS box and you really need that nmap.

Some goals of the project:

* Re-use dependencies and earlier build stages where possible.
* Ensure that only necessary modifications are made to packages to get them to build and be useful.
* Up to date versions of things.
* Try and make things builds relatively quickly and efficiently (e.g. auto-detect number of cores, skip unhelpful build stages etc)

And yet to be added:

* Update notification feature (this may involve switching package sources to come from Debian).
* More pinned hashes for dependencies.

## Feedback? Questions?

E-mail michael@hotplate.co.nz. I'd love to receive your improvements. No, I don't really know how to use Docker.
