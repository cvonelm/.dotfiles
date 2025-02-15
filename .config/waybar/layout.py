#!/usr/bin/env python3


# On Sway WINDOW_FOCUS or BINDING event, generate
# a string of the form "H [ T [ V ] ]" that shows
# the current layout of the workspace for use in waybar

import i3ipc
import sys
import os


name = os.getenv("WAYBAR_OUTPUT_NAME")

def recurse_layout(x):
    layout = "ERROR"
    
    # if the subtree contains the focused window, print it in
    # caps, otherwise use small letters
    if x.find_focused():
        if x.layout == 'splith':
            layout =  "H"
        elif x.layout == 'splitv':
            layout = "V"
        elif x.layout == 'tabbed':
            layout =  "T"
    else:
        if x.layout == 'splith':
            layout =  "h"
        elif x.layout == 'splitv':
            layout = "v"
        elif x.layout == 'tabbed':
            layout =  "t"

    containers = [ x for x in x.nodes if x.layout != "none"]
    if containers:
        layout += " ["
        for node in containers:
            layout += " " + recurse_layout(node)
        layout += " ]"
    return layout

def on_event(i3, _):
    outputs = i3.get_outputs()
    cur_ws = None
    for output in outputs:
        if output.name == name:
            cur_ws = output.current_workspace
    if not cur_ws:
        return

    root = i3.get_tree()
    for output in root.nodes:
        if output.name == name:
            for ws in output.nodes:
                if ws.name == cur_ws:
                    print('{"text": "' + recurse_layout(ws) + '"}')
            break
    sys.stdout.flush()

i3 = i3ipc.Connection()

on_event(i3, None)

i3.on(i3ipc.Event.BINDING, on_event)
i3.on(i3ipc.Event.WINDOW_FOCUS, on_event)

i3.main()

