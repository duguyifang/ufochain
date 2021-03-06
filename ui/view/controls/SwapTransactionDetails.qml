import QtQuick 2.11
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.11
import Ufo.Wallet 1.0
import "."

RowLayout {
    id: "root"

    property var    swapCoinName

    property var    txId
    property var    fee
    property var    feeRate
    property var    comment
    property var    swapCoinLockTxId
    property var    swapCoinLockTxConfirmations
    property var    ufoLockTxKernelId

    property bool   isUFOSide
    property bool   isProofReceived    // KernelProofHeight != null

    // isUFOSide || (!isUFOSide && isProofReceived)
    property var    ufoRedeemTxKernelId
    // isUFOSide && isProofReceived
    property var    swapCoinRedeemTxId
    property var    swapCoinRedeemTxConfirmations
    // isUFOSide && !isProofReceived
    property var    ufoRefundTxKernelId

    // !isUFOSide && !isProofReceived
    property var    swapCoinRefundTxId
    property var    swapCoinRefundTxConfirmations

    // property var onOpenExternal: null
    signal textCopied(string text)

    spacing: 30
    GridLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: 4
        Layout.leftMargin: 30
        Layout.topMargin: 30
        Layout.bottomMargin: 30
        columnSpacing: 44
        rowSpacing: 14
        columns: 2

        SFText {
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "Transaction ID"
            text: qsTrId("swap-details-tx-id") + ":"
        }
        SFLabel {
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            //wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.txId
            onCopyText: textCopied(text)
        }
        
        SFText {
            enabled: commentLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "Comment"
            text: qsTrId("swap-details-tx-comment") + ":"
        }
        SFLabel {
            id: commentLabel
            enabled: text != ""
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            //wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.comment
            onCopyText: textCopied(text)
        }

        SFText {
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "Transaction fee"
            text: qsTrId("swap-details-tx-fee") + ":"
        }
        SFLabel {
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            //wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.fee
            onCopyText: textCopied(text)
        }

        SFText {
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "Transaction fee rate"
            text: qsTrId("swap-details-tx-fee-rate") + ":"
        }
        SFLabel {
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            //wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.feeRate
            onCopyText: textCopied(text)
        }
        
        SFText {
            enabled: swapCoinLockTxIdLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "lock transaction ID"
            text: swapCoinName.toUpperCase() + ' ' + qsTrId("swap-details-lock-tx-id") + ":"
        }
        SFLabel {
            id: swapCoinLockTxIdLabel
            enabled: text != ""
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            //wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.swapCoinLockTxId
            onCopyText: textCopied(text)
        }

        SFText {
            enabled: swapCoinLockTxConfirmationsLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "lock transaction confirmations"
            text: swapCoinName.toUpperCase() + ' ' + qsTrId("swap-details-lock-tx-conf") + ":"
        }
        SFLabel {
            id: swapCoinLockTxConfirmationsLabel
            enabled: (text != "") && !isUFOSide
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            //wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.swapCoinLockTxConfirmations
            onCopyText: textCopied(text)
        }
        
        SFText {
            enabled: ufoLockTxKernelIdLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "UFO lock transaction kernel ID"
            text: qsTrId("swap-details-ufo-lock-kernel-id") + ":"
        }
        SFLabel {
            id: ufoLockTxKernelIdLabel
            enabled: text != ""
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            //wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.ufoLockTxKernelId
            onCopyText: textCopied(text)
        }
        
        SFText {
            enabled: ufoRedeemTxKernelIdLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "UFO redeem transaction kernel ID"
            text: qsTrId("swap-details-ufo-redeem-kernel-id") + ":"
        }
        SFLabel {
            id: ufoRedeemTxKernelIdLabel
            enabled: (text != "") && (isUFOSide || (!isUFOSide && isProofReceived))
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            // wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.ufoRedeemTxKernelId
            onCopyText: textCopied(text)
        }

        SFText {
            enabled: swapCoinRedeemTxIdLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "redeem transaction ID"
            text: swapCoinName.toUpperCase() + ' ' + qsTrId("swap-details-redeem-tx-id") + ":"
        }
        SFLabel {
            id: swapCoinRedeemTxIdLabel
            enabled: (text != "") && isUFOSide && isProofReceived
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            // wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.swapCoinRedeemTxId
            onCopyText: textCopied(text)
        }

        SFText {
            enabled: swapCoinRedeemTxConfirmationsLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "redeem transaction confirmations"
            text: swapCoinName.toUpperCase() + ' ' + qsTrId("swap-details-redeem-tx-conf") + ":"
        }
        SFLabel {
            id: swapCoinRedeemTxConfirmationsLabel
            enabled: (text != "") && isUFOSide && isProofReceived
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            // wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.swapCoinRedeemTxConfirmations
            onCopyText: textCopied(text)
        }
        
        SFText {
            enabled: ufoRefundTxKernelIdLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "UFO refund transaction kernel ID"
            text: qsTrId("swap-details-ufo-refund-kernel-id") + ":"
        }
        SFLabel {
            id: ufoRefundTxKernelIdLabel
            enabled: (text != "") && isUFOSide && !isProofReceived
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            // wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.ufoRefundTxKernelId
            onCopyText: textCopied(text)
        }

        SFText {
            enabled: swapCoinRefundTxIdLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "refund transaction ID"
            text: swapCoinName.toUpperCase() + ' ' + qsTrId("swap-details-refund-tx-id") + ":"
        }
        SFLabel {
            id: swapCoinRefundTxIdLabel
            enabled: (text != "") && !isUFOSide && !isProofReceived
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            // wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.swapCoinRefundTxId
            onCopyText: textCopied(text)
        }

        SFText {
            enabled: swapCoinRefundTxConfirmationsLabel.enabled
            visible: enabled
            Layout.alignment: Qt.AlignTop
            font.pixelSize: 14
            color: Style.content_secondary
            //% "refund transaction confirmations"
            text: swapCoinName.toUpperCase() + ' ' + qsTrId("swap-details-refund-tx-conf") + ":"
        }
        SFLabel {
            id: swapCoinRefundTxConfirmationsLabel
            enabled: (text != "") && !isUFOSide && !isProofReceived
            visible: enabled
            Layout.fillWidth: true
            copyMenuEnabled: true
            font.pixelSize: 14
            color: Style.content_main
            // wrapMode: Text.Wrap
            elide: Text.ElideMiddle
            text: root.swapCoinRefundTxConfirmations
            onCopyText: textCopied(text)
        }
        

        function canOpenInBlockchainExplorer(status) {
            switch(status) {
                case "completed":
                case "received":
                case "sent":
                    return true;
                default:
                    return false;
            }
        }
    }
}
