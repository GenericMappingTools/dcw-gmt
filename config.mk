#
# Configurations for dcw-gmt distribution
#
# These are the default settings.  You can override them by supplying your
# own config.mk file which will take precedence.
# Paul Wessel, August 2023

# Minimum required GMT version
GMT_VERSION	= 6.1.1
# DCW data version to be released
DCW_VERSION	= 2.1.2
DCW_DATE	= 2023-AUG-11
# Tarball placement for releases
DCW_FTPSITE	= ftp.soest.hawaii.edu:/export/ftp1/ftp/pub/dcw
GMT_FTPSITE	= ftp.soest.hawaii.edu:/export/ftp1/ftp/pub/gmt
DCW_WEBSITE	= imina.soest.hawaii.edu:/export/imina2/httpd/htdocs/pwessel/dcw
# GMT dataserver update directory
GMTSERVER_URL = oceania.generic-mapping-tools.org
GMTSERVER_DIR = /export/gmtserver/gmt/data/geography/dcw
# Point to GNU version of tar:
GNUTAR      = $(shell which gnutar || which gtar || which tar)
