/*
    KWin - the KDE window manager
    This file is part of the KDE project.

    SPDX-FileCopyrightText: 2022 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

let applicationList = readConfig("ApplicationList", "gamescope").toString().toLowerCase().split(",");


for (i = 0; i < applicationList.length; ++i) {
    applicationList[i] = applicationList[i].trim();
}

function isClientInList(client) {
    if (applicationList.indexOf(client.resourceClass.toString()) >= 0) {
        return true;
    } else {
        return false;
    }
}

function shouldApplyToClient(client) {
    if (client.minimized || client.transient || !client.fullScreen) {
        return false;
    } else {
        return isClientInList(client);
    }
}

var forceTileClient = function(client) {
    if (!shouldApplyToClient(client)) {
        return;
    }
    const tiling = workspace.tilingForScreen(client.screen);

    let widestTile = null;
    for (i in tiling.rootTile.tiles) {
        let tile = tiling.rootTile.tiles[i];
        if (tile.tiles.length) {
            continue;
        }
        if (!widestTile || tile.width > widestTile.width) {
            widestTile = tile;
        }
    }
    if (widestTile === null) {
        return;
    }

    client.tile = tiling.rootTile.tiles[1];
    client.frameGeometry = tiling.rootTile.tiles[1].absoluteGeometry;
}

var clientAdded = function(client) {
    if (!isClientInList(client)) {
        return;
    }

    if (shouldApplyToClient(client)) {
        forceTileClient(client);
    }
};

var clientFullScreenSet = function (client, fullScreen, user) {
    if (fullScreen) {
        forceTileClient(client);
    }
};

workspace.clientAdded.connect(clientAdded);
workspace.clientFullScreenSet.connect(clientFullScreenSet);


let clients = workspace.clientList();

for (let i = 0; i < clients.length; i++) {
    clientAdded(clients[i]);
}
