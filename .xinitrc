#!/bin/sh

if [ `xdpyinfo | grep resolution | sed -r 's/^[^0-9]*([0-9]+).*$/\1/'` -ge 192 ] ; then
    export GDK_SCALE=2
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    userresources=$HOME/.Xresources.hidpi
else
    userresources=$HOME/.Xresources
fi


usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
setxkbmap -layout us,de
setxkbmap -option 'grp:sclk_toggle'
i3
