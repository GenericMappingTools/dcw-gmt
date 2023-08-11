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
#	make build-dcw archive checksums
#
#	Author:	Paul Wessel, SOEST, U. of Hawaii
#
#	Update Date:	18-JAN-2022
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
#!-------------------- MAKE HELP FOR DCW --------------------
#!
#!make <target>, where <target> can be:
#!
#!build-dcw         : Make the dcw-gmt.nc netCDF file
#!tar-dcw           : Create tarball of DCW for GMT distribution (deflated netCDF-4)
#!zip-dcw           : Create zipfile of DCW for GMT distribution (deflated netCDF-4)
#!archive           : Do both tar-dcw and zip-dcw
#!checksums         : Compute MD5 and SHA256 checksums for the tar.gz file
#!place-dcw         : Uses scp to copy the files over to SOEST DCW ftp site
#!place-gmt         : Uses scp to copy the files over to SOEST GMT ftp site
#!update-dataserver : Uses scp to copy the tar ball to oceania and installs latest version
#!fig               : Create the dcw-figure.{pdf,png} files
#!spotless          : Clean up and remove created files of all types
#!all               : do all of build-dcw tar-dcw zip-dcw checksums fig
#!
#!	Remember to change DCW_VERSION in config.mk before building a new release
#!  Once all files are built and uploaded to the servers, release the new version
#!  from the dcw-git repository.  Go to Releases and add a new one, upload the two files
#!  and refresh the checksums.
#!

spotless:	clean
		rm -rf $(TAG)-$(DCW_VERSION) $(TAG).cdl $(TAG).nc $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION).tar.* dcw-figure.p* gmt.history gmt.conf

clean:
		rm -f $(TAG).log

all:		build-dcw tar-dcw zip-dcw checksums fig

checksums:
		md5sum $(TAG)-$(DCW_VERSION).tar.gz        | awk '{printf "Update $(TAG).info with the new MD5 check sum: %s\n", $$1}'
		shasum -a 256 $(TAG)-$(DCW_VERSION).tar.gz | awk '{printf "Update $(TAG).info with the new SHA256 check sum: %s\n", $$1}'

archive:	tar-dcw zip-dcw

tar-dcw:
		echo "make $(TAG)-$(DCW_VERSION).tar.gz"
		rm -f $(TAG)-$(DCW_VERSION).tar.gz
		rm -rf $(TAG)-$(DCW_VERSION)
		mkdir -p $(TAG)-$(DCW_VERSION)
		cp -f $(TAG).nc dcw-collections.txt dcw-countries.txt dcw-states.txt LICENSE README.md ChangeLog $(TAG)-$(DCW_VERSION)
		echo $(DCW_VERSION) > $(TAG)-$(DCW_VERSION)/VERSION
		chmod -R og+r $(TAG)-$(DCW_VERSION)
		COPYFILE_DISABLE=true $(GNUTAR) --owner 0 --group 0 --mode a=rX,u=rwX -czhvf $(TAG)-$(DCW_VERSION).tar.gz $(TAG)-$(DCW_VERSION)
		rm -rf $(TAG)-$(DCW_VERSION)
		chmod og+r $(TAG)-$(DCW_VERSION).tar.gz

zip-dcw:
		echo "make $(TAG)-$(DCW_VERSION).zip"
		rm -f $(TAG)-$(DCW_VERSION).zip
		mkdir -p $(TAG)-$(DCW_VERSION)
		cp -f $(TAG).nc dcw-collections.txt dcw-countries.txt dcw-states.txt LICENSE README.md ChangeLog $(TAG)-$(DCW_VERSION)
		echo $(DCW_VERSION) > $(TAG)-$(DCW_VERSION)/VERSION
		chmod -R og+r $(TAG)-$(DCW_VERSION)
		zip -r -9 -q $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION)/$(TAG).nc
		zip -r -9 -q -g -l $(TAG)-$(DCW_VERSION).zip \
			$(TAG)-$(DCW_VERSION)/dcw-collections.txt \
			$(TAG)-$(DCW_VERSION)/dcw-countries.txt \
			$(TAG)-$(DCW_VERSION)/dcw-states.txt \
			$(TAG)-$(DCW_VERSION)/LICENSE \
			$(TAG)-$(DCW_VERSION)/VERSION \
			$(TAG)-$(DCW_VERSION)/README.md \
			$(TAG)-$(DCW_VERSION)/ChangeLog
		rm -rf $(TAG)-$(DCW_VERSION)
		chmod og+r $(TAG)-$(DCW_VERSION).zip

place-gmt:
		scp $(TAG)-$(DCW_VERSION).tar.gz $(GMT_FTPSITE)

place-dcw:
		scp $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION).tar.gz $(DCW_FTPSITE)
		scp $(TAG)-$(DCW_VERSION).zip $(TAG)-$(DCW_VERSION).tar.gz $(DCW_WEBSITE)
		scp dcw-figure.png $(DCW_WEBSITE)
		scp index.html $(DCW_WEBSITE)
		scp ChangeLog $(DCW_WEBSITE)/ChangeLog.txt

update-dataserver:
		# 1. Build a helper executable bash script called /tmp/dcw-update.sh
		bash build-serverupdate-script.sh $(DCW_VERSION) $(GMTSERVER_DIR)
		# 2. Copy script to server's tmp dir:
		scp /tmp/dcw-update.sh ${GMTSERVER_URL}:/tmp
		# 3. Run the dcw-update.sh script
		ssh ${GMTSERVER_URL} "bash /tmp/dcw-update.sh"
		# 4. Remove the local script copy
		rm -f /tmp/dcw-update.sh

fig:
		time bash dcw-figure.sh

#-------------------------------------------------------------------------------
#	Data activities
#-------------------------------------------------------------------------------

build-dcw:	$(TAG).nc

$(TAG).nc:
		time bash DCW2singleshortnc.sh $(DCW_VERSION) $(GMT_VERSION)
