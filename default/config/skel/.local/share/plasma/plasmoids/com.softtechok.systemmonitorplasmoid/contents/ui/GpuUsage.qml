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

Rectangle {
    id: rectangle
    property var values: [0] // Used
    property var numberOfGpu: 0
    property var gpuLabels: []
    property var work: []
    property var usageValues: []
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
        property var command: plasmoid.configuration.gpuUsageCommand

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
        property real barWidth: (rectangle.width - (rectangle.border.width * 2)) / numberOfGpu
        property int barHeight: rectangle.height - (rectangle.border.width * 2)
        property color gpuColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.gpuUsageColor : "blue"

        sourceComponent: plasmoid.configuration.gpuUsageBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: numberOfGpu
                    Rectangle {
                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        BarGraph {
                            width: barWidth
                            height: barHeight
                            segments: 1
                            divisor: 100
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [gpuColor]
                            barValues: [gpuLabels[index], values[index]]
                        }
                    }
                }
            }
        }
    }

    Loader {
        property color gpuColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.gpuUsageColor : "blue"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.gpuUsageCircularGraph ? circleGraph : undefined
        function reArrange () {
            if (rectangle.width > rectangle.height) {
                yDem = Math.floor(Math.sqrt(numberOfGpu));
                xDem = numberOfGpu / yDem;
            } else {
                xDem = Math.floor(Math.sqrt(numberOfGpu));
                yDem = numberOfGpu / xDem;
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
                    model: numberOfGpu
                    CircleGraph {
                        id: circGraph
                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [gpuColor]
                        divisor: 100
                        segments: 1
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [gpuLabels[index], values[index]]
                        Component.onCompleted: reArrange()
                    }
                }
            }
        }
        onWidthChanged: reArrange();
        onHeightChanged: reArrange();
    }
    Loader {
        id: plotter
        property int plotWidth: (rectangle.width - (rectangle.border.width * 2))
        property real plotHeight: (rectangle.height - (rectangle.border.width * 2)) / numberOfGpu
        property color gpuColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.gpuUsageColor : "blue"

        sourceComponent: plasmoid.configuration.gpuUsagePlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: numberOfGpu
                    Rectangle {
                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        PlotterGraph {
                            width: plotWidth
                            height: Math.floor(plotHeight)
                            config: [gpuColor]
                            divisor: 100
                            plots: 1
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [gpuLabels[index], values[index]]
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
                text: qsTr("System Monitor - Gpu Load")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var load;
                    var index;

                    ws = "";
                    for (var idx = 0; idx < numberOfGpu; idx++) {
                        load = Number(values[idx]).toFixed(2);
                        ws += gpuLabels[idx] + "\n";
                        ws += qsTr("Load: ") + load.padStart(6, ' ') + "%";
                        if (idx < numberOfGpu - 1)
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
        var sensorIdx;
        var gpulbl

        count = 0;
        sensorList = [];
        sensors = dbusData.allSensors("gpu/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/name")) {
                nameIdx = sensors[idx].indexOf("/name");
                key = sensors[idx].slice(0,nameIdx);
                sensorIdx = plasmoid.configuration.gpuUsageSources.indexOf(key);
                if (sensorIdx >= 0) {
                    sensorList.push(key + "/usage");
                    gpulbl = plasmoid.configuration.gpuUsageLabels[sensorIdx];
                    if (typeof(gpulbl) !== "undefined") {
                        if (gpulbl != "") {
                            gpuLabels[sensorIdx] = gpulbl;
                        } else {
                            gpuLabels[sensorIdx] = dbusData.stringData(key + "/name");
                        }
                    } else {
                        gpuLabels[sensorIdx] = dbusData.stringData(key + "/name");
                    }
                    work[sensorIdx] = 0;
                    values[sensorIdx] = 0;
                    usageValues[sensorIdx] = {value:0, count:0};
                    count += 1;
                }
            }
        }
        dbusData.subscribe(sensorList);
        numberOfGpu = count;
        ready = true;
    }
    Connections {
        target: plasmoid.configuration
        function onGpuUsageLabelsChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
        function onGpuUsageSourcesChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
    }
    Connections {
        target: sysMonitor
        property var valueIdx;
        property var gpuItem;
        property var source;
        
        function onStatsUpd(keys, values) {
            var sensorKey;
            var valueIdx;
            var configKey;
            
            if (!ready)
                return;
            for (var idx = 0; idx < keys.length; idx++) {
                sensorKey = keys[idx];
                for (var idy = 0; idy < numberOfGpu; idy++) {
                    configKey = plasmoid.configuration.gpuUsageSources[idy];
                    if (sensorKey.indexOf(configKey) == 0) {
                        if (sensorKey == configKey + "/usage") {
                            usageValues[idy].value += values[idx];
                            usageValues[idy].count += 1;
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var valueIdx;
            var gpuItem;
            
            if (plasmoid.configuration.gpuUsageSources != "") {
                for (var idx = 0; idx < numberOfGpu; idx++) {
                    gpuItem = usageValues[idx];
                    if (gpuItem.count > 0) {
                        work[idx] = gpuItem.value / gpuItem.count;
                        gpuItem.value = 0;
                        gpuItem.count = 0;
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
