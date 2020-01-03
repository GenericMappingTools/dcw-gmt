# DCW - The Digital Chart of the World for GMT 5 or later

                Version 1.1.4 July 1, 2018
         Distributed under the Lesser GNU Public License

This is README.TXT for the DCW - The Digital Chart of the World
which is used to produce the gmt-dcw package currently used by
GMT's pscoast module.  For a description of changes between
releases, see the ChangeLog file.

The Digital Chart of the World is a comprehensive 1:1,000,000 scale
vector basemap of the world. The charts were designed to meet the needs
of pilots and air crews in medium-and low-altitude en route navigation
and to support military operational planning, intelligence briefings,
and other needs. For basic background information about DCW, see the
Wikipedia entry at http://en.wikipedia.org/wiki/Digital_Chart_of_the_World.
The raw files used to build gmt-dcw.nc came from the Princeton University
Digital Map and Geospatial Information Center, accessible via website
http://www.princeton.edu/~geolib/gis/dcw.html; however, the DCW access
seems to have disappeared.  Other sites with DCW data include the GeoCommunity
at http://data.geocomm.com/readme/dcw/dcw.html.

The gmt-dcw version has converted the (at present) 523 individual
polygon files to a single netCDF 4 file and compressed the data by
using rescaled short integer positioning. Note that many of these,
especially state boundaries for China, Russia, India, Argentina were
not in the original DCW but have been added later from other sources,
such as from http://www.gadm.org.

If you are building GMT from source then you should set the parameter
DCW_ROOT in the cmake/ConfigUser.cmake to point to the directory where
gmt-dcw.nc has been placed.  If you add this file later you can always
place it in your user ~/.gmt directory or set the DIR_DCW parameter in
your gmt.conf settings.
