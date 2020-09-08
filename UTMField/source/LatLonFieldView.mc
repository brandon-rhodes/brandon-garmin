using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class LatLonFieldView extends Ui.DataField
{
    hidden var zone = 12;
    hidden var easting1 = "-";
    hidden var easting2 = "--";
    hidden var easting3 = "---";
    hidden var northing1 = "--";
    hidden var northing2 = "--";
    hidden var northing3 = "---";
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
        if (info.currentLocation == null) {
            return;
        }
        var latlon = info.currentLocation.toDegrees();
        var Lat = latlon[0];
        var Lon = latlon[1];

        var m = info.altitude;
        var ft = m / 0.3048;
        elev = m.toNumber().toString() + "m = "
            + ft.toNumber().toString() + "ft";

        zone = Math.floor(Lon/6+31);

        /*
        THANK YOU to this Stack Overflow answer:
        https://stackoverflow.com/questions/176137/java-convert-lat-lon-to-utm
        */

        var Easting = 0.5*log((1+Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180))/(1-Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180)))*0.9996*6399593.62/Math.pow((1+Math.pow(0.0820944379, 2)*Math.pow(Math.cos(Lat*Math.PI/180), 2)), 0.5)*(1+ Math.pow(0.0820944379,2)/2*Math.pow((0.5*log((1+Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180))/(1-Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180)))),2)*Math.pow(Math.cos(Lat*Math.PI/180),2)/3)+500000;
        var Northing = (Math.atan(Math.tan(Lat*Math.PI/180)/Math.cos((Lon*Math.PI/180-(6*zone -183)*Math.PI/180)))-Lat*Math.PI/180)*0.9996*6399593.625/Math.sqrt(1+0.006739496742*Math.pow(Math.cos(Lat*Math.PI/180),2))*(1+0.006739496742/2*Math.pow(0.5*log((1+Math.cos(Lat*Math.PI/180)*Math.sin((Lon*Math.PI/180-(6*zone -183)*Math.PI/180)))/(1-Math.cos(Lat*Math.PI/180)*Math.sin((Lon*Math.PI/180-(6*zone -183)*Math.PI/180)))),2)*Math.pow(Math.cos(Lat*Math.PI/180),2))+0.9996*6399593.625*(Lat*Math.PI/180-0.005054622556*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+4.258201531e-05*(3*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2))/4-1.674057895e-07*(5*(3*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2))/4+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2)*Math.pow(Math.cos(Lat*Math.PI/180),2))/3);

        var Letter = 'N';
        if (Lat < 0) {
            Letter = 'S';
            Northing = Northing + 10000000;
        }

        var e = Easting.format("%06d");
        easting1 = e.substring(0, 1);
        easting2 = e.substring(1, 3);
        easting3 = e.substring(3, 6);

        var n = Northing.format("%07d");
        northing1 = n.substring(0, 2);
        northing2 = n.substring(2, 4);
        northing3 = n.substring(4, 7);
    }

    function log(n)
    {
        return Math.log(n, 2.7182818284590452353602);
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    function onUpdate(dc)
    {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.clear();

        var xmid = dc.getWidth() / 2;
        var ymid = dc.getHeight() / 2;
        var R = Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER;
        var L = Gfx.TEXT_JUSTIFY_LEFT  | Gfx.TEXT_JUSTIFY_VCENTER;

        dc.drawText(xmid - 22, ymid - 19, Gfx.FONT_TINY,
                    "Z" + zone.format("%d"), R);

        dc.drawText(xmid - 12, ymid - 19, Gfx.FONT_TINY, easting1, R);
        dc.drawText(xmid + 10, ymid - 20, Gfx.FONT_MEDIUM, easting2, R);
        dc.drawText(xmid + 16, ymid - 19, Gfx.FONT_TINY, easting3 + " E", L);

        dc.drawText(xmid - 12, ymid, Gfx.FONT_TINY, northing1, R);
        dc.drawText(xmid + 10, ymid - 1, Gfx.FONT_MEDIUM, northing2, R);
        dc.drawText(xmid + 16, ymid, Gfx.FONT_TINY, northing3 + " N", L);

        dc.drawText(xmid, ymid + 17, Gfx.FONT_TINY,
        elev, (Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER));
    }
}
