/*
 * Copyright 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 
import QtQuick.Controls as QtControls
import QtQuick.Dialogs
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property bool cfg_showFace
    property bool cfg_showName
    property bool cfg_showFullName
    property bool cfg_showSett
    property alias cfg_icon: icon.text
    property alias cfg_showTechnicalInfo: showTechnicalInfoCheck.checked

    Kirigami.FormLayout {
        QtControls.ButtonGroup {
            id: nameGroup
        }

        QtControls.RadioButton {
            id: showFullNameRadio

            Kirigami.FormData.label: i18nc("@title:label", "Username style:")

            QtControls.ButtonGroup.group: nameGroup
            text: i18nc("@option:radio", "Full name (if available)")
            checked: cfg_showFullName
            onClicked: if (checked) cfg_showFullName = true;
        }

        QtControls.RadioButton {
            QtControls.ButtonGroup.group: nameGroup
            text: i18nc("@option:radio", "Login username")
            checked: !cfg_showFullName
            onClicked: if (checked) cfg_showFullName = false;
        }


        Item {
            Kirigami.FormData.isSection: true
        }


        QtControls.ButtonGroup {
            id: layoutGroup
        }

        QtControls.RadioButton {
            id: showOnlyNameRadio

            Kirigami.FormData.label: i18nc("@title:label", "Show:")

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Name")
            checked: cfg_showName && !cfg_showFace && !cfg_showSett
            onClicked: {
                if (checked) {
                    cfg_showName = true;
                    cfg_showFace = false; 
                    cfg_showSett =  false;
                }
            }
        }

        QtControls.RadioButton {
            id: showOnlyFaceRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "User picture")
            checked: !cfg_showName && cfg_showFace && !cfg_showSett
            onClicked: {
                if (checked) {
                    cfg_showName = false;
                    cfg_showFace = true;
                    cfg_showSett =  false;
                }
            }
        }

        QtControls.RadioButton {
            id: showOnlySettRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Icon")
            checked: !cfg_showName && !cfg_showFace && cfg_showSett
            onClicked: {
                if (checked) {
                    cfg_showName = false;
                    cfg_showFace = false;
                    cfg_showSett =  true;
                }
            }
        }

        QtControls.RadioButton {
            id: showBothRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Name and user picture")
            checked: cfg_showName && cfg_showFace && !cfg_showSett
            onClicked: {
                if (checked) {
                    cfg_showName = true;
                    cfg_showFace = true;
                    cfg_showSett =  false;
                }
            }
        }

        QtControls.RadioButton {
            id: showIconAndNameRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Name and icon")
            checked: cfg_showName && !cfg_showFace && cfg_showSett
            onClicked: {
                if (checked) {
                    cfg_showName = true;
                    cfg_showFace = false;
                    cfg_showSett =  true;
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        RowLayout {
            QtControls.TextField { 
                Kirigami.FormData.label: i18nc("@title:label", "Icon:")
                id: icon
                implicitWidth: 300
            }

            ConfigIcon {
                value: icon.text
                onValueChanged: icon.text = value
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }


        QtControls.CheckBox {
            id: showTechnicalInfoCheck

            Kirigami.FormData.label: i18nc("@title:label", "Advanced:")

            text: i18nc("@option:check", "Show technical session information")
        }
    }
}
