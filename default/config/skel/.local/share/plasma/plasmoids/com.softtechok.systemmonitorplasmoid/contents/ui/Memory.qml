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
import "functions.js" as Functions
import org.kde.kirigami as Kirigami

Rectangle {
    id: rectangle
    property var values: [0,0,0,0] // maxMem, appMem, buffMem, cacheMem
    property var work: []
    property var memValues: []
    property var memUnits: [0]
    property bool showBorder: true
    property bool ready: false
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
        property var command: plasmoid.configuration.memoryCommand

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
        property color appsColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.memAppsColor : "blue"
        property color buffColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.memBuffColor : "yellow"
        property color cacheColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.memCacheColor : "cyan"

        sourceComponent: plasmoid.configuration.memBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            BarGraph {
                x: rectangle.border.width
                y: rectangle.border.width
                width: rectangle.width - (rectangle.border.width * 2)
                height: rectangle.height - (rectangle.border.width * 2)
                segments: 3
                divisor: values[0]
                config: [appsColor, buffColor, cacheColor]
                barValues: ["", values[1], values[2], values[3]]
            }
        }
    }
    Loader {
        property color appColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.memAppsColor : "blue"
        property color buffColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.memBuffColor : "yellow"
        property color cacheColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.memCacheColor : "cyan"

        sourceComponent: plasmoid.configuration.memCircularGraph ? circleGraph : undefined
        Component {
            id: circleGraph
            CircleGraph {
                x: rectangle.border.width
                y: rectangle.border.width
                width: rectangle.width - (rectangle.border.width * 2)
                height: rectangle.height - (rectangle.border.width * 2)
                config: [appColor, buffColor, cacheColor]
                segments: 3
                divisor: values[0]
                segValues: ["", values[1], values[2], values[3]]
            }
        }
    }
    Loader {
        property color appColor : plasmoid.configuration.customColors ?
            plasmoid.configuration.memAppsColor : "blue"
        property color buffColor : plasmoid.configuration.customColors ?
            plasmoid.configuration.memBuffColor : "yellow"
        property color cacheColor : plasmoid.configuration.customColors ?
            plasmoid.configuration.memCacheColor : "cyan"

        sourceComponent: plasmoid.configuration.memPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            PlotterGraph {
                x: rectangle.border.width
                y: rectangle.border.width
                width: rectangle.width - (rectangle.border.width * 2)
                height: rectangle.height - (rectangle.border.width * 2)
                config: [appColor, buffColor, cacheColor]
                divisor: values[0]
                plots: 3
                showLabels: plasmoid.configuration.showLabels && !compactView
                plotValues: ["", values[1], values[2], values[3]]
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
                text: qsTr("System Monitor - Memory")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var free;
                    var divisor = [0, ""];

                    free = values[0] - values[1] - values[2] - values[3];
                    divisor = Functions.getDivisor(values[0], memUnits[0]);
                    ws = qsTr("Total Memory:      ") +
                        Functions.format(values[0], divisor, 8, "B") + "\n";
                    ws = ws + qsTr("Application Memory:") +
                        Functions.format(values[1], divisor, 8, "B") + "\n";
                    ws = ws + qsTr("Buffer Memory:     ") +
                        Functions.format(values[2], divisor, 8, "B") + "\n";
                    ws = ws + qsTr("Cache Memory:      ") +
                        Functions.format(values[3], divisor, 8, "B") + "\n";
                    ws = ws + qsTr("Free Memory:       ") +
                        Functions.format(free, divisor, 8, "B");
                    return ws;
                }
            }
        }
    }
    function addSources() {
        work[0] = 0;
        work[1] = 0;
        work[2] = 0;
        work[3] = 0;
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        values[3] = 0;
        memUnits[0] = dbusData.unitValue("memory/physical/total");
        memUnits[1] = dbusData.unitValue("memory/physical/application");
        memUnits[2] = dbusData.unitValue("memory/physical/buffer");
        memUnits[3] = dbusData.unitValue("memory/physical/cache");
        memValues[0] = {value: 0, count: 0};
        memValues[1] = {value: 0, count: 0};
        memValues[2] = {value: 0, count: 0};
        memValues[3] = {value: 0, count: 0};
        sensorList = [
            "memory/physical/total",
            "memory/physical/application",
            "memory/physical/buffer",
            "memory/physical/cache"];
        dbusData.subscribe(sensorList)
        ready = true;
    }
    Connections {
        target: sysMonitor
        function onStatsUpd(keys, values) {
            var sensorKey;
            
            if (!ready)
                return;
            for ( var idx = 0; idx < keys.length; idx++) {
                sensorKey = keys[idx]
                if (sensorKey.indexOf("memory/physical") == 0) {
                    if (sensorKey == "memory/physical/total") {
                        memValues[0].value += values[idx];
                        memValues[0].count += 1;
                    }
                    if (sensorKey == "memory/physical/application") {
                        memValues[1].value += values[idx];
                        memValues[1].count += 1;
                    }
                    if (sensorKey == "memory/physical/buffer") {
                        memValues[2].value += values[idx];
                        memValues[2].count += 1;
                    }
                    if (sensorKey == "memory/physical/cache") {
                        memValues[3].value += values[idx];
                        memValues[3].count += 1;
                    }
                }
            }
        }
        function  onUpdateUi() {
            var memItem;

            for (var idx = 0; idx < 4; idx ++) {
                memItem = memValues[idx];
                if (memItem.count > 0 ) {
                    work[idx] = Functions.convert(memItem.value / memItem.count, memUnits[idx]);
                    memItem.value = 0;
                    memItem.count = 0;
                }
            }
            values = work.slice();
        }
    }
    Component.onCompleted: {
        addSources();
    }
    Component.onDestruction: {
        dbusData.unsubscribe(sensorList);
    }
}
