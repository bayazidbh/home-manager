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
    property var values: [0,0,0] // system, user, io wait
    property var numCores : 0
    property var work: []
    property var cpuValues: []
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
        property var command: plasmoid.configuration.cpuCommand

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
        property color sysColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuSystemColor : "red"
        property color userColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuUserColor : "blue"
        property color waitColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuIOWaitColor : "green"
//        property color niceColor: plasmoid.configuration.customColors ? plasmoid.configuration.cpuNiceColor : "yellow"

        sourceComponent: plasmoid.configuration.cpuBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: numCores
                    Rectangle {
                        property int coreNum: numCores == 1 ? 0 : (index + 1) * 3
                        property int sysIdx: coreNum
                        property int userIdx: coreNum + 1
                        property int waitIdx: coreNum + 2

                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        BarGraph {
                            width: barWidth
                            height: barHeight
                            segments: 3
                            divisor: 100
                            showLabels: plasmoid.configuration.showLabels &&
                                plasmoid.configuration.showCores && !compactView
                            config: [sysColor, userColor, waitColor]
                            barValues: [setLabel(index), values[sysIdx], values[userIdx],
                                values[waitIdx]]
                        }
                    }
                }
            }
        }
    }
    Loader {
        id: cpuLoader
        property color sysColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuSystemColor : "red"
        property color userColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuUserColor : "blue"
        property color waitColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuIOWaitColor : "green"
//        property color niceColor: plasmoid.configuration.customColors ? plasmoid.configuration.cpuNiceColor : "yellow"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.cpuCircularGraph ? circleGraph : undefined
        function reArrange() {
            if (rectangle.width > rectangle.height) {
                yDem = Math.floor(Math.sqrt(numCores));
                xDem = numCores / yDem;
            } else {
                xDem = Math.floor(Math.sqrt(numCores));
                yDem = numCores / xDem;
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
                    model: numCores
                    CircleGraph {
                        property int coreNum: numCores == 1 ? 0 : (index + 1) * 3
                        property int sysIdx: coreNum
                        property int userIdx: coreNum + 1
                        property int waitIdx: coreNum + 2

                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [sysColor, userColor, waitColor]
                        divisor: 100
                        segments: 3
                        showLabels: plasmoid.configuration.showLabels && plasmoid.configuration.showCores && !compactView
                        segValues: [setLabel(index), values[sysIdx], values[userIdx], values[waitIdx]]
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
        property real plotHeight: (rectangle.height - (rectangle.border.width * 2)) / numCores
        property color sysColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuSystemColor : "red"
        property color userColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuUserColor : "blue"
        property color waitColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.cpuIOWaitColor : "green"
//        property color niceColor: plasmoid.configuration.customColors ? plasmoid.configuration.cpuNiceColor : "yellow"

        sourceComponent: plasmoid.configuration.cpuPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: numCores
                    Rectangle {
                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        PlotterGraph {
                            property int coreNum: numCores == 1 ? 0 : (index + 1) * 3
                            property int sysIdx: coreNum
                            property int userIdx: coreNum + 1
                            property int waitIdx: coreNum + 2

                            width: plotWidth
                            height: Math.floor(plotHeight)
                            config: [sysColor, userColor, waitColor]
                            divisor: 100
                            plots: 3
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [setLabel(index), values[sysIdx], values[userIdx], values[waitIdx]]
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
                text: qsTr("System Monitor - Cpu")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var total;
                    var system;
                    var user;
                    var wait;
                    var index;
                    var cWidth;

                    if (numCores > 1) {
                        ws = qsTr("          System    User  IO Wait   Total\n")
                        cWidth = numCores.toString().length + 1;
                        for (var idx = 0; idx < numCores; idx++) {
                            index = (idx + 1) * 3;
                            system = Number(values[index]).toFixed(2);
                            user = Number(values[index + 1]).toFixed(2);
                            wait = Number(values[index + 2]).toFixed(2);
                            total = Number(values[index]) + Number(values[index + 1]) +
                                Number(values[index + 2]);
                            total = Number(total).toFixed(2);
                            ws = ws + "Core" + idx.toString().padStart(cWidth, ' ') + " :" +
                                system.padStart(7, ' ') + "%" + user.padStart(7, ' ') + "%" +
                                wait.padStart(8, ' ') + "%" + total.padStart(7, ' ') + "%\n";

                        }
                        system = Number(values[0]).toFixed(2);
                        user = Number(values[1]).toFixed(2);
                        wait = Number(values[2]).toFixed(2);
                        total = Number(values[0]) + Number(values[1]) + Number(values[2]);
                        total = Number(total).toFixed(2);
                            ws = ws + "   All :" +
                                system.padStart(7, ' ') + "%" + user.padStart(7, ' ') + "%" +
                                wait.padStart(8, ' ') + "%" + total.padStart(7, ' ') + "%";
                    } else {
                        system = Number(values[0]).toFixed(2);
                        user = Number(values[1]).toFixed(2);
                        wait = Number(values[2]).toFixed(2);
                        total = Number(values[0]) + Number(values[1]) + Number(values[2]);
                        total = Number(total).toFixed(2);
                        ws = qsTr("System:  ") + system.padStart(6, ' ') + "%\n";
                        ws = ws + qsTr("User:    ") + user.padStart(6, ' ') + "%\n";
                        ws = ws + qsTr("IO Wait: ") + wait.padStart(6, ' ') + "%\n";
                        ws = ws + qsTr("Total    ") + total.padStart(6, ' ') + "%";
                    }
                    return ws;
                }
            }
        }
    }
    function addSources() {
        var valueIdx = 0;
        var coreCount = 0;
        
        dbusData.unsubscribe(sensorList);
        sensorList = [];
        coreCount = dbusData.doubleData("cpu/all/coreCount");
        sensorList.push("cpu/all/system");
        sensorList.push("cpu/all/user");
        sensorList.push("cpu/all/wait");
        work[0] = 0;
        work[1] = 0;
        work[2] = 0;
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        cpuValues[0] = {value: 0, count: 0};
        cpuValues[1] = {value: 0, count: 0};
        cpuValues[2] = {value: 0, count: 0};
        if (plasmoid.configuration.showCores) {
            for (var idx = 0; idx < coreCount; idx++) {
                valueIdx = (idx * 3) + 3;
                work[valueIdx] = 0;
                work[valueIdx + 1] = 0;
                work[valueIdx + 2] = 0;
                values[valueIdx] = 0;
                values[valueIdx + 1] = 0;
                values[valueIdx + 2] = 0;
                cpuValues[valueIdx] = {value: 0, count: 0};
                cpuValues[valueIdx + 1] = {value: 0, count: 0};
                cpuValues[valueIdx + 2] = {value: 0, count: 0};
                sensorList.push("cpu/cpu" +idx + "/system");
                sensorList.push("cpu/cpu" +idx + "/user");
                sensorList.push("cpu/cpu" +idx + "/wait");
            }
        } else {
            coreCount = 1;
        }
        dbusData.subscribe(sensorList);
        numCores = coreCount;
        ready = true;
    }
    Connections {
        target: plasmoid.configuration
        function onShowCoresChanged() {
            addSources();
        }
    }
    Connections {
        target: sysMonitor
        function onStatsUpd(keys, values) {
            var sensorKey;
            var valueIdx;
        
            if (!ready)
                return;
            for (var idx = 0; idx < keys.length; idx++) {
                sensorKey = keys[idx];
                switch (sensorKey) {
                    case "cpu/all/system":
                        cpuValues[0].value += values[idx];
                        cpuValues[0].count += 1;
                    break;
                    case "cpu/all/user":
                         cpuValues[1].value += values[idx];
                         cpuValues[1].count += 1;
                    break;
                    case "cpu/all/wait":
                          cpuValues[2].value += values[idx];
                          cpuValues[2].count += 1;
                    break;
                }
                if (sensorKey.indexOf("cpu/cpu") == 0) {
                    for (var idy = 0; idy < numCores; idy++) {
                        if (sensorKey.indexOf("cpu/cpu" + idy) == 0) {
                            valueIdx = (idy * 3) + 3;
                            switch (sensorKey) {
                                case "cpu/cpu" + idy + "/system" :
                                    cpuValues[valueIdx].value += values[idx];
                                    cpuValues[valueIdx].count += 1;
                                break;
                                case "cpu/cpu" + idy + "/user" :
                                    cpuValues[valueIdx + 1].value += values[idx];
                                    cpuValues[valueIdx + 1].count += 1;
                                break;
                                case "cpu/cpu" + idy + "/wait" :
                                    cpuValues[valueIdx + 2].value += values[idx];
                                    cpuValues[valueIdx + 2].count += 1;
                                break;
                            }
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var valueIdx;
            var cpuItem;
            
            for (var idx = 0; idx < 3; idx++) {
                cpuItem = cpuValues[idx];
                if (cpuItem.count > 0)
                    work[idx] = cpuItem.value / cpuItem.count;
                    cpuItem.value = 0;
                    cpuItem.count = 0;
            }
            if (plasmoid.configuration.showCores) {
                for (var idy = 0; idy < numCores; idy++) {
                    valueIdx = (idy * 3) + 3;
                    for (var idz = 0; idz < 3; idz++) {
                        cpuItem = cpuValues[valueIdx + idz];
                        if (cpuItem.count > 0) {
                            work[valueIdx + idz] = cpuItem.value / cpuItem.count;
                            cpuItem.value = 0;
                            cpuItem.count = 0;
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
