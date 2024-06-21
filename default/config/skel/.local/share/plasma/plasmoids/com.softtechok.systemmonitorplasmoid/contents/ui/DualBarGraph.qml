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
    property var config: []
    property var barValues: []
    property int segments: 1
    property double divisor: 1024
    property bool staticDivisor: false
    property bool showLabels: false

    onConfigChanged: requestPaint()
    onBarValuesChanged: requestPaint()

    QtObject {
        id: data
        property bool showPeaks: plasmoid.configuration.showPeaks ? !staticDivisor : false
        property var lineHeight: showPeaks ? Qt.application.font.pixelSize : 0
        property var maxHeight: showLabels ? height - lineHeight : height
    }
    onPaint: {
        var yLoc;
        var gradient;
        var ctx;
        var xLocStart;
        var xLocEnd;
        var barColor;
        var pwidth;
        var pw;
        var peakDiv = [0,""];

        function drawBar(index) {
            if (index === 0) {
                xLocStart = 0;
                xLocEnd = Math.ceil(width / 2);
            } else {
                xLocStart = Math.ceil(width / 2);
                xLocEnd = width;
            }
            yLoc = height - Math.round((data.maxHeight * (barValues[index + 1] / divisor)));
            if (!isNaN(yLoc)) {
                if (yLoc < 0)
                    yLoc = 0;
                barColor = config[index];
                gradient = ctx.createLinearGradient(xLocStart, 0, xLocEnd, 0);
                gradient.addColorStop(0, Qt.lighter(barColor));
                gradient.addColorStop(.67, barColor);
                gradient.addColorStop(1, barColor);
                ctx.fillStyle = gradient;
                ctx.strokeStyle = barColor;
                ctx.beginPath();
                ctx.moveTo(Math.ceil(xLocEnd), height);
                ctx.lineTo(Math.ceil(xLocEnd), yLoc);
                ctx.lineTo(xLocStart, yLoc);
                ctx.lineTo(xLocStart, height);
                ctx.fill();
            }
        }
        pwidth = Math.ceil(width);
        ctx = getContext("2d");
        ctx.clearRect(0, 0, pwidth, height);
        if (!staticDivisor) {
            divisor = divisor / 2;
            if (barValues[1] > divisor)
                divisor = barValues[1];
            if (barValues[2] > divisor)
                divisor = barValues[2];
            pw = 0;
            while (Math.pow(2, pw) < divisor)
                pw += 1;
            divisor = Math.pow(2, pw);
            if (divisor < 1024)
                divisor = 1024;
        }

        drawBar(0);
        drawBar(1);
        if(showLabels) {
            ctx.save();
            ctx.font = Qt.application.font.pixelSize + 'px monospace';
            ctx.fillStyle = Kirigami.Theme.textColor;
            if (data.showPeaks) {
                ctx.textAlign = "left";
                ctx.textBaseline = "top";
                peakDiv = Functions.getBinDivisor(divisor);
                ctx.fillText(Functions.format(divisor, peakDiv, 7, "Bs"), 0, 0);
            }
            ctx.textAlign = "center";
            ctx.textBaseline = "bottom";
            ctx.fillText(barValues[0], width / 2, height);
            ctx.restore();
        }
    }
}
