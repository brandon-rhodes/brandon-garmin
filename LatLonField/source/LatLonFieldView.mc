//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class LatLonFieldView extends Ui.DataField
{
    hidden var lat = "Latitude";
    hidden var lon = "Longitude";
    hidden var elev = "Elevation";

    //! constructor
    function initialize()
    {
        DataField.initialize();
    }

    // https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/Activity/Info.html

    //! The given info object contains all the current workout
    //! information. Calculate a value and save it locally in this method.
    function compute(info)
    {
        if (info.currentLocation != null) {
            var s = info.currentLocation.toGeoString(2);
            var a = splitGeoString(s);
            lat = a[0];
            lon = a[1];
            var m = info.altitude;
            var ft = m / 0.3048;
            elev = m.toNumber().toString() + "m = "
                + ft.toNumber().toString() + "ft";
        }
    }

    function splitGeoString(s)
    {
        var c = s.toCharArray();
        var i = 0;
        var j = 0;
        while (c[j].toNumber() < 127) {
            j += 1;
        }
        var lat = s.substring(i, j);
        while (c[j].toNumber() >= 127) {
            j += 1;
        }
        lat += "°";
        i = j;
        while (c[j].toNumber() < 64) {
            j += 1;
        }
        lat += s.substring(i, j);
        i = j;

        var lon = "";
        while (c[j].toNumber() < 127) {
            j += 1;
        }
        lon += s.substring(i, j);
        while (c[j].toNumber() >= 127) {
            j += 1;
        }
        lon += "°";
        i = j;
        lon += s.substring(i, c.size());
        return [lat, lon];
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    function onUpdate(dc)
    {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 19, Gfx.FONT_TINY,
        lat, (Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER));
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 1, Gfx.FONT_TINY,
        lon, (Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER));
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 17, Gfx.FONT_TINY,
        elev, (Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER));
    }
}
