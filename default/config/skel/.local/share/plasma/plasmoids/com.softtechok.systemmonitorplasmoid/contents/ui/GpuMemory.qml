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
    property var values: [0, 0] // max, used
    property var numberOfGpu: 0
    property var gpuLabels: []
    property var gpuUnits: []
    property var work: []
    property var memValues: []
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
        property var command: plasmoid.configuration.gpuMemCommand

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
            plasmoid.configuration.gpuMemoryColor : "green"

        sourceComponent: plasmoid.configuration.gpuMemBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: numberOfGpu
                    Rectangle {
                        property int maxMem: index * 2
                        property int usedMem: (index * 2) + 1

                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        BarGraph {
                            width: barWidth
                            height: barHeight
                            segments: 1
                            divisor: values[maxMem]
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [gpuColor]
                            barValues: [gpuLabels[index], values[usedMem]]
                        }
                    }
                }
            }
        }
    }
    Loader {
        property color gpuColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.gpuMemoryColor : "green"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.gpuMemCircularGraph ? circleGraph : undefined
        function reArrange () {
            if (rectangle.width > rectangle.height) {
                yDem = Math.floor(Math.sqrt(numberOfGpu))
                xDem = numberOfGpu / yDem
            } else {
                xDem = Math.floor(Math.sqrt(numberOfGpu))
                yDem = numberOfGpu / xDem
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
                        property int maxMem: index * 2
                        property int usedMem: (index * 2) + 1
                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [gpuColor]
                        divisor: values[maxMem]
                        segments: 1
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [gpuLabels[index], values[usedMem]]
                        Component.onCompleted: reArrange();
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
            plasmoid.configuration.gpuMemoryColor : "green"

        sourceComponent: plasmoid.configuration.gpuMemPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: numberOfGpu
                    Rectangle {
                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        PlotterGraph {
                            property int maxMem: index * 2
                            property int usedMem: (index * 2) + 1

                            width: plotWidth
                            height: Math.floor(plotHeight)
                            config: [gpuColor]
                            divisor: values[maxMem]
                            plots: 1
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [gpuLabels[index], values[usedMem]]
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
                text: qsTr("System Monitor - Gpu Memory")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var used;
                    var free;
                    var total;
                    var index;
                    var divisor = [0, ""];

                    ws = "";
                    for (var idx = 0; idx < numberOfGpu; idx++) {
                        index = idx * 2;
                        total =  Number(values[index]);
                        used =  Number(values[index +  1]);
                        free =  Number(values[index] - values[index + 1]);
                        divisor = Functions.getDivisor(total, gpuUnits[idx]);
                        ws += gpuLabels[idx] + "\n";
                        ws += qsTr("total:") + Functions.format(total, divisor, 8, "B") + "\n";
                        ws += qsTr("used: ") + Functions.format(used, divisor, 8, "B") + "\n";
                        ws += qsTr("free: ") + Functions.format(free, divisor, 8, "B");
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
        var sensoridx;
        var unit;
        var gpulbl

        count = 0;
        sensorList = [];
        sensors = dbusData.allSensors("gpu/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/name")) {
                nameIdx = sensors[idx].indexOf("/name");
                key = sensors[idx].slice(0,nameIdx);
                sensoridx = plasmoid.configuration.gpuMemorySources.indexOf(key);
                if (sensoridx >= 0) {
                    unit = dbusData.unitValue(key + "/usedVram");
                    gpuUnits[sensoridx] = unit;
                    sensorList.push(key + "/usedVram");
                    gpulbl = plasmoid.configuration.gpuMemoryLabels[sensoridx];
                    if (typeof(gpulbl) !== "undefined") {
                        if (gpulbl != "") {
                            gpuLabels[sensoridx] = gpulbl;
                        } else {
                            gpuLabels[sensoridx] = dbusData.stringData(key + "/name");
                        }
                    } else {
                        gpuLabels[sensoridx] = dbusData.stringData(key + "/name");
                    }
                    work[sensoridx * 2] =
                        Functions.convert(dbusData.doubleData(key + "/totalVram"), unit);
                    work[(sensoridx * 2) + 1] = 0;
                    values[sensoridx * 2] = 0
                    values[(sensoridx * 2) + 1] = 0;
                    memValues[(sensoridx * 2) + 1] = {value:0, count:0};
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
        function onGpuMemoryLabelsChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
        function onGpuMemorySourcesChanged() {
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
            var key;
            
            if (!ready)
                return;
            for (var idx = 0; idx < keys.length; idx++) {
                sensorKey = keys[idx];
                for (var idy = 0; idy < numberOfGpu; idy++) {
                    configKey = plasmoid.configuration.gpuMemorySources[idy];
                    if (sensorKey.indexOf(configKey) == 0) {
                        valueIdx = (idy * 2);
                        if (sensorKey == configKey + "/usedVram") {
                            memValues[valueIdx + 1].value += values[idx];
                            memValues[valueIdx + 1].count += 1;
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var valueIdx;
            var gpuItem;
            var source;

            if (plasmoid.configuration.gpuMemorySources != "") {
                for (var idx = 0; idx < numberOfGpu; idx++) {
                    valueIdx = (idx * 2);
                    gpuItem = memValues[valueIdx + 1];
                    if (gpuItem.count > 0) {
                        work[valueIdx + 1] =
                            Functions.convert(gpuItem.value / gpuItem.count,
                            gpuUnits[idx]);
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
