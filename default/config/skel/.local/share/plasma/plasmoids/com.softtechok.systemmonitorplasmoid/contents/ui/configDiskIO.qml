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
    property var cfg_dioSources: []
    property var cfg_dioLabels: []

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
                        idx = cfg_dioSources.indexOf(model.keyid);
                        if (idx < 0) {
                            txtfld.itemAt(index).enabled = true;
                            cfg_dioSources.push(model.keyid);
                            cfg_dioLabels.push(displaylbl);
                        }
                    } else {
                        txtfld.itemAt(index).enabled = false;
                        idx = cfg_dioSources.indexOf(model.keyid);
                        cfg_dioSources.splice(idx, 1);
                        cfg_dioLabels.splice(idx, 1);
                    }
                    cfg_dioSourcesChanged();
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
                    cfg_dioSourcesChanged();
                }
                onEditingFinished: {
                    var idx;

                    idx = cfg_dioSources.indexOf(model.keyid);
                    cfg_dioLabels.splice(idx, 1, text);
                    cfg_dioSourcesChanged();
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
        var dskName;
        var sensors = [];
        var nameIdx;
        var key;
        var cfgIdx;
        var dskLabel;
        var sourcesWrk;
        var labelsWrk;

        sourcesWrk = plasmoid.configuration.dioSources;
        labelsWrk = plasmoid.configuration.dioLabels;
        cfg_dioSources.length = 0;
        cfg_dioLabels.length = 0;
        sensors = dbus1.allSensors("disk/");
        for (var idx = 0; idx < sensors.length; idx++) {
            if (sensors[idx].endsWith("/name")) {
                nameIdx = sensors[idx].indexOf("/name");
                key = sensors[idx].slice(0,nameIdx);
                dskName = dbus1.stringData(sensors[idx]);
                cfgIdx = sourcesWrk.indexOf(key);
                if (cfgIdx < 0 ) {
                    sources.append({keyid:key, name: dskName, checked: false, label: ""});
                } else {
                    dskLabel = labelsWrk[cfgIdx];
                    if (typeof(dskLabel) == "undefined")
                        dskLabel = "";
                    cfg_dioSources.push(key);
                    cfg_dioLabels.push(dskLabel);
                    sources.append({keyid:key, name: dskName, checked: true, label: dskLabel});
                }
            }
        }
        plasmoid.configuration.dioSources = cfg_dioSources;
        plasmoid.configuration.dioLabels = cfg_dioLabels;
    }
}
