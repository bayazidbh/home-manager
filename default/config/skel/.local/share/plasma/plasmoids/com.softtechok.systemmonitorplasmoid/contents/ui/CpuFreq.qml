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
    property var numCores: 0
    property var maxFreq: 0
    property var values: [0] // max, frequency
    property var work: []
    property var cpuUnits: []
    property var frequencies: []
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
        property var command: plasmoid.configuration.cpuFreqCommand

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
        property color freqColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuFreqColor : "purple"

        sourceComponent: plasmoid.configuration.cpuFreqBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: plasmoid.configuration.showFreqCores ? numCores : 1
                    Rectangle {
                        property string label: plasmoid.configuration.showFreqCores ?
                            setLabel(index) : ""
                        property int freqIdx: plasmoid.configuration.showFreqCores ?
                            index + 1 : 0
                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        BarGraph {
                            width: plasmoid.configuration.showFreqCores ?
                                barWidth : rectangle.width - (rectangle.border.width * 2)
                            height: barHeight
                            segments: 1
                            divisor: maxFreq
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [freqColor]
                            barValues: [label, values[freqIdx]]
                        }
                    }
                }
            }
        }
    }
    Loader {
        id: cpuLoader
        property color freqColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuFreqColor : "purple"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.cpuFreqCircularGraph ? circleGraph : undefined
        function reArrange() {
            if (plasmoid.configuration.showFreqCores) {
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
                    model: plasmoid.configuration.showFreqCores ? numCores : 1
                    CircleGraph {
                        property string label: plasmoid.configuration.showFreqCores ?
                            setLabel(index) : ""
                        property int freqIdx: plasmoid.configuration.showFreqCores ?
                            index + 1 : 0

                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [freqColor]
                        divisor: maxFreq
                        segments: 1
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [label, values[freqIdx]]
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
        property color freqColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuFreqColor : "purple"

        sourceComponent: plasmoid.configuration.cpuFreqPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: plasmoid.configuration.showFreqCores ? numCores : 1
                    Rectangle {
                        property string label: plasmoid.configuration.showFreqCores ?
                            setLabel(index) : ""
                        property int freqIdx: plasmoid.configuration.showFreqCores ?
                            index + 1 : 0

                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        PlotterGraph {
                            width: plotWidth
                            height: plasmoid.configuration.showFreqCores ?
                                plotHeight :
                                    Math.floor(rectangle.height - (rectangle.border.width * 2))
                            config: [freqColor]
                            divisor: maxFreq
                            plots: 1
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [label, values[freqIdx]]
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
                text: plasmoid.configuration.showFreqCores ?
                    qsTr("System Monitor - Cpu Frequencies") :
                        qsTr("System Monitor - Cpu Frequency")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var coreCount;
                    var freq;
                    var cWidth;
                    var divisor = [0, ""];
                    
                    ws = "";
                    coreCount = numCores;
                    cWidth = coreCount.toString().length + 1;
                    divisor = Functions.getDivisor(maxFreq, 300)
                    if (plasmoid.configuration.showFreqCores) {
                        for (var idx = 0; idx < coreCount; idx++) {
                            freq = values[idx + 1];
                            ws = ws + qsTr("Core" + idx.toString().padStart(cWidth, ' ') +
                                " :") + Functions.format(freq, divisor, 7, "Hz");
                            if (idx < coreCount -1)
                                ws = ws + "\n";
                        }
                        ws = ws + "\n" + qsTr("Max  ") + " ".repeat(cWidth) + ":" +
                            Functions.format(maxFreq, divisor, 7, "Hz");
                    } else {
                        ws = ws + qsTr("Frequency") + " :" +
                            Functions.format(values[0], divisor, 7, "Hz");
                        ws = ws + "\n" + qsTr("Max     ") + " ".repeat(cWidth) + ":" +
                            Functions.format(maxFreq, divisor, 7, "Hz");
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
        var mFreq;
        var unit;
        
        dbusData.unsubscribe(sensorList);
        sensorList = [];
        coreCount = dbusData.doubleData("cpu/all/coreCount");
        maxFreq = 0;
        for (var idx = 0; idx < coreCount; idx++) {
            sensorKey = "cpu/cpu" +idx + "/frequency";
            unit = dbusData.unitValue(sensorKey);
            cpuUnits[idx] = unit;
            sensorList.push(sensorKey);
            mFreq = Functions.convert(dbusData.maxValue(sensorKey), unit);
            if (mFreq > maxFreq)
                maxFreq = mFreq;
            work[idx + 1] = 0;
            values[idx + 1] = 0;
            frequencies[idx + 1] = {value: 0, count: 0};
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
                            if (sensorKey == "cpu/cpu" + idy + "/frequency") {
                                frequencies[idy + 1].value += values[idx];
                                frequencies[idy + 1].count += 1;
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
                cpuItem = frequencies[idy + 1];
                if (cpuItem.count > 0) {
                    work[idy + 1] =
                        Functions.convert(cpuItem.value / cpuItem.count, cpuUnits[idy]);
                    if (work[idy + 1] > work[0])
                        work[0] = work[idy + 1]
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
