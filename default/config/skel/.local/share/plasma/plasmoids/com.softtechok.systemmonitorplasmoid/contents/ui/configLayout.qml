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
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: page
    property alias cfg_showCPU: showCPU.checked
    property alias cfg_showCores: showCores.checked
    property alias cfg_cpuBarGraph: cpuBarGraph.checked
    property alias cfg_cpuCircularGraph: cpuCircularGraph.checked
    property alias cfg_cpuPlotterGraph: cpuPlotterGraph.checked
    property alias cfg_cpuCommand: cpuCommand.text
    property alias cfg_cpuLabel: cpuLabel.text
    property alias cfg_showCPUTemp: showCPUTemp.checked
    property alias cfg_showTempCores: showTempCores.checked
    property alias cfg_cpuTempBarGraph: cpuTempBarGraph.checked
    property alias cfg_cpuTempCircularGraph: cpuTempCircularGraph.checked
    property alias cfg_cpuTempPlotterGraph: cpuTempPlotterGraph.checked
    property alias cfg_cpuTempCommand: cpuTempCommand.text
    property alias cfg_cpuTempLabel: cpuTempLabel.text
    property alias cfg_showCPUFreq: showCPUFreq.checked
    property alias cfg_showFreqCores: showFreqCores.checked
    property alias cfg_cpuFreqBarGraph: cpuFreqBarGraph.checked
    property alias cfg_cpuFreqCircularGraph: cpuFreqCircularGraph.checked
    property alias cfg_cpuFreqPlotterGraph: cpuFreqPlotterGraph.checked
    property alias cfg_cpuFreqCommand: cpuFreqCommand.text
    property alias cfg_cpuFreqLabel: cpuFreqLabel.text
    property alias cfg_showGPUUsage: showGPUUsage.checked
    property alias cfg_gpuUsageBarGraph: gpuUsageBarGraph.checked
    property alias cfg_gpuUsageCircularGraph: gpuUsageCircularGraph.checked
    property alias cfg_gpuUsagePlotterGraph: gpuUsagePlotterGraph.checked
    property alias cfg_gpuUsageCommand: gpuUsageCommand.text
    property alias cfg_gpuUsageLabel: gpuUsageLabel.text
    property alias cfg_showGPUMem: showGPUMem.checked
    property alias cfg_gpuMemBarGraph: gpuMemBarGraph.checked
    property alias cfg_gpuMemCircularGraph: gpuMemCircularGraph.checked
    property alias cfg_gpuMemPlotterGraph: gpuMemPlotterGraph.checked
    property alias cfg_gpuMemCommand: gpuMemCommand.text
    property alias cfg_gpuMemLabel: gpuMemLabel.text
    property alias cfg_showGPUTemp: showGPUTemp.checked
    property alias cfg_gpuTempBarGraph: gpuTempBarGraph.checked
    property alias cfg_gpuTempCircularGraph: gpuTempCircularGraph.checked
    property alias cfg_gpuTempPlotterGraph: gpuTempPlotterGraph.checked
    property alias cfg_gpuTempCommand: gpuTempCommand.text
    property alias cfg_gpuTempLabel: gpuTempLabel.text
    property alias cfg_showGPUFreq: showGPUFreq.checked
    property alias cfg_gpuFreqBarGraph: gpuFreqBarGraph.checked
    property alias cfg_gpuFreqCircularGraph: gpuFreqCircularGraph.checked
    property alias cfg_gpuFreqPlotterGraph: gpuFreqPlotterGraph.checked
    property alias cfg_gpuFreqCommand: gpuFreqCommand.text
    property alias cfg_gpuFreqLabel: gpuFreqLabel.text
    property alias cfg_showMemory: showMemory.checked
    property alias cfg_memLabel: memLabel.text
    property alias cfg_memBarGraph: memBarGraph.checked
    property alias cfg_memCircularGraph: memCircularGraph.checked
    property alias cfg_memPlotterGraph: memPlotterGraph.checked
    property alias cfg_memoryCommand: memoryCommand.text
    property alias cfg_showSwap: showSwap.checked
    property alias cfg_swapLabel: swapLabel.text
    property alias cfg_swapBarGraph: swapBarGraph.checked
    property alias cfg_swapCircularGraph: swapCircularGraph.checked
    property alias cfg_swapPlotterGraph: swapPlotterGraph.checked
    property alias cfg_swapCommand: swapCommand.text
    property alias cfg_showDiskSpace : showDiskSpace.checked
    property alias cfg_dsBarGraph: dsBarGraph.checked
    property alias cfg_dsCircularGraph: dsCircularGraph.checked
    property alias cfg_dsPlotterGraph: dsPlotterGraph.checked
    property alias cfg_diskSpaceCommand: diskSpaceCommand.text
    property alias cfg_diskSpaceLabel: diskSpaceLabel.text
    property alias cfg_showDiskIO: showDiskIO.checked
    property alias cfg_dioBarGraph: dioBarGraph.checked
    property alias cfg_dioCircularGraph: dioCircularGraph.checked
    property alias cfg_dioPlotterGraph: dioPlotterGraph.checked
    property alias cfg_diskIOCommand: diskIOCommand.text
    property alias cfg_diskIOLabel: diskIOLabel.text
    property alias cfg_showNetworkIO: showNetworkIO.checked
    property alias cfg_netBarGraph: netBarGraph.checked
    property alias cfg_netCircularGraph: netCircularGraph.checked
    property alias cfg_netPlotterGraph: netPlotterGraph.checked
    property alias cfg_networkIOCommand: networkIOCommand.text
    property alias cfg_networkIOLabel: networkIOLabel.text
    property alias cfg_showPower: showPower.checked
    property alias cfg_powerBarGraph: powerBarGraph.checked
    property alias cfg_powerCircularGraph: powerCircularGraph.checked
    property alias cfg_powerPlotterGraph: powerPlotterGraph.checked
    property alias cfg_powerCommand: powerCommand.text
    property alias cfg_powerLabel: powerLabel.text
    property alias cfg_useSmoothing: useSmoothing.checked
    property alias cfg_showBorders: showBorders.checked
    property alias cfg_updateInterval: updateInterval.value
    property alias cfg_showLabels: showLabels.checked
    property alias cfg_multiLabels: multiLabels.checked
    property alias cfg_labelsOnTop: labelsOnTop.checked
    property alias cfg_showPeaks: showPeaks.checked
    property alias cfg_horizontalFlow: horizontalFlow.checked
    property alias cfg_verticalFlow: verticalFlow.checked
    property alias cfg_numRows : numRows.value
    property alias cfg_numColumns: numColumns.value
    property alias cfg_aspect: aspect.value;

    GridLayout {
        id: gridLayout
        columns: 4

        Label {
            Layout.row: 0
            Layout.column: 0
            text: qsTr("Display Item")
            font.bold: true
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignLeft
        }
        Label {
            Layout.row: 0
            Layout.column: 1
            text: qsTr("Type of Display")
            font.bold: true
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignCenter
        }
        Label {
            id: lccmd
            Layout.row: 0
            Layout.column: 2
            text: qsTr("Command to start on Left-Click")
            font.bold: true
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignCenter
        }
        Label {
            id: cuslbl
            Layout.row: 0
            Layout.column: 3
            text: qsTr(" Custom Label")
            font.bold: true
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignCenter
        }
        Column {
            id: coresCol
            Layout.row: 1
            Layout.column: 0
            CheckBox {
                id: showCPU
                width: showCores.width * 1.25
                text: qsTr("CPU Load")
            }
            CheckBox {
                id: showCores
                anchors.right: parent.right
                text: qsTr("Cores Separately")
                enabled: showCPU.checked
            }
        }
        RowLayout {
            Layout.row: 1
            Layout.column: 1
            Layout.alignment: Qt.AlignBottom
            RadioButton {
                id: cpuBarGraph
                text: qsTr("Bar")
                enabled: showCPU.checked
            }
            RadioButton {
                id: cpuCircularGraph
                text: qsTr("Circular")
                enabled: showCPU.checked
            }
            RadioButton {
                id: cpuPlotterGraph
                text: qsTr("Plotter")
                enabled: showCPU.checked
            }
        }
        TextField {
            id: cpuCommand
            Layout.row: 1
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showCPU.checked
        }
        TextField {
            id: cpuLabel
            Layout.row: 1
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Cpu")
            enabled: showCPU.checked
        }
        Column {
            id: cpuFreq
            Layout.row: 2
            Layout.column: 0
            CheckBox {
                id: showCPUFreq
                width: showFreqCores.width * 1.25
                text: qsTr("CPU Frequency")
            }
            CheckBox {
                id: showFreqCores
                anchors.right: parent.right
                text: qsTr("Cores Separately")
                enabled: showCPUFreq.checked
            }
        }
        RowLayout {
            Layout.row: 2
            Layout.column: 1
            Layout.alignment: Qt.AlignBottom
            RadioButton {
                id: cpuFreqBarGraph
                text: qsTr("Bar")
                enabled: showCPUFreq.checked
            }
            RadioButton {
                id: cpuFreqCircularGraph
                text: qsTr("Circular")
                enabled: showCPUFreq.checked
            }
            RadioButton {
                id: cpuFreqPlotterGraph
                text: qsTr("Plotter")
                enabled: showCPUFreq.checked
            }
        }
        TextField {
            id: cpuFreqCommand
            Layout.row: 2
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showCPUFreq.checked
        }
        TextField {
            id: cpuFreqLabel
            Layout.row: 2
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Cpu Hz")
            enabled: showCPUFreq.checked
        }
        Column {
            id: cpuTemp
            Layout.row: 3
            Layout.column: 0
            CheckBox {
                id: showCPUTemp
                width: showTempCores.width * 1.25
                text: qsTr("CPU Temperature")
           }
           CheckBox {
                id: showTempCores
                anchors.right: parent.right
                text: qsTr("Cores Separately")
                enabled: showCPUTemp.checked
            }
        }
        RowLayout {
            Layout.row: 3
            Layout.column: 1
            Layout.alignment: Qt.AlignBottom
            RadioButton {
                id: cpuTempBarGraph
                text: qsTr("Bar")
                enabled: showCPUTemp.checked
            }
            RadioButton {
                id: cpuTempCircularGraph
                text: qsTr("Circular")
                enabled: showCPUTemp.checked
            }
            RadioButton {
                id: cpuTempPlotterGraph
                text: qsTr("Plotter")
                enabled: showCPUTemp.checked
            }
        }
        TextField {
            id: cpuTempCommand
            Layout.row: 3
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showCPUTemp.checked
        }
        TextField {
            id: cpuTempLabel
            Layout.row: 3
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Cpu°")
            enabled: showCPUTemp.checked
        }
        CheckBox {
            id: showMemory
            Layout.row: 4
            Layout.column: 0
            text: qsTr("Memory")
        }
        RowLayout {
            Layout.row: 4
            Layout.column: 1
            RadioButton {
                id: memBarGraph
                text: qsTr("Bar")
                enabled: showMemory.checked
            }
            RadioButton {
                id: memCircularGraph
                text: qsTr("Circular")
                enabled: showMemory.checked
            }
            RadioButton {
                id: memPlotterGraph
                text: qsTr("Plotter")
                enabled: showMemory.checked
            }
        }
        TextField {
            id: memoryCommand
            Layout.row: 4
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showMemory.checked
        }
        TextField {
            id: memLabel
            Layout.row: 4
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Mem")
            enabled: showMemory.checked
        }
        CheckBox {
            id: showSwap
            Layout.row: 5
            Layout.column: 0
            text: qsTr("Swap")
        }
        RowLayout {
            Layout.row: 5
            Layout.column: 1
            RadioButton {
                id: swapBarGraph
                text: qsTr("Bar")
                enabled: showSwap.checked
            }

            RadioButton {
                id: swapCircularGraph
                text: qsTr("Circular")
                enabled: showSwap.checked
            }

            RadioButton {
                id: swapPlotterGraph
                text: qsTr("Plotter")
                enabled: showSwap.checked
            }
        }
        TextField {
            id: swapCommand
            Layout.row: 5
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showSwap.checked
        }
        TextField {
            id: swapLabel
            Layout.row: 5
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Swap")
            enabled: showSwap.checked
        }
        CheckBox {
            id: showGPUUsage
            Layout.row: 6
            Layout.column: 0
            text: qsTr("GPU Load")
        }
        RowLayout {
            Layout.row: 6
            Layout.column: 1
            RadioButton {
                id: gpuUsageBarGraph
                text: qsTr("Bar")
                enabled: showGPUUsage.checked
            }

            RadioButton {
                id: gpuUsageCircularGraph
                text: qsTr("Circular")
                enabled: showGPUUsage.checked
            }

            RadioButton {
                id: gpuUsagePlotterGraph
                text: qsTr("Plotter")
                enabled: showGPUUsage.checked
            }
        }
        TextField {
            id: gpuUsageCommand
            Layout.row: 6
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showGPUUsage.checked
        }
        TextField {
            id: gpuUsageLabel
            Layout.row: 6
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Gpu")
            enabled: showGPUUsage.checked
        }
        CheckBox {
            id: showGPUFreq
            Layout.row: 7
            Layout.column: 0
            text: qsTr("GPU Frequency")
        }
        RowLayout {
            Layout.row: 7
            Layout.column: 1
            RadioButton {
                id: gpuFreqBarGraph
                text: qsTr("Bar")
                enabled: showGPUFreq.checked
            }
            RadioButton {
                id: gpuFreqCircularGraph
                text: qsTr("Circular")
                enabled: showGPUFreq.checked
            }
            RadioButton {
                id: gpuFreqPlotterGraph
                text: qsTr("Plotter")
                enabled: showGPUFreq.checked
            }
        }
        TextField {
            id: gpuFreqCommand
            Layout.row: 7
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showGPUFreq.checked
        }
        TextField {
            id: gpuFreqLabel
            Layout.row: 7
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Gpu Hz")
            enabled: showGPUFreq.checked
        }
        CheckBox {
            id: showGPUTemp
            Layout.row: 8
            Layout.column: 0
            text: qsTr("GPU Temperature")
        }
        RowLayout {
            Layout.row: 8
            Layout.column: 1
            RadioButton {
                id: gpuTempBarGraph
                text: qsTr("Bar")
                enabled: showGPUTemp.checked
            }
            RadioButton {
                id: gpuTempCircularGraph
                text: qsTr("Circular")
                enabled: showGPUTemp.checked
            }
            RadioButton {
                id: gpuTempPlotterGraph
                text: qsTr("Plotter")
                enabled: showGPUTemp.checked
            }
        }
        TextField {
            id: gpuTempCommand
            Layout.row: 8
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showGPUTemp.checked
        }
        TextField {
            id: gpuTempLabel
            Layout.row: 8
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Gpu°")
            enabled: showGPUTemp.checked
        }
        CheckBox {
            id: showGPUMem
            Layout.row: 9
            Layout.column: 0
            text: qsTr("GPU Memory")
        }
        RowLayout {
            Layout.row: 9
            Layout.column: 1
            RadioButton {
                id: gpuMemBarGraph
                text: qsTr("Bar")
                enabled: showGPUMem.checked
            }

            RadioButton {
                id: gpuMemCircularGraph
                text: qsTr("Circular")
                enabled: showGPUMem.checked
            }

            RadioButton {
                id: gpuMemPlotterGraph
                text: qsTr("Plotter")
                enabled: showGPUMem.checked
            }
        }
        TextField {
            id: gpuMemCommand
            Layout.row: 9
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showGPUMem.checked
        }
        TextField {
            id: gpuMemLabel
            Layout.row: 9
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Gpu-M")
            enabled: showGPUMem.checked
        }
        CheckBox {
            id: showDiskSpace
            Layout.row: 10
            Layout.column: 0
            text: qsTr("Disk Space")
        }
        RowLayout {
            Layout.row: 10
            Layout.column: 1
            RadioButton {
                id: dsBarGraph
                text: qsTr("Bar")
                enabled: showDiskSpace.checked
            }
            RadioButton {
                id: dsCircularGraph
                text: qsTr("Circular")
                enabled: showDiskSpace.checked
            }
            RadioButton {
                id: dsPlotterGraph
                text: qsTr("Plotter")
                enabled: showDiskSpace.checked
            }
        }
        TextField {
            id: diskSpaceCommand
            Layout.row: 10
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showDiskSpace.checked
        }
        TextField {
            id: diskSpaceLabel
            Layout.row: 10
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("D-Space")
            enabled: showDiskSpace.checked
        }
        CheckBox {
            id: showDiskIO
            Layout.row: 11
            Layout.column: 0
            text: qsTr("Disk IO")
        }
        RowLayout {
            Layout.row: 11
            Layout.column: 1
            RadioButton {
                id: dioBarGraph
                text: qsTr("Bar")
                enabled: showDiskIO.checked
            }
            RadioButton {
                id: dioCircularGraph
                text: qsTr("Circular")
                enabled: showDiskIO.checked
            }
            RadioButton {
                id: dioPlotterGraph
                text: qsTr("Plotter")
                enabled: showDiskIO.checked
            }
        }
        TextField {
            id: diskIOCommand
            Layout.row: 11
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showDiskIO.checked
        }
        TextField {
            id: diskIOLabel
            Layout.row: 11
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("D-IO")
            enabled: showDiskIO.checked
        }
        CheckBox {
            id: showNetworkIO
            Layout.row: 12
            Layout.column: 0
            text: qsTr("Network IO")
        }
        RowLayout {
            Layout.row: 12
            Layout.column: 1
            RadioButton {
                id: netBarGraph
                text: qsTr("Bar")
                enabled: showNetworkIO.checked
            }
            RadioButton {
                id: netCircularGraph
                text: qsTr("Circular")
                enabled: showNetworkIO.checked
            }
            RadioButton {
                id: netPlotterGraph
                text: qsTr("Plotter")
                enabled: showNetworkIO.checked
            }
        }
        TextField {
            id: networkIOCommand
            Layout.row: 12
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showNetworkIO.checked
        }
        TextField {
            id: networkIOLabel
            Layout.row: 12
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Net")
            enabled: showNetworkIO.checked
        }
        CheckBox {
            id: showPower
            Layout.row: 13
            Layout.column: 0
            text: qsTr("Power")
        }
        RowLayout {
            Layout.row: 13
            Layout.column: 1
            RadioButton {
                id: powerBarGraph
                text: qsTr("Bar")
                enabled: showPower.checked
            }
            RadioButton {
                id: powerCircularGraph
                text: qsTr("Circular")
                enabled: showPower.checked
            }
            RadioButton {
                id: powerPlotterGraph
                text: qsTr("Plotter")
                enabled: showPower.checked
            }
        }
        TextField {
            id: powerCommand
            Layout.row: 13
            Layout.column: 2
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: lccmd.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("command arg1 arg2")
            enabled: showPower.checked
        }
        TextField {
            id: powerLabel
            Layout.row: 13
            Layout.column: 3
            Layout.alignment: Qt.AlignBottom
            Layout.preferredWidth: cuslbl.width
            Component.onCompleted: {
                ensureVisible(0);
            }
            placeholderText: qsTr("Power")
            enabled: showPower.checked
        }
        Label {
            id: options
            Layout.row: 14
            Layout.column: 0
            text: qsTr("Options:")
            font.bold: true
            font.underline: false
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignLeft
        }
        CheckBox {
            id: showLabels
            Layout.row: 15
            Layout.column: 0
            ToolTip.text: qsTr("Show a label for each item")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Show Labels")
        }
        CheckBox {
            id: useSmoothing
            Layout.row: 15
            Layout.column: 1
            ToolTip.text: qsTr("Remove jagged edges from plots")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Use Plotter Smoothing")
        }
        CheckBox {
            id: showBorders
            Layout.row: 15
            Layout.column: 2
            ToolTip.text: qsTr("Show a border around each item")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Show Borders")
            Layout.rowSpan: 1
            Layout.columnSpan: 1
            Layout.alignment: Qt.AlignLeft
        }
        CheckBox {
            id: labelsOnTop
            Layout.row: 16
            Layout.column: 0
            ToolTip.text: qsTr("Show item labels on top")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Labels on Top")
            enabled: showLabels.checked
            Layout.alignment: Qt.AlignLeft
        }
        CheckBox {
            id: showPeaks
            Layout.row: 16
            Layout.column: 1
            ToolTip.text: qsTr("Show peak values for IO items")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Show Peak Values")
            enabled: showLabels.checked
            Layout.alignment: Qt.AlignLeft
        }
        CheckBox {
            id: multiLabels
            Layout.row: 16
            Layout.column: 2
            ToolTip.text: qsTr("Show a Label for Each core, Multi Core Items")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Show Multi Core Labels")
            enabled: showLabels.checked
            Layout.alignment: Qt.AlignLeft
        }
        Label {
            id: addItems
            Layout.row: 17
            Layout.column: 0
            text: qsTr("Order items in grid:")
            font.bold: true
            Layout.alignment: Qt.AlignLeft
        }
        RadioButton {
            id: horizontalFlow
            Layout.row: 18
            Layout.column: 0
            ToolTip.text: qsTr("Fill grid rows top to bottom")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Left to Right")
        }
        RadioButton {
            id: verticalFlow
            Layout.row: 18
            Layout.column: 1
            ToolTip.text: qsTr("Fill grid columns left to right")
            ToolTip.visible: hovered
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            text: qsTr("Top to Bottom")
        }
        RowLayout {
                Layout.row: 19
                Layout.column: 0
            Label {
                id: displayColumns
                text: qsTr("Columns:")
                font.bold: true
            }
            SpinBox {
                id: numColumns
                to: Math.floor(13 / numRows.value)

                from: 1
                ToolTip.text: qsTr("Number of columns in display grid")
                ToolTip.visible: hovered
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
            }
        }
        RowLayout {
            Layout.row: 19
            Layout.column: 1
            Label {
                id: displayRows
                text: qsTr("Rows:")
                font.bold: true
            }
            SpinBox {
                id: numRows
                to: Math.floor(13 / numColumns.value)
                from: 1
                ToolTip.text: qsTr("Number of rows in display grid")
                ToolTip.visible: hovered
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
            }
        }
        RowLayout {
            Layout.row: 19
            Layout.column: 2
            Label {
                id: interval
                text: qsTr("Update every")
                font.bold: true
            }
            SpinBox {
                id: updateInterval
                from: 1
                to: 100
                value: 10
                ToolTip.text: qsTr("Interval between display updates in seconds")
                ToolTip.visible: hovered
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                textFromValue: function(value, locale) {
                    return Number(value / 10).toLocaleString(locale, 'f', 1)
                }
                valueFromText: function(text, locale) {
                    return Number.fromLocaleString(locale, text) * 10
                }
                validator: DoubleValidator {
                    bottom: Math.min(updateInterval.from, updateInterval.to)
                    top:  Math.max(updateInterval.from, updateInterval.to)
                }
            }
            Text {
                text: "s"
            }
        }
        RowLayout {
            Layout.row: 20
            Layout.column: 1
            Label {
                text: qsTr("Height/Width Ratio:")
                font.bold: true
            }
            SpinBox {
                id: aspect
                from: 10
                to: 150
                value: 10
                ToolTip.text: qsTr("In a horizontal panel, width = height * Ratio, " +
                    "In a Vertical Panel, height = width * Ratio.")
                ToolTip.visible: hovered
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                textFromValue: function(value, locale) {
                    return Number(value / 10).toLocaleString(locale, 'f', 1)
                }
                valueFromText: function(text, locale) {
                    return Number.fromLocaleString(locale, text) * 10
                }
                validator: DoubleValidator {
                    bottom: Math.min(updateInterval.from, updateInterval.to)
                    top:  Math.max(updateInterval.from, updateInterval.to)
                }
            }
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:1024}
}
 ##^##*/
