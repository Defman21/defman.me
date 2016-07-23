---
title: Better screenshots in elementary OS
description: There are 2 different tools to make screenshots in eOS. We'll merge them into one to cover gtk2, gtk3 and qt apps.
date: 201607231539
id: 201607231539-elementary-os-screenshots
tags: elementary bash sh script shell screenshots
links:
    Gist:
        href: //gist.github.com/Defman21/a0dcd8ad164928b4b7509f48ef5ee087
        fa: github
---

Create this script in your `$HOME` directory:

```sh
#!/bin/sh
FILE="$HOME/tmp.png"

PROGRAM="$(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) WM_CLASS | awk -F: 'BEGIN { FS="="; } {print $2}' | awk 'match($1,/[a-z-]+/) {print substr($1,RSTART,RLENGTH)}')"
GTKVERSION="$(ldd /usr/bin/$PROGRAM | grep gtk | awk '{print $1;}')"

SCRPROGRAM="gnome-screenshot $1 -e none -f $FILE"

if [ "$GTKVERSION" = "libgtk-3.so.0" ] && [ "$1" = "-w" ]
then
    SCRPROGRAM="screenshot-tool -w"
    $SCRPROGRAM && cat "$FILE" | xclip -se c -t image/png && rm "$FILE"
else
    SHADOWSIZE="57x28+0+14"
    if [ "$1" = "-a" ]; then
        SHADOWSIZE="39x6+0+3"
    fi
    $SCRPROGRAM
    convert "${FILE}" \( +clone -background black -shadow $SHADOWSIZE \) +swap -background transparent -layers merge +repage "$FILE"
    cat "$FILE" | xclip -se c -t image/png && rm "$FILE"
fi
```

I'll explain it.

The first line is our temporary file which we will use for:

 * generating a shadow
 * copying it to clipboard

`PROGRAM` variable is used to detect focused application.

`GTKVERSION` variable is used to detect GTK version because we will use
`screenshot-tool` for GTK3 applications and `gnome-screenshot` for GTK2/Qt
applications. If you're confused about why you have to use 2 different
applications, I'll explain it: there's a bug when you're trying to make a
screenshot of a GTK2/Qt app using `screenshot-tool` - you won't see any WM
decorations on it. And there's a bug in `gnome-screenshot`: if you try to
make a screenshot of a GTK3 application, it will grab its shadow effet as well.
There's no problem with shadows, but the problem is that `gnome-screenshot` will
grab everything under the shadow as well (= your desktop, browser ,etc.)

`SCRPROGRAM` variable contains  the program that will be used to create a
screenshot. It could be changed at runtime if we're trying to capture a
GTK3 **window**. If that's the case, the script will run `screenshot-tool`. If
not (we're trying to make a screenshot of a GTK2/Qt window or capture an area
of GTK3/GTK2/Qt window) - the script will run `gnome-screenshot`, add the shadow
effect to it and copy the final result to clipboard.

When you're making a screenshot of a GTK3 application, you'll be prompted for
the name of your screenshot. You have to name it `tmp` and save it under `~/`.

Once you did that, the screenshot will be copied to your clipboard and the
temporary file will be removed.

You should have ImageMagick, `awk` and `xclip` installed. I'm sure they are
already installed except for `xclip`: `# apt install xclip`.

# Usage

`~/screenshot.sh -w` - capture focused window

`~/screenshot.sh -a` - capture an area

`~/screenshot.sh -w -d 5` - capture focused window with 5 sec delay.

You can pass `gnome-screenshot` arguments and `screenshot-tool` arguments
depends on what you're trying to capture.

# Examples

![eos-komodo.png](eos-komodo.png)
![eos-terminal.png](eos-terminal.png)
