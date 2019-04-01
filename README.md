# Quotes
Quotes for daily inspiration

![alt text](https://raw.githubusercontent.com/alons45/Quotes/master/data/images/Screenshot.png)

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.alonsoenrique.quotes)

## Pay for quotes

[![Pay for quotes](https://cdn4.iconfinder.com/data/icons/simple-peyment-methods/512/paypal-64.png)](https://paypal.me/alonsoenrique)

## Dependencies

Please make sure you have these dependencies first before building:

* meson
* libgtk-3-dev
* libgranite-dev
* valac
* libsoup2.4-dev
* libjson-glib-dev

## Building

You can clone this repository and do the following commands:

```bash
meson build && cd build
meson configure --prefix=/usr
sudo ninja install
```

Then you can simply run Quotes by using:

```bash
com.github.alonsoenrique.quotes
```

To build .deb file (The deb file should be available in the parent directory of the current directory)

     dpkg-buildpackage -B -tc

`B`: binary-only, only arch-specific files and `tc`: clean source tree when finished
