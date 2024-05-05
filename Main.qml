import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
    width: 800
    height: 400
    visible: true
    title: qsTr("Learn FocusScope (Keys: Tab/SHIFT-Tab/Arrows)")

    GridLayout {
        anchors.fill: parent
        anchors.margins: 20
        rows: 2
        columns: 3
        rowSpacing: 10
        columnSpacing: 10

        // These Items:
        // - initialized in top-down order
        // - item properties are initized in bottom-up order (title first, then focus)
        // - container focus in reset on second item, as one child already has focus
        // - completed in down-top order
        // - active focus is set on only item with focus still set
        // thus - item1 being the only item left with focus set wins (which is not how I read the docs)
        // https://doc.qt.io/qt-6.5/qtquick-input-focus.html#acquiring-focus-and-focus-scopes

        // https://doc.qt.io/qt-6/qml-qtquick-keynavigation.html#details
        // KeyNavigation will implicitly set the other direction to return focus to this item

        CustomFocusItem {
            id: item11
            focus: true                  // Somehow contrary to docs, first item (initialized last) with focus set gets activeFocus
            label: "NAV -/R/U/D"
            title: "Item 11"             // title proptery is initialized before focus (reverse order), so that logging works as expected
            //KeyNavigation.left: item13
            KeyNavigation.right: item12
            KeyNavigation.up: item21
            KeyNavigation.down: item21
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        CustomFocusItem {
            id: item12
            focus: true                 // Contrary to docs, item does not get activeFocus, because this item is initialized first
            label: "NAV L/R/-/D"
            title: "Item 12"
            KeyNavigation.left: item11
            KeyNavigation.right: item13
            //KeyNavigation.up: item22
            KeyNavigation.down: item22
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        CustomFocusItem {
            id: item13
            //focus: true
            label: "NAV L/-/-/D"
            title: "Item 13"
            KeyNavigation.left: item12
            //KeyNavigation.right: item11
            //KeyNavigation.up: item23
            KeyNavigation.down: item23
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Row 2
        CustomFocusItem {
            id: item21
            //focus: true                 // Somehow contrary to docs, first item (initialized last) with focus set gets activeFocus
            activeFocusOnTab: true
            label: "NAV -/-/U/D"
            title: "Item 21"              // title proptery is initialized before focus (reverse order), so that logging works as expected
            //KeyNavigation.up: item11    // implicit uses caller id, thus still works
            //KeyNavigation.down: item11  // implicit uses caller id, thus still works
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        CustomFocusItem {
            id: item22
            focus: true                   // Contrary to docs, item does not get activeFocus, because this item is initialized first
            activeFocusOnTab: true
            title: "Item 22"
            label: "NAV -/-/U/-"
            //KeyNavigation.up: item12    // implicit uses caller id, thus still works
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        CustomFocusItem {
            id: item23
            //focus: true
            activeFocusOnTab: true
            label: "NAV -/-/U/-"
            title: "Item 23"
            itemFocus: false
            //KeyNavigation.up: item13    // implicit uses caller id, thus still works
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
