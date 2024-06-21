import QtQuick
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.iconthemes as KIconThemes

Button {
    id: configIcon

    property string defaultValue: ''
    property string value: ''

    icon.name: value

    KIconThemes.IconDialog {
        id: iconDialog
        onIconNameChanged: configIcon.value = iconName || configIcon.defaultValue
    }

    onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

    Menu {
        id: iconMenu

        // Appear below the button
        y: +parent.height

        MenuItem {
            text: i18ndc("plasma_applet_org.kde.plasma.kickoff", "@item:inmenu Open icon chooser dialog", "Choose...")
            icon.name: "document-open-folder"
            onClicked: iconDialog.open()
        }
        MenuItem {
            text: i18ndc("plasma_applet_org.kde.plasma.kickoff", "@item:inmenu Reset icon to default", "Clear Icon")
            icon.name: "edit-clear"
            onClicked: configIcon.value = configIcon.defaultValue
        }
    }
}