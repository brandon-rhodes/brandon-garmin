using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class LatLonFieldView extends Ui.DataField
{
    hidden var lat = "Latitude";
    hidden var lon = "Longitude";
    hidden var elev = "Elevation";

    function initialize()
    {
        DataField.initialize();
    }

    // https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/Activity/Info.html

    //! The given info object contains all the current workout
    //! information. Calculate a value and save it locally in this method.
    function compute(info)
    {
        if (Activity.Info.currentLocation  != null) {
         Sys.println("notnull");
        } else {
         Sys.println("NULL");
        }
        Sys.println("println");
        elev = "Called!";
        if (info.currentLocation != null) {
            Sys.println("INSIDE");
            # var s = info.currentLocation.toGeoString(2);
            # var a = splitGeoString(s);
            # lat = a[0];
            # lon = a[1];
            var m = info.altitude;
            var ft = m / 0.3048;
            elev = m.toNumber().toString() + "m = "
                + ft.toNumber().toString() + "ft";
        } else {
            elev = "No current location";
        }
    }

    function splitGeoString(s)
    {
        var c = s.toCharArray();
        var i = 0;
        var j = 0;

        /* The return value of toGeoString() looks like:

           N 38___53'52.30"W 94___46' 8.04"

           where the sequences marked here as "___" are "\356\202\260"
           which might be a mangled Garmin attempt to create a degree
           sign.  We scan the string to edit those parts out.
         */

        // Keep the leading ASCII characters.
        while (c[j].toNumber() < 127) {
            j += 1;
        }
        var lat = s.substring(i, j);

        // Completely skip the subsequent 8-bit characters, and
        // substitute a real degree symbol instead.
        while (c[j].toNumber() >= 127) {
            j += 1;
        }
        lat += "°";
        i = j;

        // The longitude will start with an "E" or "W", so keep reading
        // latitude characters only until we reach a character from the
        // alphabet tiers of ASCII.
        while (c[j].toNumber() < 64) {
            j += 1;
        }
        lat += s.substring(i, j);
        i = j;

        // Now, the same thing for longitude: start with ASCII characters.
        var lon = "";
        while (c[j].toNumber() < 127) {
            j += 1;
        }
        lon += s.substring(i, j);

        // Then skip the 8-bit characters, substituting a degree symbol.
        while (c[j].toNumber() >= 127) {
            j += 1;
        }
        lon += "°";
        i = j;

        // Finally, keep the rest of the string.
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
