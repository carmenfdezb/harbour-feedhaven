/*
  Copyright (C) 2016 Luca Donaggio
  Contact: Luca Donaggio <donaggio@gmail.com>
  All rights reserved.

  You may use this file under the terms of MIT license
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog

    property string feedId: ""
    property alias title: titleTextField.text
    property string description: ""
    property string imgUrl: ""
    property string lang: ""
    property int subscribers: 0
    property var categories: []
    property bool addFeed: false

    allowedOrientations: Orientation.Portrait | Orientation.Landscape

    acceptDestination: {
        pageStack.find(function (page) {
            return (page.pageType === "feedsList");
        });
    }
    acceptDestinationAction: PageStackAction.Pop
    canAccept: (feedId && title)

    SilicaFlickable {
        id: feedView

        anchors.fill: parent
        contentHeight: header.height + feedContainer.height

        DialogHeader {
            id: header

            title: dialog.addFeed ? qsTr("Add Feed") : qsTr("Manage Feed")
            acceptText: dialog.addFeed ? qsTr("Subscribe") : qsTr("Update")
        }

        Column {
            id: feedContainer

            anchors.top: header.bottom
            width: parent.width
            spacing: Theme.paddingLarge

            TextField {
                id: titleTextField

                width: parent.width
                textMargin: Theme.horizontalPageMargin
                label: qsTr("Title")
                placeholderText: qsTr("Title")
                text: dialog.title
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Categories")
                onClicked: {
                    var catDialog = pageStack.push(Qt.resolvedUrl("SelectCategoriesDialog.qml"), { "categories": dialog.categories });
                    catDialog.accepted.connect(function() {
                        dialog.categories = catDialog.categories;
                    });
                }
            }

            SectionHeader {
                visible: addFeed
                text: qsTr("Additional Info")
            }

            DetailItem {
                width: parent.width
                visible: addFeed
                label: qsTr("Description")
                value: (dialog.description ? dialog.description : qsTr("No description"))
            }

            DetailItem {
                width: parent.width
                visible: addFeed
                label: qsTr("Language")
                value: (dialog.lang ? dialog.lang : qsTr("Unknown"))
            }

            DetailItem {
                width: parent.width
                visible: addFeed
                label: qsTr("Subscribers")
                value: (dialog.subscribers ? dialog.subscribers : qsTr("None"))
            }
        }

        VerticalScrollDecorator {
            flickable: feedView
        }
    }

    onAccepted: {
        feedly.updateSubscription(feedId, title, categories);
    }
}
