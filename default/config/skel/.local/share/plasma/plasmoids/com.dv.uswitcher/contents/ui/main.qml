import QtQuick 
import QtQml
import QtQuick.Controls as QtControls
import QtQuick.Layouts
import QtQuick.Window 

import org.kde.plasma.plasmoid
import org.kde.plasma.core  as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.coreaddons as KCoreAddons // kuser
import org.kde.kquickcontrolsaddons // kcmshell
import org.kde.plasma.private.quicklaunch // Logic
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents
import org.kde.plasma.private.sessions as Sessions
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    readonly property string displayedName: showFullName ? kuser.fullName : kuser.loginName

    readonly property bool showFace: Plasmoid.configuration.showFace
    readonly property bool showSett: Plasmoid.configuration.showSett
    readonly property bool showName: Plasmoid.configuration.showName
    property var iconSett: Plasmoid.configuration.icon
    readonly property string avatarIcon: kuser.faceIconUrl.toString()

    readonly property bool showFullName: Plasmoid.configuration.showFullName

    readonly property string userSwitcherDomain: "plasma_applet_org.kde.plasma.userswitcher"
    readonly property string lookAndFeelDomain: "plasma_lookandfeel_org.kde.lookandfeel"

    // TTY number and X display
    readonly property bool showTechnicalInfo: Plasmoid.configuration.showTechnicalInfo
    readonly property bool iconPositionRight: Plasmoid.configuration.iconPositionRight

    switchWidth: Kirigami.Units.gridUnit * 10
    switchHeight: Kirigami.Units.gridUnit * 12

    toolTipTextFormat: Text.StyledText
    toolTipSubText: i18nd(userSwitcherDomain, "You are logged in as <b>%1</b>", displayedName)

    Plasma5Support.DataSource {
        id: apps
        engine: "apps"

        property string appListConfig: Plasmoid.configuration.appList
        property ListModel model: ListModel {}
        property var userApps
        
        onNewData: {
            model.append(Object.assign({}, data, userApps.get(sourceName)))
            disconnectSource(sourceName)
        }

        onAppListConfigChanged: {
            model.clear()
            userApps = new Map(JSON.parse(appListConfig))
            Array.from(userApps.keys()).forEach(connectSource)
        }
    }
    
    Logic {
        id: kRun
        
        function launch(desktopFile) {
            openUrl('file:' + desktopFile)
        }
    }

    Binding {
        target: plasmoid
        property: "icon"
        value: kuser.faceIconUrl
        // revert to the plasmoid icon if no face given
        when: kuser.faceIconUrl.toString() !== ""
        restoreMode: Binding.RestoreBinding
    }

    KCoreAddons.KUser {
        id: kuser
    }

    compactRepresentation: MouseArea {
        id: compactRoot

        // Taken from DigitalClock to ensure uniform sizing when next to each other
        readonly property bool tooSmall: Plasmoid.formFactor === PlasmaCore.Types.Horizontal && Math.round(2 * (compactRoot.height / 5)) <= PlasmaCore.Theme.smallestFont.pixelSize

        Layout.minimumWidth: isVertical ? 0 : compactRow.implicitWidth
        Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
        Layout.preferredWidth: isVertical ? undefined : Layout.minimumWidth

        Layout.minimumHeight: isVertical ? label.height : Kirigami.Theme.smallestFont.pixelSize
        Layout.maximumHeight: isVertical ? Layout.minimumHeight : Infinity
        Layout.preferredHeight: isVertical ? Layout.minimumHeight : Kirigami.Theme.mSize(Kirigami.Theme.defaultFont).height * 2

        property bool wasExpanded
        onPressed: wasExpanded = root.expanded
        onClicked: root.expanded = !wasExpanded

        Row {
            id: compactRow
            layoutDirection: iconPositionRight ? Qt.RightToLeft : Qt.LeftToRight
            anchors.centerIn: parent
            spacing: Kirigami.Units.smallSpacing

            KirigamiComponents.Avatar {
                id: icon
                width: compactRoot.height
                height: compactRoot.height
                source: visible ? (kuser.faceIconUrl || "user-identity") : ""
                visible: root.showFace
            }

            Kirigami.Icon {
                id: icon2
                width: height
                height: compactRoot.height
                Layout.preferredWidth: height
                source: visible ? (iconSett || "avatar-default-symbolic") : ""
                visible: root.showSett
            }

            PlasmaComponents.Label {
                id: label
                text: root.displayedName
                height: compactRoot.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                fontSizeMode: Text.VerticalFit
                font.pixelSize: tooSmall ? Kirigami.Theme.defaultFont.pixelSize : Kirigami.Units.iconSizes.roundedIconSize(Kirigami.Units.gridUnit * 2)
                minimumPointSize: Kirigami.Theme.smallFont.pointSize
                visible: root.showName
            }
        }
    }

    fullRepresentation: Item {
        id: fullRoot

        implicitHeight: column.implicitHeight
        implicitWidth: column.implicitWidth

        Layout.preferredWidth: Kirigami.Units.gridUnit * 12
        Layout.preferredHeight: implicitHeight
        Layout.minimumWidth: Layout.preferredWidth
        Layout.minimumHeight: Layout.preferredHeight
        Layout.maximumWidth: Layout.preferredWidth
        Layout.maximumHeight: Screen.height / 2

        Sessions.SessionManagement {
            id: sm
        }

        Sessions.SessionsModel {
            id: sessionsModel
        }

        ColumnLayout {
            id: column

            anchors.fill: parent
            spacing: 0

            ColumnLayout {
                id: appColumn
                Repeater {
                    model: apps.model
                    
                    ActionListDelegate {
                        text: model.name
                        icon.name: model.iconName
                        onClicked: kRun.launch(model.entryPath)
                    }
                }
            }

            Rectangle {
                id: separatorItem
                Layout.alignment: Qt.AlignCenter
                width: parent.width
                height: Kirigami.Units.smallSpacing*2
                opacity: 0
            } 

            UserListDelegate {
                id: currentUserItem
                text: root.displayedName
                subText: i18n("Current user")
                source: root.avatarIcon
                hoverEnabled: false
            }

            PlasmaComponents3.ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // HACK: workaround for https://bugreports.qt.io/browse/QTBUG-83890
                PlasmaComponents3.ScrollBar.horizontal.policy: PlasmaComponents3.ScrollBar.AlwaysOff

                ListView {
                    id: userList
                    model: sessionsModel

                    focus: true
                    interactive: true
                    keyNavigationWraps: true

                    delegate: UserListDelegate {
                        width: ListView.view.width

                        activeFocusOnTab: true

                        text: {
                            if (!model.session) {
                                return i18nc("Nobody logged in on that session", "Unused")
                            }

                            if (model.realName && root.showFullName) {
                                return model.realName
                            }

                            return model.name
                        }
                        source: model.icon
                        subText: {
                            if (!root.showTechnicalInfo) {
                                return ""
                            }

                            if (model.isTty) {
                                return i18nc("User logged in on console number", "TTY %1", model.vtNumber)
                            } else if (model.displayNumber) {
                                return i18nc("User logged in on console (X display number)", "on %1 (%2)", model.vtNumber, model.displayNumber)
                            }
                            return ""
                        }

                        KeyNavigation.up: index === 0 ? currentUserItem.nextItemInFocusChain() : userList.itemAtIndex(index - 1)
                        KeyNavigation.down: index === userList.count - 1 ? newSessionButton : userList.itemAtIndex(index + 1)

                        Accessible.description: i18nc("@action:button", "Switch to User %1", text)

                        onClicked: sessionsModel.switchUser(model.vtNumber, sessionsModel.shouldLock)
                    }
                }
            }

            ActionListDelegate {
                id: newSessionButton
                text: i18ndc(userSwitcherDomain, "@action", "New Session")
                visible: sessionsModel.canStartNewSession
                onClicked: sessionsModel.startNewSession(sessionsModel.shouldLock)
            }

            Rectangle {
                id: separatorItem3
                Layout.alignment: Qt.AlignCenter
                width: parent.width
                height: Kirigami.Units.smallSpacing*2
                opacity: 0 
            }

            ActionListDelegate {
                id: lockScreenButton
                text: i18ndc(userSwitcherDomain, "@action", "Lock Screen")
                icon.name: "system-lock-screen"
                visible: sm.canLock
                onClicked: sm.lock()
            }

            ActionListDelegate {
                id: suspendButton
                text: i18ndc(lookAndFeelDomain, "Suspend to RAM", "Sleep")
                icon.name: "system-suspend"
                onClicked: sm.suspend()
            }

            ActionListDelegate {
                id: leaveButton
                text: i18ndc(userSwitcherDomain, "Show a dialog with options to logout/shutdown/restart", "Leave…")
                icon.name: "system-log-out"
                onClicked: sm.requestShutdown()
            }

            Connections {
                target: root
                function onExpandedChanged() {
                    if (root.expanded) {
                        sessionsModel.reload();
                    }
                }
    
            }
        }
    }
}
