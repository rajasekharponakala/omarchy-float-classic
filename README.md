# Float Classic

An [Omarchy](https://omarchy.org/) Quattro bar plugin that adds classic
floating-window control to a tiling desktop — window count in the bar and a
details panel with focus / float / center actions.

![category](https://img.shields.io/badge/category-Windows-blue)

Complements `dino.dock` (launchers + running icons): the dock launches,
this manages windows. Checked before building — no existing plugin covers
float/tile window management as a `bar-widget`.

## Features

- Bar button (🪟) with live window count tooltip
- Details panel anchored to the button
- Window list (up to 8) with click-to-focus
- Float/tile active window (F), center active window (C)
- Escape to close, Tab to switch panels
- Graceful empty state when no windows exist

## Requirements

- Omarchy Quattro (`omarchy-shell`)
- Hyprland (`hyprctl` on PATH — ships with Omarchy)

## Install

```sh
omarchy plugin add https://github.com/rajasekharponakala/omarchy-float-classic.git --enable
```

Or by hand: copy this folder into `~/.config/omarchy/plugins/`, then:

```sh
omarchy-shell shell rescanPlugins
omarchy plugin enable io.github.rajasekharponakala.float-classic
```

The widget appears in the right section of the bar; move it with:

```sh
omarchy bar move io.github.rajasekharponakala.float-classic --section center
```

## Usage

Click the 🪟 icon in the bar to open the panel. Press Escape to close,
Tab to switch panels. Press F to float/tile, C to center.

Open/close over IPC:

```sh
omarchy-shell shell summon io.github.rajasekharponakala.float-classic '{}'
omarchy-shell shell hide io.github.rajasekharponakala.float-classic
```

## Remove

```sh
omarchy plugin remove io.github.rajasekharponakala.float-classic
```

## Development

Validate locally:

```sh
PLUGIN_DIR="$HOME/.config/omarchy/plugins/io.github.rajasekharponakala.float-classic"
omarchy plugin validate "$PLUGIN_DIR"
qmllint -I "$OMARCHY_PATH/shell" "$PLUGIN_DIR/BarWidget.qml" "$PLUGIN_DIR/Panel.qml" "$PLUGIN_DIR/FloatState.qml"
```

## License

Copyright (c) 2026 Rajasekhar Ponakala

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version. See [LICENSE](LICENSE).
