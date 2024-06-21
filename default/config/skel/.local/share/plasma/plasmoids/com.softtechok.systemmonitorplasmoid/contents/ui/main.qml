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
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: sysMonitor
    switchWidth: Kirigami.Units.gridUnit * 5;
    switchHeight: Kirigami.Units.gridUnit * 5;
    fullRepresentation: FullRepresentation {}
    compactRepresentation: CompactRepresentation {}
    
    signal updateUi()
    signal statsUpd(var keys, var values)

    property alias dbusData : dbusData
    
    DbusData {
        id: dbusData
        onNewSensorData: (keys, values) => {
            sysMonitor.statsUpd(keys, values)
        }
    }
    Timer {
        interval: plasmoid.configuration.updateInterval * 100
        running: true
        repeat: true

        onTriggered: {
            updateUi()
        }
    }
}
