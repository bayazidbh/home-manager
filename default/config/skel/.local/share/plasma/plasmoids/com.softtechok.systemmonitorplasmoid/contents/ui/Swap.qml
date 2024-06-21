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
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import "functions.js" as Functions

Rectangle {
    id: rectangle
    property var values: [0, 0] // total swap, swapUsed
    property var work: []
    property var swapValues: []
    property var swapUnits: [0]
    property bool showBorder: true
    property var ready: false
    property bool compactView: false
    property var sensorList: []
    
    radius: 3
    color: "transparent"
    border {
        property color borderColor: Kirigami.Theme.textColor

        color: Qt.hsla(borderColor.hslHue,
            borderColor.hslSaturation,
            borderColor.hslLightness, .5)
        width: showBorder ? 1 : 0
    }

    MouseArea {
        property var args: []
        property var command: plasmoid.configuration.swapCommand

        anchors.fill: parent
        onClicked: {
            if (command != "") {
                args[0] = '-c'
                args[1] = command
                dbusData.execCmd("bash", args);
            }
        }
    }
    Loader {
        property color usedColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.swapColor : "green"

        sourceComponent: plasmoid.configuration.swapBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            BarGraph {
                x: rectangle.border.width
                y: rectangle.border.width
                width: rectangle.width - (rectangle.border.width * 2)
                height: rectangle.height - (rectangle.border.width * 2)
                segments: 1
                divisor: values[0]
                config: [usedColor]
                barValues: ["", values[1]]
            }
        }
    }
    Loader {
        property color usedColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.swapColor : "green"

        sourceComponent: plasmoid.configuration.swapCircularGraph ? circleGraph : undefined
        Component {
            id: circleGraph
            CircleGraph {
                x: rectangle.border.width
                y: rectangle.border.width
                width: rectangle.width - (rectangle.border.width * 2)
                height: rectangle.height - (rectangle.border.width * 2)
                config: [usedColor]
                segments: 1
                divisor: values[0]
                segValues: ["", values[1]]
            }
        }
    }
    Loader {
        property color usedColor : plasmoid.configuration.customColors ?
            plasmoid.configuration.swapColor : "green"

        sourceComponent: plasmoid.configuration.swapPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            PlotterGraph {
                x: rectangle.border.width
                y: rectangle.border.width
                width: rectangle.width - (rectangle.border.width * 2)
                height: rectangle.height - (rectangle.border.width * 2)
                config: [usedColor]
                divisor: values[0]
                plots: 1
                showLabels: plasmoid.configuration.showLabels && !compactView
                plotValues: ["", values[1]]
            }
        }
    }
    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        interactive: true
        mainItem: ColumnLayout {
            PlasmaExtras.Heading {
                Layout.alignment: Qt.AlignHCenter
                level: 3
                text: qsTr("System Monitor - Swap")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var free;
                    var divisor = [0, ""];

                    free = values[0] - values[1];
                    divisor = Functions.getDivisor(values[0], swapUnits[0]);
                    ws =      qsTr("Total Swap:") +
                        Functions.format(values[0], divisor, 8, "B") + "\n";
                    ws = ws + qsTr("Used Swap: ") +
                        Functions.format(values[1], divisor, 8, "B") + "\n";
                    ws = ws + qsTr("Free Swap: ") +
                        Functions.format(free, divisor, 8, "B");
                    return ws;
                }
            }
        }
    }
    function addSources() {
        work[0] = 0;
        work[1] = 0;
        values[0] = 0;
        values[1] = 0;
        swapUnits[0] = dbusData.unitValue("memory/swap/total");
        swapUnits[1] = dbusData.unitValue("memory/swap/used");
        swapValues[0] = {value: 0, count: 0};
        swapValues[1] = {value: 0, count: 0};
        sensorList = [
            "memory/swap/total",
            "memory/swap/used"];
        dbusData.subscribe(sensorList);
        ready = true;
    }
    Connections {
        target: sysMonitor
        function onStatsUpd(keys, values) {
            var sensorKey;
            
            if (!ready)
                return;
            for (var idx = 0; idx < keys.length; idx++) {
                sensorKey = keys[idx];
                if (sensorKey.indexOf("memory/swap") == 0) {
                    if (sensorKey == "memory/swap/total") {
                        swapValues[0].value += values[idx];
                        swapValues[0].count += 1;
                    }
                    if (sensorKey == "memory/swap/used") {
                        swapValues[1].value += values[idx];
                        swapValues[1].count += 1;
                    }
                }
            }
        }
        function  onUpdateUi() {
            var swapItem
            
            for (var idx = 0; idx <= 1; idx++) {
                swapItem = swapValues[idx];
                if (swapItem.count > 0) {
                    work[idx] = Functions.convert(swapItem.value / swapItem.count, swapUnits[idx]);
                    swapItem.value = 0;
                    swapItem.count = 0;
                }
            }
            values = work.slice()
        }
    }
    Component.onCompleted: {
        addSources();
    }
    Component.onDestruction: {
        dbusData.unsubscribe(sensorList);
    }
}
