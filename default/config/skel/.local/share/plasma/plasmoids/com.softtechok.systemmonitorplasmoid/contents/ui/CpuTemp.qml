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
    property var numCores: 0
    property var maxTemp: 0
    property var values: [0] // max, temperatures
    property var work: []
    property var temperatures: []
    property bool showBorder: true
    property bool compactView: false
    property bool ready: false
    property var sensorList : []
    
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
        property var command: plasmoid.configuration.cpuTempCommand

        anchors.fill: parent
        onClicked: {
            if (command != "") {
                args[0] = '-c'
                args[1] = command
                dbusData.execCmd("bash", args);
            }
        }
    }
    function setLabel(idx) {
        if (plasmoid.configuration.multiLabels) {
            if (numCores > 1) {
                return "C" + idx;
            } else {
                return "";
            }
        } else {
            return "";
        }
    }
    Loader {
        property real barWidth: (rectangle.width - (rectangle.border.width * 2)) / numCores
        property int barHeight: rectangle.height - (rectangle.border.width * 2)
        property color tempsColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuTempsColor : "orange"

        sourceComponent: plasmoid.configuration.cpuTempBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: plasmoid.configuration.showTempCores ? numCores : 1
                    Rectangle {
                        property string label: plasmoid.configuration.showTempCores ?
                            setLabel(index) : ""
                        property int tempIdx: plasmoid.configuration.showTempCores ?
                            index + 1 : 0
                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        BarGraph {
                            width: plasmoid.configuration.showTempCores ?
                                barWidth : rectangle.width - (rectangle.border.width * 2)
                            height: barHeight
                            segments: 1
                            divisor: maxTemp
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [tempsColor]
                            barValues: [label, values[tempIdx]]
                        }
                    }
                }
            }
        }
    }
    Loader {
        id: cpuLoader
        property color tempsColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuTempsColor : "orange"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.cpuTempCircularGraph ? circleGraph : undefined
        function reArrange() {
            if (plasmoid.configuration.showTempCores) {
                if (rectangle.width > rectangle.height) {
                    yDem = Math.floor(Math.sqrt(numCores));
                    xDem = numCores / yDem;
                } else {
                    xDem = Math.floor(Math.sqrt(numCores));
                    yDem = numCores / xDem;
                }
            } else {
                xDem = 1;
                yDem = 1;
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
                    model: plasmoid.configuration.showTempCores ? numCores : 1
                    CircleGraph {
                        property string label: plasmoid.configuration.showTempCores ?
                            setLabel(index) : ""
                        property int tempIdx: plasmoid.configuration.showTempCores ?
                            index + 1 : 0

                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [tempsColor]
                        divisor: maxTemp
                        segments: 1
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [label, values[tempIdx]]
                        Component.onCompleted: reArrange()
                    }
                }
            }
        }
        onWidthChanged: {
            if (cpuLoader.status == cpuLoader.Ready)
                reArrange();
        }
        onHeightChanged: {
            if (cpuLoader.status == cpuLoader.Ready)
                reArrange();
        }
    }
    Loader {
        property int plotWidth: (rectangle.width - (rectangle.border.width * 2))
        property real plotHeight: (rectangle.height - (rectangle.border.width * 2)) / numCores
        property color tempsColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuTempsColor : "orange"

        sourceComponent: plasmoid.configuration.cpuTempPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: plasmoid.configuration.showTempCores ? numCores : 1
                    Rectangle {
                        property string label: plasmoid.configuration.showTempCores ?
                            setLabel(index) : ""
                        property int tempIdx: plasmoid.configuration.showTempCores ?
                            index + 1 : 0

                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        PlotterGraph {
                            width: plotWidth
                            height: plasmoid.configuration.showTempCores ?
                                plotHeight :
                                    Math.floor(rectangle.height - (rectangle.border.width * 2))
                            config: [tempsColor]
                            divisor: maxTemp
                            plots: 1
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [label, values[tempIdx]]
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
                text: plasmoid.configuration.showTempCores ?
                    qsTr("System Monitor - Cpu Temperatures") :
                        qsTr("System Monitor - Cpu Temperature")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var coreCount;
                    var temp;
                    var mWidth;
                    var cWidth;
                    
                    ws = "";
                    coreCount = numCores;
                    mWidth = maxTemp.toFixed(2).length + 1;
                    cWidth = coreCount.toString().length + 1;
                    if (plasmoid.configuration.showTempCores) {
                        for (var idx = 0; idx < coreCount; idx++) {
                            temp = values[idx + 1].toFixed(2);
                            ws = ws + qsTr("Core") + idx.toString().padStart(cWidth, ' ') +
                                " :" + temp.padStart(mWidth,' ') + "°";
                            if (idx < coreCount -1)
                                ws = ws + "\n";
                        }
                        ws = ws + "\n" + qsTr("Max  ") + " ".repeat(cWidth) + ":" +
                            maxTemp.toFixed(2).padStart(mWidth, ' ') + "°";
                    } else {
                        ws = ws + qsTr("Temperature") + " :" +
                            values[0].toFixed(2).padStart(mWidth,' ') + "°";
                        ws = ws + "\n" + qsTr("Max       ") + " ".repeat(cWidth) + ":" +
                            maxTemp.toFixed(2).padStart(mWidth, ' ') + "°";
                    }
                    return ws;
                }
            }
        }
    }
    function addSources() {
        var coreCount = 0;
        var valueIdx = 0;
        var sensorKey;
        var mtemp;
        
        dbusData.unsubscribe(sensorList);
        sensorList = [];
        coreCount = dbusData.doubleData("cpu/all/coreCount");
        maxTemp = 0;
        for (var idx = 0; idx < coreCount; idx++) {
            sensorKey = "cpu/cpu" +idx + "/temperature";
            sensorList.push(sensorKey);
            mtemp = dbusData.maxValue(sensorKey);
            if (mtemp > maxTemp)
                maxTemp = mtemp;
            work[idx + 1] = 0;
            values[idx + 1] = 0;
            temperatures[idx + 1] = {value: 0, count: 0};
        }
        dbusData.subscribe(sensorList);
        numCores = coreCount;
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
                if (sensorKey.indexOf("cpu/cpu") == 0) {
                    for (var idy = 0; idy < numCores; idy++) {
                        if (sensorKey.indexOf("cpu/cpu" + idy) == 0) {
                            if (sensorKey == "cpu/cpu" + idy + "/temperature") {
                                temperatures[idy + 1].value += values[idx];
                                temperatures[idy + 1].count += 1;
                            }
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var cpuItem;

            work[0] = 0;
            for (var idy = 0; idy < numCores; idy++) {
                cpuItem = temperatures[idy + 1];
                if (cpuItem.count > 0) {
                    work[idy + 1] = cpuItem.value / cpuItem.count;
                    if (work[idy + 1] > work[0])
                        work[0] = work[idy + 1];
                    cpuItem.value = 0;
                    cpuItem.count = 0;
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
