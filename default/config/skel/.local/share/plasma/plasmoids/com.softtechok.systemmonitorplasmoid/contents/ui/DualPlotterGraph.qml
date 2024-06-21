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
import org.kde.kirigami as Kirigami
import "functions.js" as Functions

Canvas {
    id: plotCanvas
    property var config: []
    property int plots: 0
    property double divisor: 1024
    property bool staticDivisor: false
    property var plotValues: []
    property bool showLabels: false

    QtObject {
        id: data
        property var graphValues: []
        property int numValues: 0
        property int maxValues: 33
        property real segSize: width / (maxValues - 1 )
        property bool valuesChanged : false
        property bool reset: false
        property var paths: []
        property bool smoothing: plasmoid.configuration.useSmoothing
        property bool showPeaks: plasmoid.configuration.showPeaks ? !staticDivisor : false
        property var lineHeight: showPeaks ? Qt.application.font.pixelSize : 0
        property var maxHeight: showLabels ? height - (2 * lineHeight) : height

        onSmoothingChanged: resetPaths()
    }

    onPlotValuesChanged: updateValues();
    onConfigChanged: requestPaint();

    function updateValues () {
        data.valuesChanged = true;
        requestPaint();
    }
    function resetPaths() {
        data.reset = true;
    }
    Component {
        id: line
        PathLine {}
    }
    Component {
        id: curve
        PathCubic {}
    }
    Path {
        id: plot
    }

    onPaint: {
        var ctx;
        var idx;
        var idy;
        var pointCnt;
        var curXLoc;
        var curYLoc;
        var clr;
        var pw;
        var alpha;
        var xDiff;
        var pointValue;
        var peakValues = [0, 0];

        function addPoint(xLoc, yLoc) {
            if (data.paths.length < pointCnt + 1) {
                if (data.smoothing) {
                    data.paths[pointCnt] = curve.createObject(plotCanvas, {});
                } else {
                    data.paths[pointCnt] = line.createObject(plotCanvas, {});
                }
            }
            if (data.smoothing) {
                data.paths[pointCnt].x = Math.round(xLoc);
                data.paths[pointCnt].y = Math.round(yLoc);
                if (pointCnt == 0) {
                    data.paths[pointCnt].control1X = plot.startX;
                    data.paths[pointCnt].control1Y = plot.startY;
                    data.paths[pointCnt].control2X = xLoc;
                    data.paths[pointCnt].control2Y = yLoc;
                } else {
                    xDiff = ((data.paths[pointCnt - 1].x - xLoc) / 3);
                    data.paths[pointCnt].control1X = data.paths[pointCnt - 1].x - xDiff;
                    data.paths[pointCnt].control1Y = data.paths[pointCnt - 1].y;
                    data.paths[pointCnt].control2X = xLoc + xDiff;
                    data.paths[pointCnt].control2Y = yLoc;
                }
            } else {
                data.paths[pointCnt].x = Math.round(xLoc);
                data.paths[pointCnt].y = Math.round(yLoc);
            }
            pointCnt += 1;
        }
        
        if (data.reset) {
            data.paths.length = 0;
            data.reset = false;
        }
        if (data.valuesChanged) {
            if (data.graphValues.length != plots) {
                for (idx = 0; idx < plots; idx++)
                    data.graphValues[idx] = [];
            }
            if (data.numValues >= data.maxValues) {
                for (idx = 0; idx < plots; idx++)
                    data.graphValues[idx].shift();
                data.numValues -= 1;
            }
            data.numValues += 1;
            for (idx = 0; idx < plots; idx++)
                data.graphValues[idx].push(plotValues[idx + 1]);
            data.valuesChanged = false;
        }
        ctx = getContext("2d");
        ctx.clearRect(0, 0, width, Math.ceil(height));
        if (data.numValues > 1) {
            for (idy = 0; idy < plots; idy++) {
                for (idx = 0; idx < data.numValues; idx++) {
                    pointValue = data.graphValues[idy][idx];
                    if (pointValue > peakValues[idy]) {
                        peakValues[idy] = pointValue;
                    }
                }
            }
            if (!staticDivisor) {
                divisor = peakValues[0];
                if (peakValues[1] > divisor)
                    divisor = peakValues[1];
            }
            plot.startX = width;
            plot.startY = height;
            for (idy = 0; idy < plots; idy++) {
                clr = config[idy];
                alpha = .5;
                if (idy === 0)
                    alpha = 1;
                ctx.fillStyle = Qt.hsla(clr.hslHue, clr.hslSaturation, clr.hslLightness, alpha);
                curXLoc = width;
                curYLoc = height;
                pointCnt = 0;
                for (idx = data.numValues - 1; idx >= 0; idx--) {
                    curYLoc = height - (data.graphValues[idy][idx] * data.maxHeight / divisor);
                    addPoint(curXLoc, curYLoc);
                    curXLoc -= data.segSize;
                }
                plot.pathElements = data.paths;
                ctx.path = plot;
                ctx.lineTo(curXLoc + data.segSize, height);
                ctx.fill();
            }
        }
        if(showLabels) {
            var lineHeight;
            var peakDiv = [0, ""];

            ctx.save();
            ctx.font = Qt.application.font.pixelSize + 'px monospace';
            if (data.showPeaks) {
                peakDiv = Functions.getBinDivisor(divisor);
                ctx.textAlign = "left";
                ctx.textBaseline = "top";
                ctx.fillStyle = config[0];
                ctx.fillText(Functions.format(peakValues[0], peakDiv, 7, "Bs"), 0, 0);
                ctx.fillStyle = config[1];
                ctx.fillText(Functions.format(peakValues[1], peakDiv, 7, "Bs"), 0,
                    data.lineHeight);
            }
            ctx.textAlign = "left";
            ctx.textBaseline = "bottom";
            ctx.fillStyle = Kirigami.Theme.textColor;
            ctx.fillText(plotValues[0], 0, height);
            ctx.restore();
        }
    }
}
