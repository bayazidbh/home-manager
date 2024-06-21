console.log('Hello, world!');

function sayHello() {
    console.log('Hello, world!');
}


function createUserActionsMenu (client, callback) {

    console.log('createUserActionsMenu called');

}

registerUserActionsMenu(function(client) {
    return {
        text : "Toggle floating",
        icon: "view-fullscreen",
        checkable: true,
        triggered: function () {
            client.tiling_floating = ! client.tiling_floating;
            if (client.tiling_floating == true) {
                self.tiles._onClientRemoved(client);
            } else {
                self.tiles.addClient(client);
            }
        }
    };
});

module.exports = {
    sayHello: sayHello,
    createUserActionsMenu: createUserActionsMenu
};
    


