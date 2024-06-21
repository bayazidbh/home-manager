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

Item {
    id: main

    Layout.preferredWidth: plasmoid.formFactor == PlasmaCore.Types.Horizontal ?
        height * (plasmoid.configuration.aspect / 10) : width
    Layout.preferredHeight: plasmoid.formFactor == PlasmaCore.Types.Vertical ?
        width * (plasmoid.configuration.aspect / 10) : height

    Grid {
        id: theGrid
        property int numColumns: plasmoid.configuration.numColumns
        property int numRows: plasmoid.configuration.numRows
        property int itemSpacing: plasmoid.configuration.showBorders ? 1 : 0
        property int itemWidth: Math.trunc((main.width - ((numColumns - 1) * itemSpacing)) /
            numColumns)
        property int itemHeight: Math.trunc((main.height - ((numRows - 1) * itemSpacing)) /
            numRows)

        columns: numColumns
        rows: numRows
        flow: plasmoid.configuration.horizontalFlow ? Grid.LeftToRight : Grid.TopToBottom
        spacing: itemSpacing
        Loader {
            sourceComponent: plasmoid.configuration.showCPU ? cpuPanel : undefined
            visible: plasmoid.configuration.showCPU 
            Component {
                id: cpuPanel
                Cpu {
                    id: cpuItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showCPUFreq ? cpuFreqPanel : undefined
            visible: plasmoid.configuration.showCPUFreq
            Component {
                id: cpuFreqPanel
                CpuFreq {
                    id: cpuFreqItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showCPUTemp ? cpuTempPanel : undefined
            visible: plasmoid.configuration.showCPUTemp 
            Component {
                id: cpuTempPanel
                CpuTemp {
                    id: cpuTempItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showMemory ? memPanel : undefined
            visible: plasmoid.configuration.showMemory
            Component {
                id: memPanel
                Memory {
                    id: memItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showSwap ? swapPanel : undefined
            visible: plasmoid.configuration.showSwap
            Component {
                id: swapPanel
                Swap {
                    id: swapItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showGPUUsage ? gpuUsagePanel : undefined
            visible: plasmoid.configuration.showGPUUsage
            Component {
                id: gpuUsagePanel
                GpuUsage {
                    id: gpuUsageItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showGPUFreq ? gpuFreqPanel : undefined
            visible: plasmoid.configuration.showGPUFreq
            Component {
                id: gpuFreqPanel
                GpuFreq {
                    id: gpuFreqItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showGPUTemp ? gpuTempPanel : undefined
            visible: plasmoid.configuration.showGPUTemp
            Component {
                id: gpuTempPanel
                GpuTemp {
                    id: gpuTempItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showGPUMem ? gpuMemPanel : undefined
            visible: plasmoid.configuration.showGPUMem
            Component {
                id: gpuMemPanel
                GpuMemory {
                    id: gpuMemItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showDiskSpace ? dsPanel : undefined
            visible: plasmoid.configuration.showDiskSpace
            Component {
                id: dsPanel
                DiskSpace {
                    id: dsItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showDiskIO? dioPanel : undefined
            visible: plasmoid.configuration.showDiskIO
            Component {
                id: dioPanel
                DiskIO {
                    id: dioItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showNetworkIO? netPanel : undefined
            visible: plasmoid.configuration.showNetworkIO
            Component {
                id: netPanel
                Network {
                    id: netItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
        Loader {
            sourceComponent: plasmoid.configuration.showPower? powerPanel : undefined
            visible: plasmoid.configuration.showPower
            Component {
                id: powerPanel
                Power {
                    id: powerItem
                    width: theGrid.itemWidth
                    height: theGrid.itemHeight
                    showBorder: plasmoid.configuration.showBorders
                    compactView: true
                }
            }
        }
    }
}
