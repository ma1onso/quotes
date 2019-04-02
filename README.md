# Quotes
Quotes for daily inspiration

![Screenshot](https://raw.githubusercontent.com/alons45/Quotes/master/data/Screenshot.png)

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