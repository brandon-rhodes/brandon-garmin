using Toybox.Application as App;

class LatLonFieldApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new LatLonFieldView() ];
    }
}
