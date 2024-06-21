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
    property var barValues: []
    property int segments: 1
    property double divisor: 1
    property bool showLabels: false

    onConfigChanged: requestPaint();
    onBarValuesChanged: requestPaint();

    onPaint: {
        var curYLoc;
        var nextYLoc;
        var gradient;
        var ctx;
        var barColor;
        var pwidth;

        pwidth = Math.ceil(width);
        ctx = getContext("2d");
        ctx.clearRect(0, 0, pwidth, height);
        for (var idx = 0; idx < segments; idx++) {
            if (idx == 0)
                curYLoc = height;
            nextYLoc = curYLoc - Math.round((height * (barValues[idx + 1] / divisor)));
            if (!isNaN(nextYLoc)) {
                barColor = config[idx];
                gradient = ctx.createLinearGradient(0, 0, pwidth, 0);
                gradient.addColorStop(0, Qt.lighter(barColor));
                gradient.addColorStop(.67, barColor);
                gradient.addColorStop(1, barColor);
                ctx.fillStyle = gradient;
                ctx.strokeStyle = barColor;
                ctx.beginPath();
                ctx.moveTo(pwidth, curYLoc);
                ctx.lineTo(pwidth, nextYLoc);
                ctx.lineTo(0, nextYLoc);
                ctx.lineTo(0, curYLoc);
                ctx.fill();
            }
            curYLoc = nextYLoc;
        }
        if(showLabels) {
            ctx.save();
            ctx.textAlign = "center";
            ctx.textBaseline = "bottom";
            ctx.font = Qt.application.font.pointSize + 'pt "' + Qt.application.font.family + '"';
            ctx.fillStyle = Kirigami.Theme.textColor;
            ctx.fillText(barValues[0], width / 2, height);
            ctx.restore();
        }
    }
}
