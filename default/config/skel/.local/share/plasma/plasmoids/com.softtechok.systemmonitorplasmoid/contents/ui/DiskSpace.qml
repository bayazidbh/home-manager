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
    property var numberOfDisk
    property var diskLabels: []
    property var values: [0, 0] // usedSpace, totalSpace
    property var work: []
    property var dsValues: []
    property var dsUnits: []
    property bool showBorder: true
    property bool compactView: false
    property bool ready: false
    property var sensorList: []
    
    color: "transparent"
    radius: 3
    border {
        property color borderColor: Kirigami.Theme.textColor

        color: Qt.hsla(borderColor.hslHue,
            borderColor.hslSaturation,
            borderColor.hslLightness, .5)
        width: showBorder ? 1 : 0
    }
    MouseArea {
        property var args: []
        property var command: plasmoid.configuration.diskSpaceCommand

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
        property color diskColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskSpaceColor : "blue"

        sourceComponent: plasmoid.configuration.dsBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: numberOfDisk
                    Rectangle {
                        property int usedSpace: (index * 2)
                        property int maxSpace: (index * 2) + 1

                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        BarGraph {
                            width: barWidth
                            height: barHeight
                            segments: 1
                            divisor: values[maxSpace]
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [diskColor]
                            barValues: [diskLabels[index], values[usedSpace]]
                        }
                    }
                }
            }
        }
    }
    Loader {
        property color diskColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskSpaceColor : "blue"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.dsCircularGraph ? circleGraph : undefined
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
                    CircleGraph {
                        id: circGraph
                        property int usedSpace: (index * 2)
                        property int maxSpace: (index * 2) + 1

                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [diskColor]
                        divisor: values[maxSpace]
                        segments: 1
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [diskLabels[index], values[usedSpace]]
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
        property color diskColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.diskSpaceColor : "blue"

        sourceComponent: plasmoid.configuration.dsPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: numberOfDisk
                    Rectangle {
                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        PlotterGraph {
                            property int usedSpace: (index * 2)
                            property int maxSpace: (index * 2) + 1

                            width: plotWidth
                            height: Math.floor(plotHeight)
                            config: [diskColor]
                            divisor: values[maxSpace]
                            plots: 1
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [diskLabels[index], values[usedSpace]]
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
                text: qsTr("System Monitor - Disk Usage")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var total;
                    var index;
                    var free;
                    var used;
                    var numDisk;
                    var divisor = [0, ""];

                    ws = "";
                    numDisk = numberOfDisk - 1;
                    for (var idx = 0; idx <= numDisk; idx++) {
                        index = idx * 2;
                        used = values[index];
                        total = values[index + 1];
                        free = total - Number(used) ;
                        divisor = Functions.getDivisor(total, dsUnits[index + 1]);
                        ws += diskLabels[idx] + "\n";
                        ws += qsTr("Total:") + Functions.format(total, divisor, 8, "B") + "\n";
                        ws += qsTr("Used: ") + Functions.format(used, divisor, 8, "B") + "\n";
                        ws += qsTr("Free: ") + Functions.format(free, divisor, 8, "B");
                        if (idx < numDisk)
                            ws += "\n\n";
                    }
                    return ws;
                }
            }
        }
    }
    function addSources() {
        var nameIdx;
        var count;
        var key = "";
        var sensors = [];
        var sensoridx;
        var dsklbl

        count = 0;
        sensorList = [];
        sensors = dbusData.allSensors("disk/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/name")) {
                nameIdx = sensors[idx].indexOf("/name");
                key = sensors[idx].slice(0,nameIdx);
                sensoridx = plasmoid.configuration.dsSources.indexOf(key);
                if (sensoridx >= 0) {
                    dsUnits[sensoridx * 2] = dbusData.unitValue(key + "/used");
                    dsUnits[(sensoridx * 2) + 1] = dbusData.unitValue(key + "/total");
                    sensorList.push(key + "/used");
                    sensorList.push(key + "/total");
                    dsklbl = plasmoid.configuration.dsLabels[sensoridx];
                    if (typeof(dsklbl) !== "undefined") {
                        if (dsklbl != "") {
                            diskLabels[sensoridx] = dsklbl;
                        } else {
                            diskLabels[sensoridx] = dbusData.stringData(key + "/name");
                        }
                    } else {
                        diskLabels[sensoridx] = dbusData.stringData(key + "/name");
                    }
                    work[sensoridx * 2] = 0;
                    work[(sensoridx * 2) + 1] = 0;
                    values[sensoridx * 2] = 0;
                    values[(sensoridx * 2) + 1] = 0;
                    dsValues[sensoridx * 2] = {value:0, count:0};
                    dsValues[(sensoridx * 2) + 1] = {value:0, count:0};
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
        function onDsLabelsChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
        function onDsSourcesChanged() {
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
            for (var idx = 0; idx < keys.length; idx++) {
                sensorKey = keys[idx];
                for (var idy = 0; idy < numberOfDisk; idy++) {
                    configKey = plasmoid.configuration.dsSources[idy];
                    if (sensorKey.indexOf(configKey) == 0) {
                        valueIdx = (idy * 2);
                        switch (sensorKey) {
                            case configKey + "/used":
                                dsValues[valueIdx].value += values[idx];
                                dsValues[valueIdx].count += 1;
                            break;
                            case configKey + "/total":
                                dsValues[valueIdx + 1].value += values[idx];
                                dsValues[valueIdx + 1].count += 1;
                            break;
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var valueIdx;
            var dsItem;
            
            if (plasmoid.configuration.dsSources != "") {
                for (var idx = 0; idx < numberOfDisk; idx++) {
                    valueIdx = (idx * 2);
                    for (var idy = 0; idy < 2; idy++ ) {
                        dsItem = dsValues[valueIdx + idy];
                        if (dsItem.count > 0) {
                            work[valueIdx + idy] =
                                Functions.convert(dsItem.value / dsItem.count,
                                dsUnits[valueIdx + idy]);
                            dsItem.value = 0;
                            dsItem.count = 0;
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
