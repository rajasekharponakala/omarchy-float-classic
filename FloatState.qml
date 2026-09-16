import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// Headless window-action helpers (logic lives outside Panel.qml).
QtObject {
  id: root

  function allToplevels() {
    var out = []
    for (var ws of Hyprland.workspaces.values)
      for (var t of ws.toplevels.values)
        out.push(t)
    return out
  }

  function windowCount() {
    return root.allToplevels().length
  }

  function toggleFloatingActive() {
    Quickshell.execDetached(["hyprctl", "dispatch", "togglefloating"])
  }

  function centerActive() {
    Quickshell.execDetached(["hyprctl", "dispatch", "centerwindow"])
  }

  function focusWindow(toplevel) {
    if (toplevel && typeof toplevel.activate === "function")
      toplevel.activate()
  }
}
