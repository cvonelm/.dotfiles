#!/bin/bash

# Forever cycle through a random order of vacation photos in 30 minute intervals
# portrait orientation photos for the portrait screen

while true; do
    ls $HOME/Pictures/backgrounds/portrait | sort -R | tail -$N | while read file; do
        swww img "$HOME/Pictures/backgrounds/portrait/$file" --outputs "DP-4"  --transition-type wipe
        sleep 30m
    done
done
