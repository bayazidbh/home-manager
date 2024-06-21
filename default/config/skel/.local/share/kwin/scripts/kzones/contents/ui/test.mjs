console.log('Hello, world!');

function sayHello() {
    console.log('Hello, world!');
}


function createUserActionsMenu (client, callback) {

    registerUserActionsMenu(function(client) {
        return {
            text : "Toggle floating",
            icon: "view-fullscreen",
            checkable: true,
            triggered: callback
        };
    });

}

export { createUserActionsMenu, sayHello };
    


