var exec = require('cordova/exec');

module.exports = {
    alert: function( text, success, error ){
        exec( success, error, 'CordovaPluginNotification', 'alert', [text] );
    },
    notification: function( success, error ){
        exec( success, error, 'CordovaPluginNotification', 'notification', [] );
    }
}
