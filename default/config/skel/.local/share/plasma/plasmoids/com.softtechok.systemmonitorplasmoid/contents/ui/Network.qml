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
    property var numberOfNets: 0
    property var values: [0, 0] // Download, Upload
    property var netLabels: []
    property var work: []
    property var netValues: []
    property var netUnits: []
    property bool showBorder: true
    property bool compactView: false
    property bool ready: false
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
        property var command: plasmoid.configuration.networkIOCommand

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
        property real barWidth: (rectangle.width - (rectangle.border.width * 2)) / numberOfNets
        property int barHeight: rectangle.height - (rectangle.border.width * 2)
        property color downColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.networkDownColor : "dodgerblue"
        property color upColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.networkUpColor : "lime"

        sourceComponent: plasmoid.configuration.netBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: numberOfNets
                    Rectangle {
                        property int downRate: index * 2
                        property int upRate: (index * 2) + 1

                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        DualBarGraph {
                            width: barWidth
                            height: barHeight
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [downColor, upColor]
                            barValues: [netLabels[index], values[downRate], values[upRate]]
                        }
                    }
                }
            }
        }
    }
    Loader {
        property color downColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.networkDownColor : "dodgerblue"
        property color upColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.networkUpColor : "lime"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.netCircularGraph ? circleGraph : undefined
        function reArrange () {
            if (rectangle.width > rectangle.height) {
                yDem = Math.floor(Math.sqrt(numberOfNets));
                xDem = numberOfNets / yDem;
            } else {
                xDem = Math.floor(Math.sqrt(numberOfNets));
                yDem = numberOfNets / xDem;
            }
        }
        Component {
            id: circleGraph
            Grid {
                columns: xDem
                rows: yDem
                x: rectangle.border.width
                y: rectangle.border.width
                Repeater {
                    model: numberOfNets
                    DualCircleGraph {
                        id: circGraph
                        property int downRate: index * 2
                        property int upRate: (index * 2) + 1

                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [downColor, upColor]
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [netLabels[index], values[downRate], values[upRate]]
                        Component.onCompleted: reArrange()
                    }
                }
            }
        }
        onWidthChanged: reArrange()
        onHeightChanged: reArrange()
    }
    Loader {
        property int plotWidth: (rectangle.width - (rectangle.border.width * 2))
        property real plotHeight: (rectangle.height - (rectangle.border.width * 2)) / numberOfNets
        property color downColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.networkDownColor : "dodgerblue"
        property color upColor: plasmoid.configuration.customColors ?

        plasmoid.configuration.networkUpColor : "lime"
        sourceComponent: plasmoid.configuration.netPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: numberOfNets
                    Rectangle {
                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        DualPlotterGraph {
                            property int downRate: index * 2
                            property int upRate: (index * 2) + 1

                            width: plotWidth
                            height: Math.floor(plotHeight)
                            config: [downColor, upColor]
                            plots: 2
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [netLabels[index], values[downRate], values[upRate]]
                        }
                    }
                }
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
                text: qsTr("System Monitor - Network")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var total;
                    var index;
                    var down;
                    var up;
                    var divisor = [0,""];

                    ws = "";
                    for (var idx = 0; idx < numberOfNets; idx++) {
                        index = idx * 2;
                        down = values[index];
                        up = values[index + 1];
                        if (down > up) {
                            divisor = Functions.getDivisor(down, netUnits[index]);
                        } else {
                            divisor = Functions.getDivisor(up, netUnits[index + 1]);
                        }
                        ws += netLabels[idx] + "\n";
                        ws = ws + qsTr("Down:") + Functions.format(down, divisor, 8, "B") + "\n";
                        ws = ws + qsTr("Up:  ") + Functions.format(up, divisor, 8, "B");
                        if (idx < numberOfNets - 1)
                            ws += "\n\n";
                    }
                    return ws;
                }
            }
        }
    }
    function addSources() {
        var keyidx;
        var count;
        var key = "";
        var sensors = [];
        var sensoridx;
        var dsklbl

        count = 0;
        sensorList = [];
        sensors = dbusData.allSensors("network/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/network")) {
                keyidx = sensors[idx].indexOf("/network");
                key = sensors[idx].slice(0,keyidx);
                sensoridx = plasmoid.configuration.netSources.indexOf(key);
                if (sensoridx >= 0) {
                    netUnits[sensoridx * 2] = dbusData.unitValue(key + "/download");
                    netUnits[(sensoridx * 2) + 1] = dbusData.unitValue(key + "/upload");
                    sensorList.push(key + "/download");
                    sensorList.push(key + "/upload");
                    dsklbl = plasmoid.configuration.netLabels[sensoridx];
                    if (typeof(dsklbl) !== "undefined") {
                        if (dsklbl != "") {
                            netLabels[sensoridx] = dsklbl;
                        } else {
                            netLabels[sensoridx] = dbusData.stringData(key + "/network");
                        }
                    } else {
                        netLabels[sensoridx] = dbusData.stringData(key + "/network");
                    }
                    work[sensoridx * 2] = 0;
                    work[(sensoridx * 2) + 1] = 0;
                    values[sensoridx * 2] = 0;
                    values[(sensoridx * 2) + 1] = 0;
                    netValues[sensoridx * 2] = {value:0, count:0};
                    netValues[(sensoridx * 2) + 1] = {value:0, count:0};
                    count += 1;
                }
            }
        }
        dbusData.subscribe(sensorList);
        numberOfNets = count;
        ready = true;
    }
    Connections {
        target: plasmoid.configuration
        function onNetLabelsChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
        function onNetSourcesChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
    }
    Connections {
        target: sysMonitor
        function onStatsUpd(keys, values) {
            var sensorKey;
            var valueIdx;
            var configKey;
            
            if (!ready) 
                return;
            for (var idx = 0; idx < keys.length; idx++ ) {
                sensorKey = keys[idx];
                for (var idy = 0; idy < numberOfNets; idy++) {
                    configKey = plasmoid.configuration.netSources[idy];
                    if (sensorKey.indexOf(configKey) == 0) {
                        valueIdx = idy * 2;
                        if (sensorKey == configKey + "/download") {
                            netValues[valueIdx].value += values[idx];
                            netValues[valueIdx].count += 1;
                        }
                        if (sensorKey == configKey + "/upload") {
                            netValues[valueIdx + 1].value += values[idx];
                            netValues[valueIdx + 1].count += 1;
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var valueIdx;
            var netItem;
            var source;
            
            if (plasmoid.configuration.netSources != "") {
                for (var idx = 0; idx < numberOfNets; idx++) {
                    valueIdx = idx * 2;
                    for (var idy = 0; idy <= 1; idy++) {
                        netItem = netValues[valueIdx + idy];
                        if (netItem.count > 0) {
                            work[valueIdx + idy] =
                                Functions.convert(netItem.value / netItem.count, netUnits[idx]);
                            netItem.value = 0;
                            netItem.count = 0;
                        }
                    }
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
