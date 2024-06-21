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
    property var numberOfSources: 0
    property var powerLabels: []
    property var values: [0, 0, 0] // Current Charge/Discharge Health
    property var work: []
    property var pwrValues: []
    property var maxValues: []
    property var pwrUnits: []
    property var onBattery: false
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
        property var command: plasmoid.configuration.powerCommand

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
        property real barWidth: (rectangle.width - (rectangle.border.width * 2)) / numberOfSources
        property int barHeight: rectangle.height - (rectangle.border.width * 2)
        property color currentColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerCurrentColor : "blue"
        property color chargeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerChargeColor : "green"
        property color dischargeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerDischargeColor : "red"

        sourceComponent: plasmoid.configuration.powerBarGraph ? barGraph : undefined
        Component {
            id: barGraph
            Row {
                Repeater {
                    model: numberOfSources
                    Rectangle {
                        property int currentCharge: index * 3
                        property int chargeRate: (index * 3) + 1
                        property color rateColor: !onBattery ? chargeColor : dischargeColor

                        x: (index * barWidth) + rectangle.border.width
                        y: rectangle.border.width
                        DualBarGraph {
                            width: barWidth
                            height: barHeight
                            divisor: maxValues[index]
                            staticDivisor: true;
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            config: [currentColor, rateColor]
                            barValues: [powerLabels[index], values[currentCharge],
                                values[chargeRate]]
                        }
                    }
                }
            }
        }
    }

    Loader {
        property color currentColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerCurrentColor : "blue"
        property color chargeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerChargeColor : "green"
        property color dischargeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerDischargeColor : "red"
        property int xDem: 1
        property int yDem: 1

        sourceComponent: plasmoid.configuration.powerCircularGraph ? circleGraph : undefined
        function reArrange () {
            if (rectangle.width > rectangle.height) {
                yDem = Math.floor(Math.sqrt(numberOfSources))
                xDem = numberOfSources / yDem
            } else {
                xDem = Math.floor(Math.sqrt(numberOfSources))
                yDem = numberOfSources / xDem
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
                    model: numberOfSources
                    DualCircleGraph {
                        id: circGraph
                        property int currentCharge: (index * 3)
                        property int chargeRate: (index * 3) + 1
                        property color rateColor: !onBattery ? chargeColor : dischargeColor

                        width: (rectangle.width - (rectangle.border.width * 2)) / xDem
                        height: (rectangle.height - (rectangle.border.width * 2)) / yDem
                        config: [currentColor, rateColor]
                        divisor: maxValues[index]
                        staticDivisor: true;
                        showLabels: plasmoid.configuration.showLabels && !compactView
                        segValues: [powerLabels[index], values[currentCharge],
                            values[chargeRate]]
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
            numberOfSources
        property color currentColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerCurrentColor : "blue"
        property color chargeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerChargeColor : "green"
        property color dischargeColor: plasmoid.configuration.customColors ?
            plasmoid.configuration.powerDischargeColor : "red"

        sourceComponent: plasmoid.configuration.powerPlotterGraph ? plotGraph : undefined
        Component {
            id: plotGraph
            Column {
                Repeater {
                    model: numberOfSources
                    Rectangle {
                        x: rectangle.border.width
                        y: Math.round(index * plotHeight) + rectangle.border.width
                        DualPlotterGraph {
                            property int currentCharge: index * 3
                            property int chargeRate: (index * 3) + 1
                            property color rateColor: !onBattery ? chargeColor : dischargeColor

                            width: plotWidth
                            height: Math.floor(plotHeight)
                            config: [currentColor, rateColor]
                            plots: 2
                            divisor: maxValues[index]
                            staticDivisor: true;
                            showLabels: plasmoid.configuration.showLabels && !compactView
                            plotValues: [powerLabels[index], values[currentCharge],
                                values[chargeRate]]
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
                text: qsTr("System Monitor - Power")
            }
            PlasmaComponents.Label {
                font.family: "Monospace"
                Layout.alignment: Qt.AlignHCenter
                text: {
                    var ws;
                    var total;
                    var index;
                    var charge;
                    var chargeRate;
                    var chargePercent;
                    var timeRemain;
                    var timeFull;
                    var numPwr;
                    var health;
                    var maxCharge;
                    var hours;
                    var mins;
                    var divisor = [0, ""];

                    ws = "";
                    numPwr = numberOfSources - 1;
                    for (var idx = 0; idx <= numPwr; idx++) {
                        index = idx * 3;
                        maxCharge = maxValues[idx];
                        charge = values[index];
                        chargeRate = values[index + 1];
                        chargePercent = (charge / maxCharge) * 100;
                        health = values[index + 2];
                        ws += powerLabels[idx] + "\n";
                        divisor = Functions.getDivisor(health, pwrUnits[index + 2]);
                        ws = ws + qsTr("Health:         ") +
                            Functions.format(health, divisor, 7, "%") + "\n";
                        divisor = Functions.getDivisor(charge, pwrUnits[index]);
                        ws = ws + qsTr("Current Charge: ") +
                            Functions.format(charge, divisor, 7, "Wh") + "\n";
                        ws = ws + qsTr("                ") +
                            chargePercent.toFixed(2).padStart(7, ' ') + "  %\n";
                        divisor = Functions.getDivisor(chargeRate, pwrUnits[index + 1]);
                        if (onBattery) {
                            if (chargeRate > 0) {
                                timeRemain = charge / chargeRate;
                                hours = Math.trunc(timeRemain);
                                mins = Math.round((timeRemain - hours) * 60);
                            } else {
                                hours = 0;
                                mins = 0;
                            }
                            ws = ws + qsTr("Discharge Rate: ") +
                                Functions.format(chargeRate, divisor, 7, "W") + "\n";
                            ws = ws + qsTr("Time Remaining:  ");
                            if (chargeRate > 0) {
                                ws = ws + hours.toString().padStart(3, ' ') +
                                    ":" + mins.toString().padStart(2, '0');
                            }
                        } else {
                            if (chargeRate > 0) {
                                timeRemain = (maxCharge - charge) / chargeRate;
                                hours = Math.trunc(timeRemain);
                                mins = Math.round((timeRemain - hours) * 60);
                            } else {
                                hours = 0;
                                mins = 0;
                            }
                            ws = ws + qsTr("Charging Rate:  ") +
                                Functions.format(chargeRate, divisor, 7, "W") + "\n";
                            if ((chargeRate / maxCharge) > .05) {
                                ws = ws + qsTr("Full Charge in:   ") +
                                    hours.toString().padStart(2, ' ') +
                                    ":" + mins.toString().padStart(2, '0');
                            } else {
                                ws = ws + qsTr("Fully Charged:");
                            }
                        }
                        if (idx < numPwr)
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
        var powerlbl;
        var wrk;

        count = 0;
        sensorList = [];
        sensors = dbusData.allSensors("power/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/name")) {
                keyidx = sensors[idx].indexOf("/name");
                key = sensors[idx].slice(0,keyidx);
                sensoridx = plasmoid.configuration.powerSources.indexOf(key);
                if (sensoridx >= 0) {
                    maxValues[sensoridx] = dbusData.maxValue(key + "/charge");
                    pwrUnits[(sensoridx * 2)] = dbusData.unitValue(key + "/charge");
                    pwrUnits[(sensoridx * 2) + 1] = dbusData.unitValue(key + "/chargeRate");
                    pwrUnits[(sensoridx * 2) + 2] = dbusData.unitValue(key + "/health");
                    sensorList.push(key + "/charge");
                    sensorList.push(key + "/chargeRate");
                    sensorList.push(key + "/health");
                    powerlbl = plasmoid.configuration.powerLabels[sensoridx];
                    if (typeof(powerlbl) !== "undefined") {
                        if (powerlbl != "") {
                            powerLabels[sensoridx] = powerlbl;
                        } else {
                            powerLabels[sensoridx] = dbusData.stringData(key + "/name");
                        }
                    } else {
                        powerLabels[sensoridx] =  dbusData.stringData(key + "/name");
                    }
                    work[sensoridx * 2] = 0;
                    work[(sensoridx * 2) + 1] = 0;
                    work[(sensoridx * 2) + 2] = 0;
                    values[(sensoridx * 2)] = 0;
                    values[(sensoridx * 2) + 1] = 0;
                    values[(sensoridx * 2) + 2] = 0;
                    wrk = dbusData.doubleData(key + "/charge");
                    pwrValues[(sensoridx * 2)] = {value:wrk, count:1};
                    wrk = Math.abs(dbusData.doubleData(key + "/chargeRate"));
                    pwrValues[(sensoridx * 2) + 1] = {value:wrk, count:1};
                    wrk = dbusData.doubleData(key + "/health");
                    pwrValues[(sensoridx * 2) + 2] = {value:wrk, count:1};
                    count += 1;
                }
            }
        }
        dbusData.subscribe(sensorList);
        numberOfSources = count;
        ready = true;
    }
    Connections {
        target: plasmoid.configuration
            function onPowerLabelsChanged() {
            dbusData.unsubscribe(sensorList);
            addSources();
        }
        function onPowerSourcesChanged() {
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
                for (var idy = 0; idy < numberOfSources; idy++) {
                    configKey = plasmoid.configuration.powerSources[idy];
                    if (sensorKey.indexOf(configKey) == 0) {
                        valueIdx = idy * 2;
                        switch (sensorKey) {
                            case configKey + "/charge":
                                pwrValues[valueIdx].value += values[idx];
                                pwrValues[valueIdx].count += 1;
                            break;
                            case configKey + "/chargeRate":
                                pwrValues[valueIdx + 1].value += Math.abs(values[idx]);
                                pwrValues[valueIdx + 1].count += 1;
                            break;
                            case configKey + "/health":
                                pwrValues[valueIdx + 2].value += values[idx];
                                pwrValues[valueIdx + 2].count += 1;
                            break;
                        }
                    }
                }
            }
        }
        function  onUpdateUi() {
            var valueIdx;
            var powerItem;
            
            if (plasmoid.configuration.powerSources != "") {
                for (var idx = 0; idx < numberOfSources; idx++) {
                    valueIdx = (idx * 3);
                    for (var idy = 0; idy <= 2; idy++) {
                        powerItem = pwrValues[valueIdx + idy];
                        if (powerItem.count > 0) {
                            if (idy == 1)
                                onBattery = dbusData.battStatus();
                            work[valueIdx + idy] = powerItem.value / powerItem.count;
                            powerItem.value = 0;
                            powerItem.count = 0;
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
