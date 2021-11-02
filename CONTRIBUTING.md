# Contributing Guidelines

## Ground Rules

The goal is to maintain a diverse community that's pleasant for everyone.
**Please be considerate and respectful of others**.
Everyone must abide by our
[Code of Conduct](https://github.com/GenericMappingTools/gmt/blob/master/CODE_OF_CONDUCT.md)
and we encourage all to read it carefully.

## Building DCW-GMT

The original data in ASCII format are stored in the `orig` directory.

To build the `dcw-gmt.nc` file from the DCW data, you need to first edit the
configuration file [config.mk](config.mk), then run:

	make build-dcw		# Make the dcw-gmt.nc netCDF file
	make archive		# Create tarball and zipfile of DCW for GMT distribution
	make checksum		# Compute MD5 checksum for the tarball

When done, clean out the directory with `make spotless`.

## Adding new country or state boundaries

To add new countries:

1. obtain ascii data
2. determine [ISO 2-char country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) *XX*
   and name file *XX.txt*
3. determine which continent *ZZ* it belongs to and place in *ZZ* directory
4. add new entry in `dcw-countries.txt` in alphabetical position on *XX*

To add new state boundaries

1. obtain ascii data
2. determine [ISO 2-char country code]((https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)) *XX*
   and [state code](https://en.wikipedia.org/wiki/ISO_3166-2) *YY* and name file *YY.txt*
3. determine which continent *ZZ* it belongs to and place in *ZZ/YY* directory
4. add new entry in `dcw-states.txt` in alphabetical position on *XX*, then *YY*

To remove countries or states:

1. remove the data file
2. remove the corresponding entry in `dcw-countries.txt` or `dcw-states.txt`