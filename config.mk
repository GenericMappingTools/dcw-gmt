#
# Configuration for gmt-dcw distribution
#
# These are the default settings.  You can override them by supplying your
# own config.mk file which will take precedence.
# Paul Wessel, July 2018

# DCW data version to be released:
DCW_VERSION	= 1.1.4
DCW_DATE	= 2018-JUL-01
DCW_FTPSITE	= ftp.soest.hawaii.edu:/export/ftp1/ftp/pub/dcw
GMT_FTPSITE	= ftp.soest.hawaii.edu:/export/ftp1/ftp/pub/gmt
DCW_WEBSITE	= imina.soest.hawaii.edu:/export/imina2/httpd/htdocs/pwessel/dcw
# Point to GNU version of tar:
GNUTAR            = $(shell which gnutar || which gtar || which tar)
