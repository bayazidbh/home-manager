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

Canvas {
    property var config: []
    property var segValues: []
    property int segments: 1
    property double divisor: 1
    property bool showLabels: false

    onConfigChanged: requestPaint()
    onSegValuesChanged: requestPaint()

    rotation: 90
    onPaint: {
        var centreX;
        var centreY;
        var diameter;
        var halfDiam;
        var startAngle;
        var endAngle;
        var radians = 2 * Math.PI  * .9999;
        var ctx;

        function drawArc(angleStart, angleEnd, fillColor) {
            ctx.beginPath();
            ctx.fillStyle = fillColor;
            ctx.strokeStyle = fillColor;
            ctx.arc(centreX, centreY, diameter, angleStart, angleEnd, false);
            ctx.arc(centreX, centreY, halfDiam, angleEnd, angleStart, true);
            ctx.fill();
        }
        function showArc(dataValue, arcColor) {
            endAngle = startAngle + ((dataValue / divisor) * radians);
            if (endAngle > radians)
                endAngle = radians;
            drawArc(startAngle, endAngle, arcColor);
            startAngle = endAngle;
        }

        ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        centreX = width / 2;
        centreY = height / 2;
        if (width > height) {
            diameter = height * .48;
        } else {
            diameter = width * .48;
        }
        halfDiam = diameter / 2;
        ctx.beginPath();
        ctx.strokeStyle = Qt.hsla(Kirigami.Theme.textColor.hslHue,
            Kirigami.Theme.textColor.hslSaturation,
            Kirigami.Theme.textColor.hslLightness, .5);
        startAngle = 0;
        endAngle = startAngle + radians;
        ctx.arc(centreX, centreY, diameter, startAngle, endAngle, false);
        ctx.arc(centreX, centreY, halfDiam, startAngle, endAngle, false);
        ctx.stroke();
        startAngle = 0;
        for (var idx = 1; idx <= segments; idx++) {
            showArc(segValues[idx], config[idx - 1]);
        }
        if(showLabels) {
            ctx.save();
            ctx.translate(centreX, centreY);
            ctx.rotate(-Math.PI / 2);
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.font = Qt.application.font.pixelSize + 'px monospace';
            ctx.fillStyle = Kirigami.Theme.textColor;
            ctx.fillText(segValues[0], 0, 0);
            ctx.restore();
        }
    }
}
