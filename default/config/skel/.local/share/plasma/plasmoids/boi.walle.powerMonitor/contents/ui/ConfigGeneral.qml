import QtQuick 2.6
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore


Item {
    id: settings
    property alias cfg_updateInterval: updateInterval.value
    property alias cfg_makeFontBold: makeFontBold.checked
    property var doesntHaveFixCommand: 1
        PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            console.log(exitCode)
            console.log(exitStatus)
            console.log(stdout)
            console.log(stderr)
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        onExited:{
            settings.doesntHaveFixCommand=stdout.trim();
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    ColumnLayout {
        RowLayout {
            Label {
                id: updateIntervalLabel
                text: i18n("Update interval:")
            }
            SpinBox {
                id: updateInterval
                decimals: 1
                stepSize: 0.1
                minimumValue: 0.1
                suffix: i18nc("Abbreviation for seconds", "s")
            }
        }



        CheckBox {
            id: makeFontBold 
            text: i18n("Bold Text")
        }

        PlasmaComponents.Button {
            // iconSource: ""
            text: i18n('Add "Fix Permission" to CronJobs')
            onPressed: {
                // executable.exec('pkexec crontab -l | grep "@reboot chmod 444 /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj" > /dev/null ; echo $?')
                // if (settings.doesntHaveFixCommand=='1'){
                // executable.connectSource('pkexec bash -c "crontab -l > ~/cron_bkp && echo @reboot chmod 444 /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj >> ~/cron_bkp && crontab ~/cron_bkp && rm ~/cron_bkp" ')
                executable.connectSource('pkexec bash -c "crontab -l | grep @reboot | grep chmod | grep 444 | grep /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj > /dev/null" ; if [[ $? -eq 1 ]]; then pkexec bash -c "echo yes && crontab -l > ~/cron_bkp && echo @reboot chmod 444 /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj >> ~/cron_bkp && crontab ~/cron_bkp && rm ~/cron_bkp" ; fi' )
        }
    }
}
}
