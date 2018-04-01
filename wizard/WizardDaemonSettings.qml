// Copyright (c) 2014-2018, The Incognito Project
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import incognitoComponents.WalletManager 1.0
import QtQuick 2.2
import QtQuick.Layouts 1.1
import "../components"
import "utils.js" as Utils

ColumnLayout {
    Layout.leftMargin: wizardLeftMargin
    Layout.rightMargin: wizardRightMargin

    id: passwordPage
    opacity: 0
    visible: false
    property alias titleText: titleText.text
    Behavior on opacity {
        NumberAnimation { duration: 100; easing.type: Easing.InQuad }
    }

    onOpacityChanged: visible = opacity !== 0


    function onPageOpened(settingsObject) {
    }
    function onWizardRestarted(){
    }

    function onPageClosed(settingsObject) {
        appWindow.persistentSettings.useRemoteNode = remoteNode.checked
        appWindow.persistentSettings.startLocalNode = localNode.checked
        appWindow.persistentSettings.remoteNodeAddress = remoteNodeEdit.getAddress();
        return true
    }

    RowLayout {
        id: dotsRow
        Layout.alignment: Qt.AlignRight

        ListModel {
            id: dotsModel
            ListElement { dotColor: "#36B05B" }
            ListElement { dotColor: "#36B05B" }
            ListElement { dotColor: "#FFE00A" }
            ListElement { dotColor: "#DBDBDB" }
        }

        Repeater {
            model: dotsModel
            delegate: Rectangle {
                // Password page is last page when creating view only wallet
                // TODO: make this dynamic for all pages in wizard
                visible: (wizard.currentPath != "create_view_only_wallet" || index < 2)
                width: 12; height: 12
                radius: 6
                color: dotColor
            }
        }
    }

    ColumnLayout {
        id: headerColumn

        Text {
            Layout.fillWidth: true
            id: titleText
            font.family: "Arial"
            font.pixelSize: 28 * scaleRatio
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            //renderType: Text.NativeRendering
            color: "#3F3F3F"
            text: "Daemon settings"

        }

        Text {
            Layout.fillWidth: true
            Layout.topMargin: 30 * scaleRatio
            Layout.bottomMargin: 30 * scaleRatio
            font.family: "Arial"
            font.pixelSize: 18 * scaleRatio
            wrapMode: Text.Wrap
            //renderType: Text.NativeRendering
            color: "#4A4646"
            textFormat: Text.RichText
//            horizontalAlignment: Text.AlignHCenter
            text: qsTr("To be able to communicate with the Incognito network your wallet needs to be connected to a Incognito node. For best privacy it's recommended to run your own node. \
                        <br><br> \
                        If you don't have the option to run an own node there's an option to connect to a remote node.")
                    + translationManager.emptyString
        }
    }

    ColumnLayout {

        RowLayout {
            CheckBox {
                id: localNode
                text: qsTr("Start a node automatically in background (recommended)") + translationManager.emptyString
                background: "#FFFFFF"
                fontColor: "#4A4646"
                fontSize: 16 * scaleRatio
                checkedIcon: "../images/checkedVioletIcon.png"
                uncheckedIcon: "../images/uncheckedIcon.png"
                checked: appWindow.persistentSettings.startLocalNode && !isAndroid && !isIOS
                visible: !isAndroid && !isIOS
            }
        }

        ColumnLayout {
            visible: localNode.checked
            id: blockchainFolderRow
            Label {
                Layout.fillWidth: true
                Layout.topMargin: 20 * scaleRatio
                fontSize: 14 * scaleRatio
                text: qsTr("Blockchain location") + translationManager.emptyString
            }
            LineEdit {
                id: blockchainFolder
                Layout.preferredWidth:  200 * scaleRatio
                Layout.fillWidth: true
                text: persistentSettings.blockchainDataDir
                placeholderText: qsTr("(optional)") + translationManager.emptyString

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mouse.accepted = false
                        if(persistentSettings.blockchainDataDir != "")
                            blockchainFileDialog.folder = "file://" + persistentSettings.blockchainDataDir
                        blockchainFileDialog.open()
                        blockchainFolder.focus = true
                    }
                }

            }
        }

        RowLayout {
            CheckBox {
                id: remoteNode
                text: (localNode.checked) ? qsTr("Connect to a remote node until my own node has finished syncing") + translationManager.emptyString
                                          : qsTr("Connect to a remote node") + translationManager.emptyString
                Layout.topMargin: 20 * scaleRatio
                background: "#FFFFFF"
                fontColor: "#4A4646"
                fontSize: 16 * scaleRatio
                checkedIcon: "../images/checkedVioletIcon.png"
                uncheckedIcon: "../images/uncheckedIcon.png"
                checked: appWindow.persistentSettings.useRemoteNode
            }

        }

        RowLayout {
            RemoteNodeEdit {
                Layout.minimumWidth: 300 * scaleRatio
                opacity: remoteNode.checked
                id: remoteNodeEdit
                daemonAddrText: persistentSettings.remoteNodeAddress.split(":")[0].trim()
                daemonPortText: (persistentSettings.remoteNodeAddress.split(":")[1].trim() == "") ? "18081" : persistentSettings.remoteNodeAddress.split(":")[1]
            }
        }
    }


    Component.onCompleted: {
        parent.wizardRestarted.connect(onWizardRestarted)
    }
}
