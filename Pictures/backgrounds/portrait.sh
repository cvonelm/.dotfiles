#!/bin/bash

while true; do
    ls $HOME/Pictures/backgrounds/portrait |sort -R |tail -$N |while read file; do
        swww img "$HOME/Pictures/backgrounds/portrait/$file" --outputs "DP-4"  --transition-type wipe
        sleep 30m
    done
done
