# Quotes
Quotes for daily inspiration

![Screenshot](https://raw.githubusercontent.com/alons45/Quotes/master/data/Screenshot.png)

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.ma1onso.quotes)

## Pay for Quotes

[![Pay for quotes](https://cdn4.iconfinder.com/data/icons/simple-peyment-methods/512/paypal-64.png)](https://paypal.me/alonsoenrique)

## Building and Installation

Please make sure you have these dependencies first before building:

* libgranite-dev
* libgtk-3-dev
* libjson-glib-dev
* libsoup2.4-dev
* meson
* valac

Install with: `sudo apt install libgranite-dev libgtk-3-dev libjson-glib-dev libsoup2.4-dev meson valac`

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `com.github.ma1onso.quotes`

    sudo ninja install
    com.github.ma1onso.quotes
    
