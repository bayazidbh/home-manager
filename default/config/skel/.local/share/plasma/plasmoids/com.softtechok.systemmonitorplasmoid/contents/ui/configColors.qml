/*
 * Copyright 2019 Barry Strong <bstrong@softtechok.com>
 *
 * This file is part of System Monitor Plasmoid
 *
 * System Monitor Plasmoid is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * System Monitor Plasmoid is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with System Monitor Plasmoid.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kquickcontrols as KQuickControls

Item {
    id: page
    property alias cfg_cpuSystemColor: cpuSystemColorPicker.color
    property alias cfg_cpuUserColor: cpuUserColorPicker.color
    property alias cfg_cpuIOWaitColor: cpuIOWaitColorPicker.color
    property alias cfg_cpuFreqColor: cpuFreqColorPicker.color
    property alias cfg_cpuTempsColor: cpuTempsColorPicker.color
    property alias cfg_gpuUsageColor: gpuUsageColorPicker.color
    property alias cfg_gpuFreqColor: gpuFreqColorPicker.color
    property alias cfg_gpuMemoryColor: gpuMemoryColorPicker.color
    property alias cfg_gpuTempsColor: gpuTempsColorPicker.color
//    property alias cfg_cpuNiceColor: cpuNiceColorPicker.color
    property alias cfg_memAppsColor: memAppsColorPicker.color
    property alias cfg_memBuffColor: memBuffColorPicker.color
    property alias cfg_memCacheColor: memCacheColorPicker.color
    property alias cfg_swapColor: swapColorPicker.color
    property alias cfg_diskSpaceColor: diskSpaceColorPicker.color
    property alias cfg_diskIOReadColor: diskIOReadColorPicker.color
    property alias cfg_diskIOWriteColor: diskIOWriteColorPicker.color
    property alias cfg_networkDownColor: networkDownColorPicker.color
    property alias cfg_networkUpColor: networkUpColorPicker.color
    property alias cfg_powerCurrentColor: powerCurrentColorPicker.color
    property alias cfg_powerChargeColor: powerChargeColorPicker.color
    property alias cfg_powerDischargeColor: powerDischargeColorPicker.color
    property alias cfg_customColors: customColors.checked

    GridLayout {
        palette.button: "red"
        columns: 6
        CheckBox {
            id: customColors
            Layout.row: 0
            Layout.column: 0
            text: qsTr("Custom Colors")
        }
//CPU
        Text {
            id: cpuColors
            Layout.row: 1
            Layout.column: 1
            font.bold: true
            text: qsTr("CPU")
        }
        Text {
            Layout.row: 1
            Layout.column: 2
            text: qsTr("Defaults")
        }
        Label {
            id: systemColor
            Layout.row: 2
            Layout.column: 0
            text: qsTr("System:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: cpuSystemColorPicker
            Layout.row: 2
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : cpuSystemColorPicker.width - 8
            Layout.preferredHeight : cpuSystemColorPicker.height - 8
            Layout.row: 2
            Layout.column: 2
            color: "red"
        }
        Label {
            id: userColor
            Layout.row: 3
            Layout.column: 0
            text: qsTr("User:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: cpuUserColorPicker
            Layout.row: 3
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : cpuUserColorPicker.width - 8
            Layout.preferredHeight : cpuUserColorPicker.height - 8
            Layout.row: 3
            Layout.column: 2
            color: "blue"
        }
        Label {
            id: ioWaitColor
            Layout.row: 4
            Layout.column: 0
            text: qsTr("IO Wait:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: cpuIOWaitColorPicker
            Layout.row: 4
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : cpuIOWaitColorPicker.width - 8
            Layout.preferredHeight : cpuIOWaitColorPicker.height - 8
            Layout.row: 4
            Layout.column: 2
            color: "green"
        }
        Label {
            id: cpuFreqColor
            Layout.row: 5
            Layout.column: 0
            text: qsTr("Frequency:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: cpuFreqColorPicker
            Layout.row: 5
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : cpuFreqColorPicker.width - 8
            Layout.preferredHeight : cpuFreqColorPicker.height - 8
            Layout.row: 5
            Layout.column: 2
            color: "purple"
        }
        Label {
            id: cpuTempsColor
            Layout.row: 6
            Layout.column: 0
            text: qsTr("Temperature:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: cpuTempsColorPicker
            Layout.row: 6
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : cpuTempsColorPicker.width - 8
            Layout.preferredHeight : cpuTempsColorPicker.height - 8
            Layout.row: 6
            Layout.column: 2
            color: "orange"
        }
// Memory
        Text {
            id: memoryColors
            Layout.row: 1
            Layout.column: 4
            font.bold: true
            text: qsTr("Memory")
        }
        Text {
            Layout.row: 1
            Layout.column: 5
            text: qsTr("Defaults")
        }
        Label {
            id: appsColor
            text: qsTr("Apps:")
            Layout.row: 2
            Layout.column: 3
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: memAppsColorPicker
            Layout.row: 2
            Layout.column: 4
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : memAppsColorPicker.width - 8
            Layout.preferredHeight : memAppsColorPicker.height - 8
            Layout.row: 2
            Layout.column: 5
            color: "blue"
        }
        Label {
            id: buffColor
            text: qsTr("Buffers:")
            Layout.row: 3
            Layout.column: 3
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: memBuffColorPicker
            Layout.row: 3
            Layout.column: 4
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : memBuffColorPicker.width - 8
            Layout.preferredHeight : memBuffColorPicker.height - 8
            Layout.row: 3
            Layout.column: 5
            color: "yellow"
        }
        Label {
            id: cacheColor
            Layout.row: 4
            Layout.column: 3
            text: qsTr("Cache:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: memCacheColorPicker
            Layout.row: 4
            Layout.column: 4
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : memCacheColorPicker.width - 8
            Layout.preferredHeight : memCacheColorPicker.height - 8
            Layout.row: 4
            Layout.column: 5
            color: "cyan"
        }
        Label {
            id: swapColor
            Layout.row: 5
            Layout.column: 3
            text: qsTr("Swap:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: swapColorPicker
            Layout.row: 5
            Layout.column: 4
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : swapColorPicker.width - 8
            Layout.preferredHeight : swapColorPicker.height - 8
            Layout.row: 5
            Layout.column: 5
            color: "green"
        }
        Text {
            id: rowspacer1
            Layout.row: 7
            Layout.column: 1
            font.bold: true
            text: qsTr("")
        }
//GPU        
        Text {
            id: gpuColors
            Layout.row: 8
            Layout.column: 1
            font.bold: true
            text: qsTr("GPU")
        }
        Text {
            Layout.row: 8
            Layout.column: 2
            text: qsTr("Defaults")
        }
        Label {
            id: gpuUsageColor
            text: qsTr("Load:")
            Layout.row: 9
            Layout.column: 0
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: gpuUsageColorPicker
            Layout.row: 9
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : gpuUsageColorPicker.width - 8
            Layout.preferredHeight : gpuUsageColorPicker.height - 8
            Layout.row: 9
            Layout.column: 2
            color: "blue"
        }
        Label {
            id: gpuMemoryColor
            text: qsTr("Memory:")
            Layout.row: 10
            Layout.column: 0
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: gpuMemoryColorPicker
            Layout.row: 10
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : gpuMemoryColorPicker.width - 8
            Layout.preferredHeight : gpuMemoryColorPicker.height - 8
            Layout.row: 10
            Layout.column: 2
            color: "green"
        }
        Label {
            id: gpuFreqColor
            Layout.row: 11
            Layout.column: 0
            text: qsTr("Frequency:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: gpuFreqColorPicker
            Layout.row: 11
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : gpuFreqColorPicker.width - 8
            Layout.preferredHeight : gpuFreqColorPicker.height - 8
            Layout.row: 11
            Layout.column: 2
            color: "purple"
        }
        Label {
            id: gpuTempsColor
            Layout.row: 12
            Layout.column: 0
            text: qsTr("Temperature:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: gpuTempsColorPicker
            Layout.row: 12
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : gpuTempsColorPicker.width - 8
            Layout.preferredHeight : gpuTempsColorPicker.height - 8
            Layout.row: 12
            Layout.column: 2
            color: "orange"
        }
//Disk
        Text {
            id: diskColors
            Layout.row: 8
            Layout.column: 4
            font.bold: true
            text: qsTr("Disk")
        }
        Text {
            Layout.row: 8
            Layout.column: 5
            text: qsTr("Defaults")
        }
        Label {
            id: diskReadColor
            Layout.row: 9
            Layout.column: 3
            text: qsTr("Read:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            Layout.row: 9
            Layout.column: 4
            id: diskIOReadColorPicker
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : diskIOReadColorPicker.width - 8
            Layout.preferredHeight : diskIOReadColorPicker.height - 8
            Layout.row: 9
            Layout.column: 5
            color: "dodgerblue"
        }
        Label {
            id: diskWriteColor
            Layout.row: 10
            Layout.column: 3
            text: qsTr("Write:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: diskIOWriteColorPicker
            Layout.row: 10
            Layout.column: 4
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : diskIOWriteColorPicker.width - 8
            Layout.preferredHeight : diskIOWriteColorPicker.height - 8
            Layout.row: 10
            Layout.column: 5
            color: "lime"
        }
        Label {
            id: diskColor
            Layout.row: 11
            Layout.column: 3
            text: qsTr("Disk Space:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: diskSpaceColorPicker
            Layout.row: 11
            Layout.column: 4
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : diskSpaceColorPicker.width - 8
            Layout.preferredHeight : diskSpaceColorPicker.height - 8
            Layout.row: 11
            Layout.column: 5
            color: "blue"
        }
//        Label {
//            id: niceColor
//            Layout.row: 5
//            Layout.column: 0
//            text: qsTr("Nice:")
//            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
//            enabled: customColors.checked
//        }
//        KQuickControls.ColorButton {
//            id: cpuNiceColorPicker
//            Layout.row: 5
//            Layout.column: 1
//            enabled: customColors.checked
//        }
//Network
        Text {
            id: rowspacer2
            Layout.row: 13
            Layout.column: 0
            font.bold: true
            text: qsTr("")
        }
        Text {
            id: networkColors
            Layout.row: 14
            Layout.column: 1
            font.bold: true
            text: qsTr("Network")
        }
        Text {
            Layout.row: 14
            Layout.column: 2
            text: qsTr("Defaults")
        }
        Label {
            id: netDownloadColor
            Layout.row: 15
            Layout.column: 0
            text: qsTr("Download:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: networkDownColorPicker
            Layout.row: 15
            Layout.column: 1
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : networkDownColorPicker.width - 8
            Layout.preferredHeight : networkDownColorPicker.height - 8
            Layout.row: 15
            Layout.column: 2
            color: "dodgerblue"
        }
        Label {
            id: netUploadColor
            Layout.row: 16
            Layout.column: 0
            text: qsTr("Upload:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            Layout.row: 16
            Layout.column: 1
            id: networkUpColorPicker
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : networkUpColorPicker.width - 8
            Layout.preferredHeight : networkUpColorPicker.height - 8
            Layout.row: 16
            Layout.column: 2
            color: "lime"
        }
//Power
        Text {
            id: powerColors
            Layout.row: 14
            Layout.column: 4
            font.bold: true
            text: qsTr("Power")
        }
        Text {
            Layout.row: 14
            Layout.column: 5
            text: qsTr("Defaults")
        }
        Label {
            id: powerCurrentColor
            Layout.row: 15
            Layout.column: 3
            text: qsTr("Current Charge:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            id: powerCurrentColorPicker
            Layout.row: 15
            Layout.column: 4
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : powerCurrentColorPicker.width - 8
            Layout.preferredHeight : powerCurrentColorPicker.height - 8
            Layout.row: 15
            Layout.column: 5
            color: "blue"
        }
        Label {
            id: powerChargeColor
            Layout.row: 16
            Layout.column: 3
            text: qsTr("Charging:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            Layout.row: 16
            Layout.column: 4
            id: powerChargeColorPicker
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : powerChargeColorPicker.width - 8
            Layout.preferredHeight : powerChargeColorPicker.height - 8
            Layout.row: 16
            Layout.column: 5
            color: "green"
        }
        Label {
            id: powerDischargeColor
            Layout.row: 17
            Layout.column: 3
            text: qsTr("Discharging:")
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            enabled: customColors.checked
        }
        KQuickControls.ColorButton {
            Layout.row: 17
            Layout.column: 4
            id: powerDischargeColorPicker
            enabled: customColors.checked
        }
        Rectangle {
            Layout.preferredWidth : powerDischargeColorPicker.width - 8
            Layout.preferredHeight : powerDischargeColorPicker.height - 8
            Layout.row: 17
            Layout.column: 5
            color: "red"
        }
    }
}
