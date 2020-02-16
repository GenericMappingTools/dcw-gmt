# DCW-GMT: The Digital Chart of the World for GMT

![GitHub release (latest by date)](https://img.shields.io/github/v/release/GenericMappingTools/gmt-dcw)
![GitHub](https://img.shields.io/github/license/GenericMappingTools/gmt-dcw)

This repository contains the data and scripts that maintain and build
the gmt-dcw package used by **GMT 5 or later**.

## About

The Digital Chart of the World is a comprehensive 1:1,000,000 scale
vector basemap of the world. The charts were designed to meet the needs
of pilots and air crews in medium-and low-altitude en route navigation
and to support military operational planning, intelligence briefings,
and other needs. For basic background information about DCW, see the
[Wikipedia entry](http://en.wikipedia.org/wiki/Digital_Chart_of_the_World).
The raw files used to build `gmt-dcw.nc` came from the Princeton University
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

## Download

You can download the latest gmt-dcw package from
[GitHub releases](https://github.com/GenericMappingTools/gmt-dcw)
or from the [GMT main site](https://www.generic-mapping-tools.org/download/).

## Usage

If you are building GMT from source then you should set the parameter
**DCW_ROOT** in the *cmake/ConfigUser.cmake* to point to the directory where
gmt-dcw.nc has been placed.  If you add this file later you can always
place it in your user **~/.gmt** directory or set the **DIR_DCW** parameter
in your *gmt.conf* settings.

Refer to the [GMT documentation](https://docs.generic-mapping-tools.org/latest/datasets/dcw.html) for more details about how to use the data in GMT.

## Changelog

The detailed changelog is available [here](ChangeLog).

## License

The project is distributed under the
[GNU Lesser General Public License](http://www.gnu.org/licenses/lgpl-3.0.html).
