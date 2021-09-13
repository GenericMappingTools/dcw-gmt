#
# Configuration for dcw-gmt distribution
#
# These are the default settings.  You can override them by supplying your
# own config.mk file which will take precedence.
# Paul Wessel, April 2021

# DCW data version to be released:
GMT_VERSION	= 6.1.1
DCW_VERSION	= 2.0.1
DCW_DATE	= 2021-SEP-09
DCW_FTPSITE	= ftp.soest.hawaii.edu:/export/ftp1/ftp/pub/dcw
GMT_FTPSITE	= ftp.soest.hawaii.edu:/export/ftp1/ftp/pub/gmt
DCW_WEBSITE	= imina.soest.hawaii.edu:/export/imina2/httpd/htdocs/pwessel/dcw
# Point to GNU version of tar:
GNUTAR      = $(shell which gnutar || which gtar || which tar)
