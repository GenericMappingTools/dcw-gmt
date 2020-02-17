#	Makefile for DCW Master Data Files
#
#	This Makefile helps build the dcw-gmt.nc file from DCW data.
#	When done, clean out directory with "make spotless".
#
#	The following products can be built:
#
#	dcw-gmt-<version>.tar.gz	NetCDF file for GMT using netcdf 4
#	dcw-gmt-<version>.zip		NetCDF file for GMT using netcdf 4 [zip]
#
#	Normal sequence of events would be:
#	make build-dcw archive checksum
#
#	Author:	Paul Wessel, SOEST, U. of Hawaii
#
#	Update Date:	2-JAN-2019
#
#
# NOTES:
#	1. To add new countries:
#	   a) obtain ascii data
#	   b) determine ISO 2-char code XX and name file XX.txt
#	   c) determine which continent ZZ it belongs to and place in ZZ dir
#	   d) add to svn with svn add ZZ/XX.dat
#	   e) add new entry in dcw-countries.txt in alphabetical position on XX. 
#	2. To add new state boundaries
#	   a) obtain ascii data
#	   b) determine ISO 2-char country code XX and state code YY and name file YY.txt
#	   c) determine which continent ZZ it belongs to and place in ZZ/YY dir
#	   d) add to svn with svn add ZZ/YY/XX.dat
#	   e) add new entry in dcw-states.txt in alphabetical position on XX, then YY.
#	3. To remove countries or states:
#	   a) remove from svn with svn remove <path to file>
#	   b) remove the corresponding entry in dcw-countries.txt or dcw-states.txt
#	4. After svn operations, make sure to commit with svn commit -m "short explanation"
#
#-------------------------------------------------------------------------------
#	!! STOP EDITING HERE, THE REST IS FIXED !!
#-------------------------------------------------------------------------------

include config.mk		# Release settings - edit these for each new release
# Prefix of tar/zip balls:
TAG	= dcw-gmt
#-------------------------------------------------------------------------------

help::
		@grep '^#!' Makefile | cut -c3-
#!-------------------- MAKE HELP FOR GSHHS+WDBII --------------------
#!
#!make <target>, where <target> can be:
#!
#!build-dcw       : Make the dcw-gmt.nc netCDF file
#!tar-dcw         : Create tarball of DCW for GMT distribution (deflated netCDF-4)
#!zip-dcw         : Create zipfile of DCW for GMT distribution (deflated netCDF-4)
#!archive         : Do both tar-dcw and zip-dcw
#!checksum        : Compute MD5 checksum for the tar.gz file
#!place-dcw       : Uses scp to copy the files over to SOEST DCW ftp site
#!place-gmt       : Uses scp to copy the files over to SOEST GMT ftp site
#!fig             : Create the dcw-figure.{pdf,png} files
#!spotless        : Clean up and remove created files of all types
#!all             : do all of build-dcw tar-dcw zip-dcw checksum fig
#!
#!	Remember to change DCW_VERSION in config.mk when building a new release
#!

spotless:	clean
		rm -rf $(TAG).cdl $(TAG).nc $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION).tar.* dcw-figure.p* gmt.history gmt.conf

clean:
		rm -f $(TAG).log

all:		build-dcw tar-dcw zip-dcw checksum

checksum:
		md5 -r $(TAG)-$(DCW_VERSION).tar.gz | awk '{printf "Update $(TAG).info with the new check sum: %s\n", $$1}'

archive:	tar-dcw zip-dcw

tar-dcw:
		echo "make $(TAG)-$(DCW_VERSION).tar.gz"
		rm -f $(TAG)-$(DCW_VERSION).tar.gz
		rm -rf $(TAG)-$(DCW_VERSION)
		mkdir -p $(TAG)-$(DCW_VERSION)
		cp -f $(TAG).nc dcw-countries.txt dcw-states.txt COPYING.LESSERv3 COPYINGv3 LICENSE.TXT README.TXT ChangeLog $(TAG)-$(DCW_VERSION)
		chmod -R og+r $(TAG)-$(DCW_VERSION)
		COPYFILE_DISABLE=true $(GNUTAR) --owner 0 --group 0 --mode a=rX,u=rwX -czhvf $(TAG)-$(DCW_VERSION).tar.gz $(TAG)-$(DCW_VERSION)
		rm -rf $(TAG)-$(DCW_VERSION)
		chmod og+r $(TAG)-$(DCW_VERSION).tar.gz

zip-dcw:
		echo "make $(TAG)-$(DCW_VERSION).zip"
		rm -f $(TAG)-$(DCW_VERSION).zip
		mkdir -p $(TAG)-$(DCW_VERSION)
		cp -f $(TAG).nc dcw-countries.txt dcw-states.txt COPYING.LESSERv3 COPYINGv3 LICENSE.TXT README.TXT ChangeLog $(TAG)-$(DCW_VERSION)
		chmod -R og+r $(TAG)-$(DCW_VERSION)
		zip -r -9 -q $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION)/$(TAG).nc
		zip -r -9 -q -g -l $(TAG)-$(DCW_VERSION).zip \
			$(TAG)-$(DCW_VERSION)/dcw-countries.txt \
			$(TAG)-$(DCW_VERSION)/dcw-states.txt \
			$(TAG)-$(DCW_VERSION)/COPYING.LESSERv3 \
			$(TAG)-$(DCW_VERSION)/COPYINGv3 \
			$(TAG)-$(DCW_VERSION)/LICENSE.TXT \
			$(TAG)-$(DCW_VERSION)/README.TXT \
			$(TAG)-$(DCW_VERSION)/ChangeLog
		rm -rf $(TAG)-$(DCW_VERSION)
		chmod og+r $(TAG)-$(DCW_VERSION).zip

place-gmt:
		scp $(TAG)-$(DCW_VERSION).tar.gz $(GMT_FTPSITE)

place-dcw:
		scp $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION).tar.gz $(DCW_FTPSITE)
		scp $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION).tar.gz $(DCW_WEBSITE)
		scp dcw-figure.png /Volumes/MacNutRAID/UH/RESEARCH/CVSPROJECTS/www/dcw
		scp ChangeLog /Volumes/MacNutRAID/UH/RESEARCH/CVSPROJECTS/www/dcw/ChangeLog.txt

fig:
		dcw-figure.sh

#-------------------------------------------------------------------------------
#	Data activities
#-------------------------------------------------------------------------------

build-dcw:	$(TAG).nc

$(TAG).nc:
		time sh DCW2singleshortnc.sh $(DCW_VERSION)
