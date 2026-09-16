import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "io.github.rajasekharponakala.float-classic"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null

  function open() { root.controller.show() }
  function close() { root.controller.hide() }
  function toggle() { root.opened ? root.close() : root.open() }
  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
  }
  property var settings: ({})

  FloatState { id: floats }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Math.min(Math.max(contentCol.implicitWidth + Style.space(24), Style.space(320)), Style.space(440)))
    contentHeight: panel.fittedContentHeight(Math.min(header.height + contentCol.implicitHeight + Style.space(32), Style.space(480)))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      Keys.onPressed: function(e) {
        if (e.key === Qt.Key_F) { floats.toggleFloatingActive(); e.accepted = true }
        else if (e.key === Qt.Key_C) { floats.centerActive(); e.accepted = true }
      }

      Column {
        anchors.fill: parent
        spacing: Style.space(8)

        Row {
          id: header
          width: parent.width
          spacing: Style.space(8)

          Text {
            width: parent.width - actionsRow.width - Style.space(8)
            text: " Float Classic"
            color: root.barForeground
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.subtitle
            font.bold: true
            elide: Text.ElideRight
          }

          Row {
            id: actionsRow
            spacing: Style.space(10)

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: "◫"
              color: root.barForeground
              opacity: floatHover.hovered ? 1 : 0.6
              font.pixelSize: Style.font.title
              HoverHandler { id: floatHover }
              MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: floats.toggleFloatingActive() }
              PanelToolTip { visible: floatHover.hovered; text: "Float/tile active (F)"; fontFamily: root.bar ? root.bar.fontFamily : Style.font.family }
            }
            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: "◎"
              color: root.barForeground
              opacity: centerHover.hovered ? 1 : 0.6
              font.pixelSize: Style.font.title
              HoverHandler { id: centerHover }
              MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: floats.centerActive() }
              PanelToolTip { visible: centerHover.hovered; text: "Center active (C)"; fontFamily: root.bar ? root.bar.fontFamily : Style.font.family }
            }
          }
        }

        Column {
          id: contentCol
          width: parent.width
          spacing: Style.space(6)

          Text {
            width: parent.width
            visible: floats.windowCount() === 0
            text: "No windows"
            color: root.barForeground
            opacity: 0.6
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.bodySmall
          }

          Repeater {
            model: Hyprland.workspaces.values.flatMap(w => w.toplevels.values).slice(0, 8)
            delegate: Row {
              required property var modelData
              width: contentCol.width
              spacing: Style.space(10)

              Text {
                width: parent.width - Style.space(110)
                text: (modelData.title || "(untitled)").slice(0, 40)
                textFormat: Text.PlainText
                color: root.barForeground
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.bodySmall
                elide: Text.ElideRight
                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor
                  onClicked: floats.focusWindow(parent.modelData)
                }
                PanelToolTip { visible: parent.containsMouse; text: "Click to focus"; fontFamily: root.bar ? root.bar.fontFamily : Style.font.family }
              }

              Text {
                text: "Focus"
                color: Color.accent
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.bodySmall
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: floats.focusWindow(parent.modelData) }
              }

              Text {
                text: "Float"
                color: root.barForeground
                opacity: 0.8
                font.family: root.bar ? root.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.bodySmall
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: floats.toggleFloatingActive() }
              }
            }
          }

          Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: "SUPER+T floats any window. Runs alongside dino.dock — the dock launches, this manages."
            color: root.barForeground
            opacity: 0.55
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.bodySmall
          }
        }
      }
    }
  }
}
