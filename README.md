# Quotes
Quotes for daily inspiration

![alt text](https://raw.githubusercontent.com/alons45/Quotes/master/data/Screenshot.png)

## Building, Testing, and Installation

You'll need the following dependencies:
* cmake
* libgtk-3-dev
* libgranite-dev
* valac
* libsoup2.4-dev
* json-glib-tools

It's recommended to create a clean build environment

    mkdir build
    cd build/

Run `cmake` to configure the build environment and then `make` to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make

To install, use `make install`, then execute with `com.github.alonsoenrique.quotes`

    sudo make install
    com.github.alonsoenrique.quotes

To build .deb file (The deb file should be available in the parent directory of the current directory)

     dpkg-buildpackage -B -tc

`B`: binary-only, only arch-specific files and `tc`: clean source tree when finished
