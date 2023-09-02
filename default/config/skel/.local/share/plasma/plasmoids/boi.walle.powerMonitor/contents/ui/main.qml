/*
 * Copyright 2022 Phani Pavan K <kphanipavan@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 3 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/gpl-3.0.html>.
 */

import QtQuick 2.6
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: main
    anchors.fill: parent
    width: 60
    height: 15
    Layout.preferredWidth: 60 * units.devicePixelRatio
    Layout.preferredHeight: 15 * units.devicePixelRatio

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property string raplPath: "/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj"
    property double power: 0
    property double oldEnergy: 0
    property double oldTime: 0
    property var globalResponse:0

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        onExited:{
            main.globalResponse=stdout.trim();
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    function update(){
        executable.exec('cat ' + main.raplPath);
        if (main.globalResponse==''){
            display.text='PERM';
        } else {
            var time = (new Date).getTime();
            var nrgInJ = parseInt(main.globalResponse) / 1000000;
            var timeDelta = (time - main.oldTime) / 1000;
            main.power = Math.round((nrgInJ - main.oldEnergy)*10 / (timeDelta))/10;
            main.oldEnergy=nrgInJ;
            main.oldTime=time
            // console.log(power);
            if (Number.isInteger(main.power)){
                display.text=main.power+'.0 W';
            } else {
                display.text=main.power+' W';
            }
        }
    }

    function action_fixPermissions(){
        executable.connectSource('pkexec chmod 444 /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj')
    }

    function action_fixPermissionCron(){
        executable.connectSource('pkexec bash -c "crontab -l > cron_bkp && echo \"@reboot chmod 444 /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj\" >> cron_bkp && crontab cron_bkp && rm cron_bkp" ')
        // executable.connectSource('pkexec python3 permafix.py')
    }

    Component.onCompleted: {
        plasmoid.setAction('fixPermissions', i18n('Fix Sensor Permission'), 'view-refresh');
    }

    PlasmaComponents.Label {
        id: display

        anchors {
            fill: parent
            margins: Math.round(parent.width * 0.01)
        }

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        text: {
            return '';
        }

        font.pixelSize: 1000;
        minimumPointSize: theme.smallestFont.pointSize
        fontSizeMode: Text.Fit
        font.bold: plasmoid.configuration.makeFontBold
    }

    Timer {
        interval: plasmoid.configuration.updateInterval * 1000
        running: true
        repeat: true
        onTriggered: {
            update();
        }
    }
}
