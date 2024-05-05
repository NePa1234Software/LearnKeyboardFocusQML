import QtQuick
import QtQuick.Controls

FocusScope {
    id: control
    required property string title
    property string label: "-"
    property alias itemFocus: rect.focus
    implicitWidth: 250
    implicitHeight: 200
    // focus: true

    onTitleChanged: console.log("title property set: " + title)
    onFocusChanged: console.log(title + " focus changed: " + focus)
    onActiveFocusChanged: console.log(title + " active focus changed: " + activeFocus)

    Rectangle {
        id: rect
        focus: true
        radius: 4
        anchors.fill: parent
        color: activeFocus ? "green" : focus ? "orange" : "red"
        border.color: "black"
        border.width: 4
        transform: Rotation {
            id: rectRotation
            angle: 0
            axis.z: 1
            origin.x: 80
            origin.y: 80
        }

        Column {
            anchors.centerIn: parent
            Label {
                id: textTitle
                text: control.title
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }
            Label {
                id: textScopeFocus
                text: "scope activeFocus: " + control.activeFocus
                color: "white"
                font.pixelSize: 16
            }
            Label {
                id: textScopeFocusRequest
                text: "scope focus: " + control.focus
                color: "white"
                font.pixelSize: 16
            }
            Label {
                id: textFocus
                text: "item activeFocus: " + rect.activeFocus
                color: "white"
                font.pixelSize: 16
            }
            Label {
                id: textFocusRequest
                text: "item focus: " + rect.focus
                color: "white"
                font.pixelSize: 16
            }
            Label {
                id: textKey
                text: "-"
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }
        }
        Keys.onPressed: (event) => {
                            textKey.text = "Pressed: " + event.text + ", " + event.count + ", " + event.isAutoRepeat // event.isAutoRepeat still doesnt work for WebAssembly!!
                            console.log(control.title, textKey.text)
                        }
        Keys.onReleased: (event) => {
                            textKey.text = "Released: " + event.text + ", " + event.count + ", " + event.isAutoRepeat
                            console.log(control.title, textKey.text)
                        }
        MouseArea { anchors.fill: parent; onClicked: { control.focus = true } }
        Component.onCompleted: console.log(control.title + " component complete")

        // Visualize the TAB navigation capability
        Label {
            anchors.right: parent.right
            anchors.margins: 6
            anchors.top: parent.top
            visible: control.activeFocusOnTab
            text: "TAB NAV"
            color: "white"
            font.pixelSize: 16
            font.bold: true
        }

        // Visualize the TAB navigation capability
        Label {
            anchors.left: parent.left
            anchors.margins: 6
            anchors.top: parent.top
            text: control.label
            color: "white"
            font.pixelSize: 16
            font.bold: true
        }

        states: [
            State {
                name: "active"
                when: rect.activeFocus
                PropertyChanges {
                    rect.border.color: "yellow"
                    control.scale: 1.15
                    control.z: 100
               }
            },
            State {
                name: "nofocus"
                when: !rect.activeFocus && control.activeFocus
                PropertyChanges {
                    rect.border.color: "black"
                    control.scale: 0.85
                    rectRotation.angle: 20
               }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "scale"
                duration: 200
            }
            NumberAnimation {
                easing.amplitude: 1.9
                easing.type: Easing.OutBounce
                properties: "angle"
                duration: 1000
            }
        }
    }
}
