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
    property var numberOfDisk: 0
    property var diskLabels: []
    property var values: [0, 0] // Read Write
    property var work: []
    property var duValues: []
    property var duUnits: []
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
        property var command: plasmoid.configuration.diskIOCommand

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
        property real barWidth: (rectangle.width - (rectangle.border.width * 2)) / numberOfDisk
        property int barHeight: rectangle.height - (rectangle.border.width * 2)
        property color readColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskIOReadColor : "dodgerblue"
        property color writeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskIOWriteColor : "lime"

        sourceComponent: plasmoid.configuration.dioBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: numberOfDisk
                    Rectangle {
                        property int readRate: index * 2
                        property int writeRate: (index * 2) + 1

                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        DualBarGraph {
                            width: barWidth
                            height: barHeight
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [readColor, writeColor]
                            barValues: [diskLabels[index], values[readRate], values[writeRate]]
                        }
                    }
                }
            }
        }
    }
    Loader {
        property color readColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskIOReadColor : "dodgerblue"
        property color writeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskIOWriteColor : "lime"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.dioCircularGraph ? circleGraph : undefined
        function reArrange () {
            if (rectangle.width > rectangle.height) {
                yDem = Math.floor(Math.sqrt(numberOfDisk))
                xDem = numberOfDisk / yDem
            } else {
                xDem = Math.floor(Math.sqrt(numberOfDisk))
                yDem = numberOfDisk / xDem
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
                    model: numberOfDisk
                    DualCircleGraph {
                        id: circGraph
                        property int readRate: (index * 2)
                        property int writeRate: (index * 2) + 1

                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [readColor, writeColor]
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [diskLabels[index], values[readRate], values[writeRate]]
                        Component.onCompleted: reArrange()
                    }
                }
            }
        }
        onWidthChanged: reArrange();
        onHeightChanged: reArrange();
    }
    Loader {
        property int plotWidth: (rectangle.width - (rectangle.border.width * 2))
        property real plotHeight: (rectangle.height - (rectangle.border.width * 2)) /
            numberOfDisk
        property color readColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskIOReadColor : "dodgerblue"
        property color writeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskIOWriteColor : "lime"

        sourceComponent: plasmoid.configuration.dioPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: numberOfDisk
                    Rectangle {
                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        DualPlotterGraph {
                            property int readRate: (index * 2)
                            property int writeRate: (index * 2) + 1

                            width: plotWidth
                            height: Math.floor(plotHeight)
                            config: [readColor, writeColor]
                            plots: 2
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [diskLabels[index], values[readRate], values[writeRate]]
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
                text: qsTr("System Monitor - Disk IO")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var total;
                    var index;
                    var read;
                    var write;
                    var numDisk;
                    var divisor = [0, ""];

                    ws = "";
                    numDisk = numberOfDisk - 1;
                    for (var idx = 0; idx <= numDisk; idx++) {
                        index = idx * 2;
                        read = values[index];
                        write = values[index + 1];
                        if (read > write) {
                            divisor = Functions.getDivisor(read, duUnits[index]);
                        } else {
                            divisor = Functions.getDivisor(write, duUnits[index +1]);
                        }
                        ws += diskLabels[idx] + "\n";
                        ws = ws + qsTr("Read: ") + Functions.format(read, divisor, 8, "Bs") + "\n";
                        ws = ws + qsTr("Write:") + Functions.format(write, divisor, 8, "Bs");
                        if (idx < numDisk)
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
        var sensors;
        var sensoridx;
        var dsklbl

        count = 0;
        sensorList = [];
        sensors = dbusData.allSensors("disk/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/name")) {
                keyidx = sensors[idx].indexOf("/name");
                key = sensors[idx].slice(0,keyidx);
                sensoridx = plasmoid.configuration.dioSources.indexOf(key);
                if (sensoridx >= 0) {
                    duUnits[sensoridx * 2] = dbusData.unitValue(key + "/read");
                    duUnits[(sensoridx * 2) + 1] = dbusData.unitValue(key + "/write");
                    sensorList.push(key + "/read");
                    sensorList.push(key + "/write");
                    dsklbl = plasmoid.configuration.dioLabels[sensoridx];
                    if (typeof(dsklbl) !== "undefined") {
                        if (dsklbl != "") {
                            diskLabels[sensoridx] = dsklbl;
                        } else {
                            diskLabels[sensoridx] = dbusData.stringData(key + "/name");
                        }
                    } else {
                        diskLabels[sensoridx] =  dbusData.stringData(key + "/name");
                    }
                    work[sensoridx * 2] = 0;
                    work[(sensoridx * 2) + 1] = 0;
                    values[(sensoridx * 2)] = 0;
                    values[(sensoridx * 2) + 1] = 0;
                    duValues[(sensoridx * 2)] = {value:0, count:0};
                    duValues[(sensoridx * 2) + 1] = {value:0, count:0};
                    count += 1;
                }
            }
        }
        dbusData.subscribe(sensorList);
        numberOfDisk = count;
        ready = true;
    }
    Connections {
        target: plasmoid.configuration
            function onDioLabelsChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
        function onDioSourcesChanged() {
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
                for (var idy = 0; idy < numberOfDisk; idy++) {
                    configKey = plasmoid.configuration.dioSources[idy];
                    if (sensorKey.indexOf(configKey) == 0) {
                        valueIdx = idy * 2;
                        switch (sensorKey) {
                            case configKey + "/read":
                                duValues[valueIdx].value += values[idx];
                                duValues[valueIdx].count += 1;
                            break;
                            case configKey + "/write":
                                duValues[valueIdx + 1].value += values[idx];
                                duValues[valueIdx + 1].count += 1;
                            break;
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var valueIdx;
            var duItem;
            
            if (plasmoid.configuration.dioSources != "") {
                for (var idx = 0; idx < numberOfDisk; idx++) {
                    valueIdx = (idx * 2);
                    for (var idy = 0; idy <= 1; idy++) {
                        duItem = duValues[valueIdx + idy];
                        if (duItem.count > 0) {
                            work[valueIdx + idy] =
                                Functions.convert(duItem.value / duItem.count, duUnits[idx]);
                            duItem.value = 0;
                            duItem.count = 0;
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
