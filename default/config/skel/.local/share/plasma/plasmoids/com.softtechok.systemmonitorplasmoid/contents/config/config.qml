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
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: qsTr("Layout")
        icon: "configure"
        source: "configLayout.qml"
    }
    ConfigCategory {
        name: qsTr("GPU Load")
        icon: "video-display"
        source: "configGpuUsage.qml"
    }
    ConfigCategory {
        name: qsTr("GPU Frequency")
        icon: "video-display"
        source: "configGpuFreq.qml"
    }
    ConfigCategory {
        name: qsTr("GPU Temperature")
        icon: "video-display"
        source: "configGpuTemp.qml"
    }
    ConfigCategory {
        name: qsTr("GPU Memory")
        icon: "video-display"
        source: "configGpuMemory.qml"
    }
    ConfigCategory {
        name: qsTr("Disk Space")
        icon: "drive-harddisk"
        source: "configDiskSpace.qml"
    }
    ConfigCategory {
        name: qsTr("Disk IO")
        icon: "drive-harddisk"
        source: "configDiskIO.qml"
    }
    ConfigCategory {
        name: qsTr("Network")
        icon: "network-wired"
        source: "configNetwork.qml"
    }
    ConfigCategory {
        name: qsTr("Power")
        icon: "preferences-system-power-management"
        source: "configPower.qml"
    }
    ConfigCategory {
        name: qsTr("Colors")
        icon: "preferences-desktop-color"
        source: "configColors.qml"
    }
}
