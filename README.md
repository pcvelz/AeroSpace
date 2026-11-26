# Reproducers for AeroSpace bug reports

Small standalone programs that reproduce bugs reported upstream, so a fix can be checked without installing the app where the bug was first seen.

## axmoved-loop/repro.swift

Endless refresh loop (one CPU core pinned) while a window that reports AXMoved on every position write is on a hidden workspace.
Bug report: https://github.com/nikitabobko/AeroSpace/discussions/2407, fix: https://github.com/nikitabobko/AeroSpace/pull/2410

An NSWindow that posts AXMoved on every setFrame, standing in for a wxWidgets app.

1. `swift repro.swift`. A small floating window titled "AXMoved repro" opens on the current workspace.
2. Switch to another workspace, so that the window's workspace is hidden.
3. Count the refresh sessions of the next 10 s:
   ```
   /usr/bin/log stream --signpost --predicate 'process == "AeroSpace"' --timeout 10s --style compact \
       | grep -c 'begin\] runHeavyCompleteRefreshSession'
   ```
   Without the fix: about 125 (one core pinned). With the fix: about 11, the idle rate.
4. For comparison, `swift repro.swift --control` opens a plain NSWindow. It reports no AXMoved for these writes and causes no loop.
