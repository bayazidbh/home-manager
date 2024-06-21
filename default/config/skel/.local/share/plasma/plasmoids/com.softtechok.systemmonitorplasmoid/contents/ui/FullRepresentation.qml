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
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Item {
    id: main

    Grid {
        id: theGrid
        property int numColumns: plasmoid.configuration.numColumns
        property int numRows: plasmoid.configuration.numRows
        property int itemSpacing: plasmoid.configuration.showBorders ? 3 : 0
        property int itemWidth: Math.trunc((main.width - ((numColumns - 1) * itemSpacing)) /
            numColumns)
        property int itemHeight: Math.trunc((main.height - ((numRows - 1) * itemSpacing)) /
            numRows)

        columns: numColumns
        rows: numRows
        flow: plasmoid.configuration.horizontalFlow ? Grid.LeftToRight : Grid.TopToBottom
        spacing: itemSpacing
        Loader {
            property string itmLabel: plasmoid.configuration.cpuLabel != "" ?
                plasmoid.configuration.cpuLabel : qsTr("Cpu")

            sourceComponent: plasmoid.configuration.showCPU ? cpuPanel : undefined
            visible: plasmoid.configuration.showCPU
            Component {
                id: cpuPanel
                Column {
                    Text {
                        id: cpuTextTop
                        anchors.horizontalCenter: cpuItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    Cpu {
                        id: cpuItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - cpuTextBottom.paintedHeight : theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: cpuTextBottom
                        anchors.horizontalCenter: cpuItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.cpuFreqLabel != "" ?
                plasmoid.configuration.cpuFreqLabel : qsTr("Cpu Hz")

            sourceComponent: plasmoid.configuration.showCPUFreq ? cpuFreqPanel : undefined
            visible: plasmoid.configuration.showCPUFreq
            Component {
                id: cpuFreqPanel
                Column {
                    Text {
                        id: cpuFreqTextTop
                        anchors.horizontalCenter: cpuFreqItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    CpuFreq {
                        id: cpuFreqItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - cpuFreqTextBottom.paintedHeight :
                            theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: cpuFreqTextBottom
                        anchors.horizontalCenter: cpuFreqItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.cpuTempLabel != "" ?
                plasmoid.configuration.cpuTempLabel : qsTr("Cpu°")
            sourceComponent: plasmoid.configuration.showCPUTemp ? cpuTempPanel : undefined

            visible: plasmoid.configuration.showCPUTemp
            Component {
                id: cpuTempPanel
                Column {
                    Text {
                        id: cpuTempTextTop
                        anchors.horizontalCenter: cpuTempItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    CpuTemp {
                        id: cpuTempItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - cpuTempTextBottom.paintedHeight :
                            theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: cpuTempTextBottom
                        anchors.horizontalCenter: cpuTempItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.memLabel != "" ?
                plasmoid.configuration.memLabel : qsTr("Mem")

            sourceComponent: plasmoid.configuration.showMemory ? memPanel : undefined
            visible: plasmoid.configuration.showMemory
            Component {
                id: memPanel
                Column {
                    Text {
                        id: memTextTop
                        anchors.horizontalCenter: memItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    Memory {
                        id: memItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - memTextBottom.paintedHeight : theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: memTextBottom
                        anchors.horizontalCenter: memItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.swapLabel != "" ?
                plasmoid.configuration.swapLabel : qsTr("Swap")

            sourceComponent: plasmoid.configuration.showSwap ? swapPanel : undefined
            visible: plasmoid.configuration.showSwap
            Component {
                id: swapPanel
                Column {
                    Text {
                        id: swapTextTop
                        anchors.horizontalCenter: swapItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    Swap {
                        id: swapItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - swapTextBottom.paintedHeight :
                            theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: swapTextBottom
                        anchors.horizontalCenter: swapItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.gpuUsageLabel != "" ?
                plasmoid.configuration.gpuUsageLabel : qsTr("Gpu")

            sourceComponent: plasmoid.configuration.showGPUUsage ? gpuUsagePanel : undefined
            visible: plasmoid.configuration.showGPUUsage
            Component {
                id: gpuUsagePanel
                Column {
                    Text {
                        id: gpuUsageTextTop
                        anchors.horizontalCenter: gpuUsageItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    GpuUsage {
                        id: gpuUsageItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - gpuUsageTextBottom.paintedHeight :
                            theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: gpuUsageTextBottom
                        anchors.horizontalCenter: gpuUsageItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.gpuFreqLabel != "" ?
                plasmoid.configuration.gpuFreqLabel : qsTr("Gpu Hz")

            sourceComponent: plasmoid.configuration.showGPUFreq ? gpuFreqPanel : undefined
            visible: plasmoid.configuration.showGPUFreq
            Component {
                id: gpuFreqPanel
                Column {
                    Text {
                        id: gpuFreqTextTop
                        anchors.horizontalCenter: gpuFreqItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    GpuFreq {
                        id: gpuFreqItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - gpuFreqTextBottom.paintedHeight :
                            theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: gpuFreqTextBottom
                        anchors.horizontalCenter: gpuFreqItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.gpuTempLabel != "" ?
                plasmoid.configuration.gpuTempLabel : qsTr("Gpu°")

            sourceComponent: plasmoid.configuration.showGPUTemp ? gpuTempPanel : undefined
            visible: plasmoid.configuration.showGPUTemp
            Component {
                id: gpuTempPanel
                Column {
                    Text {
                        id: gpuTempTextTop
                        anchors.horizontalCenter: gpuTempItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    GpuTemp {
                        id: gpuTempItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - gpuTempTextBottom.paintedHeight :
                            theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: gpuTempTextBottom
                        anchors.horizontalCenter: gpuTempItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.gpuMemLabel != "" ?
                plasmoid.configuration.gpuMemLabel : qsTr("Gpu-M")

            sourceComponent: plasmoid.configuration.showGPUMem ? gpuMemPanel : undefined
            visible: plasmoid.configuration.showGPUMem
            Component {
                id: gpuMemPanel
                Column {
                    Text {
                        id: gpuMemTextTop
                        anchors.horizontalCenter: gpuMemItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    GpuMemory {
                        id: gpuMemItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - gpuMemTextBottom.paintedHeight :
                            theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: gpuMemTextBottom
                        anchors.horizontalCenter: gpuMemItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.diskSpaceLabel != "" ?
                plasmoid.configuration.diskSpaceLabel : qsTr("D-Space")

            sourceComponent: plasmoid.configuration.showDiskSpace ? dsPanel : undefined
            visible: plasmoid.configuration.showDiskSpace
            Component {
                id: dsPanel
                Column {
                    Text {
                        id: dsTextTop
                        anchors.horizontalCenter: dsItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    DiskSpace {
                        id: dsItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - dsTextBottom.paintedHeight : theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: dsTextBottom
                        anchors.horizontalCenter: dsItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.diskIOLabel != "" ?
                plasmoid.configuration.diskIOLabel : qsTr("D-IO")

            sourceComponent: plasmoid.configuration.showDiskIO? dioPanel : undefined
            visible: plasmoid.configuration.showDiskIO
            Component {
                id: dioPanel
                Column {
                    Text {
                        id: dioTextTop
                        anchors.horizontalCenter: dioItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    DiskIO {
                        id: dioItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - dioTextBottom.paintedHeight : theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: dioTextBottom
                        anchors.horizontalCenter: dioItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.networkIOLabel != "" ?
                plasmoid.configuration.networkIOLabel : qsTr("Net")

            sourceComponent: plasmoid.configuration.showNetworkIO? netPanel : undefined
            visible: plasmoid.configuration.showNetworkIO
            Component {
                id: netPanel
                Column {
                    Text {
                        id: netTextTop
                        anchors.horizontalCenter: netItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    Network {
                        id: netItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - netTextBottom.paintedHeight : theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: netTextBottom
                        anchors.horizontalCenter: netItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
        Loader {
            property string itmLabel: plasmoid.configuration.powerLabel != "" ?
                plasmoid.configuration.powerLabel : qsTr("Power")

            sourceComponent: plasmoid.configuration.showPower? powerPanel : undefined
            visible: plasmoid.configuration.showPower
            Component {
                id: powerPanel
                Column {
                    Text {
                        id: powerTextTop
                        anchors.horizontalCenter: powerItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                    Power {
                        id: powerItem
                        width: theGrid.itemWidth
                        height: plasmoid.configuration.showLabels ?
                            theGrid.itemHeight - powerTextBottom.paintedHeight : theGrid.itemHeight
                        showBorder: plasmoid.configuration.showBorders
                    }
                    Text {
                        id: powerTextBottom
                        anchors.horizontalCenter: powerItem.horizontalCenter
                        color: Kirigami.Theme.textColor
                        text: itmLabel
                        visible: plasmoid.configuration.showLabels &&
                            !plasmoid.configuration.labelsOnTop
                        enabled: visible
                    }
                }
            }
        }
    }
}
