# DCW-GMT: The Digital Chart of the World for GMT

![GitHub release (latest by date)](https://img.shields.io/github/v/release/GenericMappingTools/dcw-gmt)
![GitHub](https://img.shields.io/github/license/GenericMappingTools/dcw-gmt)

This repository contains the data and scripts that maintain and build
the dcw-gmt package used by **GMT 5 or later**.  **Note**: DCW 2.1.2
requires GMT 6.1.1 or later. Building the DCW netCDF database requires
the netCDF executables *ncgen* and *nccopy*, usually available in a port
called *netcdf-bin* or similar (i.e, separate from the netCDF library).

This README contains the documentation for DCW. For information about building
and modifying DCW, please refer to the [contributing guide](CONTRIBUTING.md).

![Global map of the DCW-GMT polygons](https://docs.generic-mapping-tools.org/6.2/_images/dcw-figure.png)

## About

The Digital Chart of the World is a comprehensive 1:1,000,000 scale
vector basemap of the world. The charts were designed to meet the needs
of pilots and air crews in medium- and low-altitude en route navigation
and to support military operational planning, intelligence briefings,
and other needs. For basic background information about DCW, see the
[Wikipedia entry](http://en.wikipedia.org/wiki/Digital_Chart_of_the_World).

DCW-GMT is an enhancement to DCW in a few ways:

1. It contains more state boundaries (the largest 8 countries are now represented).
2. The data have been reformatted to save space and are distributed as a single deflated netCDF-4 file.

## Download

You can download the latest dcw-gmt package from
[GitHub releases](https://github.com/GenericMappingTools/dcw-gmt/releases)
or from the [GMT main site](https://www.generic-mapping-tools.org/download/).

## Usage

DCW-GMT is an optional install for GMT and its wrappers.  If you did install it
then you can access the DCW data for plotting or analysis via GMT's
[coast](https://docs.generic-mapping-tools.org/latest/coast.html) module. You
can also use the [ISO 2-character codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
for countries as a way to specify map domains via the **-R** option.  For
instance, to make a map showing France with a region rounded to the nearest 2
degrees in longitude and latitude, you can run:

	gmt coast -RFR+r2 -Glightgray -B -pdf france

If in addition you want to paint the landmass of France blue, you can run:

	gmt coast -RFR+r2 -Glightgray -B -EFR+gblue -pdf france

To access states without countries you must use the *country.state* syntax. See
the [coast](https://docs.generic-mapping-tools.org/latest/coast.html)
documentation for details.  For instance, to make a map of the US and show Texas
and Mississippi as red states, try:

	gmt coast -RUS+r2 -Glightgray -B -EUS.TX,US.MS+gred -pdf us
	
### DCW Collections	

From versions 2.1.0 and GMT 6.4.0 onwards you can also use named regions (continents, seas, etc) using their names.
We offer 37 geographic regions based on [Natural Earth](https://www.naturalearthdata.com) at scale 1:110, 104 seas 
named (102 based on [IHO1953](https://epic.awi.de/id/eprint/29772/1/IHO1953a.pdf), most of them taken from 
[Fourcy and Lorvelec (2013)](https://www6.rennes.inrae.fr/ese_eng/HRMLOS)) and 57 lakes, islands and archipelagoes.
You can also use 46 collections of countries; 30 are from [UN49](https://unstats.un.org/unsd/methodology/m49/) 
and the rest were obtained from from [Wikipedia](https://en.wikipedia.org/wiki/Subregion). 
You can see the full list at [dcw-collections.txt](dcw-collections.txt). 
These allow you to make maps matching those regions, such as

	gmt coast -RScandinavia -Glightgray -B -pdf Scandinavia
	gmt coast -RIHO28 -Glightgray -B -pdf MediterraneanSea
	gmt coast -RSAM -Glightgray -B -pdf SouthAmerica
	gmt coast -RHMLY -Glightgray -B -pdf Himalayas

## Notes

If you are building GMT from source then you should set the parameter
**DCW_ROOT** in the *cmake/ConfigUser.cmake* to point to the directory where
*dcw-gmt.nc* has been placed.  If you add this file after GMT installation
was completed then you can always have GMT find it by placing it in your
user *~/.gmt* directory or by setting the **DIR_DCW** parameter in the
*gmt.conf* settings.

## Changelog

The detailed changelog is available [here](ChangeLog).

## License

The project is distributed under the
[GNU Lesser General Public License](http://www.gnu.org/licenses/lgpl-3.0.html).
