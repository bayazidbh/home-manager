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
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import DbusModel

Item {
    property var cfg_netSources: []
    property var cfg_netLabels: []

    GridLayout {
        columns: 2
        Label {
            Layout.row: 0
            Layout.column: 0
            font.bold: true
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Device")
        }
        Label {
            id: dName
            Layout.row: 0
            Layout.column: 1
            font.bold: true
            font.weight: Font.Normal
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Display Name")
        }
        Repeater {
            model: sources
            id: devfld
            CheckBox {
                Layout.row: index + 1
                Layout.column: 0
                text: model.name
                checked: model.checked
                onCheckedChanged: {
                    var idx;
                    var displaylbl;

                    displaylbl = txtfld.itemAt(index).text;
                    if (checked) {
                        idx = cfg_netSources.indexOf(model.keyid);
                        if (idx < 0) {
                            txtfld.itemAt(index).enabled = true;
                            cfg_netSources.push(model.keyid);
                            cfg_netLabels.push(displaylbl);
                        }
                    } else {
                        txtfld.itemAt(index).enabled = false;
                        idx = cfg_netSources.indexOf(model.keyid);
                        cfg_netSources.splice(idx, 1);
                        cfg_netLabels.splice(idx, 1);
                    }
                    cfg_netSourcesChanged();
                }
            }
        }
        Repeater {
            id: txtfld
            model: sources
            TextField {
                Layout.row: index + 1
                Layout.column: 1
                text: model.label
                enabled: model.checked
                placeholderText: model.name
                Layout.preferredWidth: dName.width
                Component.onCompleted: {
                    ensureVisible(0);
                }
                onTextEdited: {
                    cfg_netSourcesChanged();
                }
                onEditingFinished: {
                    var idx;

                    idx = cfg_netSources.indexOf(model.keyid);
                    cfg_netLabels.splice(idx, 1, text);
                    cfg_netSourcesChanged();
                }
            }
        }
    }
    ListModel {
        id: sources
    }
    Dbus {
        id : dbus1
    }
    Component.onCompleted: {
        var cfgLength;
        var netName;
        var sensors = [];
        var nameIdx;
        var key;
        var cfgIdx;
        var netLabel;
        var sourcesWrk;
        var labelsWrk;

        sourcesWrk = plasmoid.configuration.netSources;
        labelsWrk = plasmoid.configuration.netLabels;
        cfg_netSources.length = 0;
        cfg_netLabels.length = 0;
        sensors = dbus1.allSensors("network/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/network")) {
                nameIdx = sensors[idx].indexOf("/network");
                key = sensors[idx].slice(0,nameIdx);
                netName = dbus1.stringData(sensors[idx]);
                cfgIdx = sourcesWrk.indexOf(key);
                if (cfgIdx < 0 ) {
                    sources.append({keyid:key, name: netName, checked: false, label: ""});
                } else {
                    netLabel = labelsWrk[cfgIdx];
                    if (typeof(netLabel) == "undefined")
                        netLabel = "";
                    cfg_netSources.push(key);
                    cfg_netLabels.push(netLabel);
                    sources.append({keyid:key, name: netName, checked: true, label: netLabel});
                }
            }
        }
        plasmoid.configuration.netSources = cfg_netSources;
        plasmoid.configuration.netLabels = cfg_netLabels;
    }
}
