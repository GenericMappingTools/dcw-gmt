#!/bin/bash
#	DCW2singleshortnc.sh
#
# Script to convert the 324 DCW text polygons to a single nc3 netCDF file.
# We use ncdeflate.sh to build a compressed nc4 version as well
# We create variables with the <code>_ prefix, e.g. NO_lon, NO_lat for
# the Norway polygons.  For the state boundries (e.g., Texas) we create
# a prefix like USTX_, USHI_, etc.  Each polygon range is scaled to fit 
# in a short integer so there are attributes with scales and bounding box
# for each country.
# PS: Sometimes the west point gets rounded wrong ends up being slightly
# west of the region's WEST boundary...  With lon-West < 0 we end up with
# a jump in longitude to the east.  See BR.TO dumped from pscoast.  This
# is true of many polygons.  Make a large global map to find which ones
# need an update.  Solution implemented was to (1) use FMOD instead of MOD
# since MOD sometimes left a 360 behind, and (2) After creating the positive
# increments we sometimes got -0 which looks odd so added a 0 MAX call to
# ensure all increments are positive definite and finally (3), since we
# are setting format to .14g we must FIRST convert the original files to
# a tmp file that has that precision before we use that precision when
# computing WEST and comparing to .1xg resolution files.  The difference
# would be enough to cause shits.  Finally, more troubles were
# reported which I wound had to do with longitudes not being 360 but only
# 359.99999999999 and hence were not FMOD back to 0.  Added check for things
# This close to 360 to be treated as 360 and hence give 0.
# When new files are added, make sure all polygons are EXPLICITLY closed
# since gmt command may enforce closure while awk does not...
#
# Paul Wessel, Jun 2018.

control_c()
# run if user hits control-c
{
  echo -en "\n*** Ouch! Exiting ***\n"
  rm -f *.cdl xformat.awk yformat.awk t.lis var.lis BB.txt tmp.txt
  exit $?
}

VERSION=$1
DATE=`grep DCW_DATE config.mk | awk '{print $NF}'`
if [ "X$DATE" = "X" ]; then
	DATE=`date +%Y-%b-%d`
fi

trap control_c SIGINT

# Set enough decimals to avoid bad rounding
rm -f gmt.conf
gmt set FORMAT_FLOAT_OUT %.14g

#find orig -name '*.txt' -print | grep MM.txt | sed -n -e 's/\.txt//gp '> t.lis
find orig -name '*.txt' -print | sed -n -e 's/\.txt//gp '> t.lis
awk '{print substr($1,8)}' t.lis | sed -e 'sB/BBg' > var.lis

# The xyformat.awk is a helper script to properly format
# the data sections of the CDL file.

cat << EOF > xyformat.awk
{
	if (NR == 1) { 
		printf "\t%s = 65535", name
		k = 1
	}
	else if (NR > 2) { 
		if ((k % 10) == 0)
			printf ",\n\t%s", val
		else
			printf ", %s", val
		k++
	}
	if (\$1 == ">")
		val = 65535
	else
		val = \$(COL)
}
END {
	printf ", %s;\n", val
}
EOF
rm -f dcw-gmt.log dim.cdl var.cdl data.cdl dcw-gmt.cdl
echo "Assembling dcw-gmt distribution v $VERSION $DATE"
echo "Build CDL..."
echo "netcdf DCW {    // DCW netCDF specification in CDL" > dcw-gmt.cdl
cat <<- EOF > dim.cdl
	dimensions:
EOF
cat <<- EOF > var.cdl
	variables:
		:title = "DCW-GMT - The Digital Chart of the World for the Generic Mapping Tools";
		:source = "Processed by the GMT Team, $DATE";
		:version = "$VERSION";
EOF
cat <<- EOF > data.cdl
	data:
EOF
k=0
while read prefix; do
	k=$((k+1))
	item=`basename $prefix`
	echo "$item : Converting"
	gmt convert -fg $prefix.txt > this.txt
	gmt info -fg -C this.txt > BB.txt
	west=`awk '{print $1}' BB.txt`
	east=`awk '{print $2}' BB.txt`
	xrange=`awk '{print $2-$1}' BB.txt`
	south=`awk '{print $3}' BB.txt`
	north=`awk '{print $4}' BB.txt`
	yrange=`awk '{print $4-$3}' BB.txt`
	xfact=`gmt math -Q 65535 $xrange DIV =`
	yfact=`gmt math -Q 65535 $yrange DIV =`
	echo "$item: west = $west east = $east xrange = $xrange xfact = $xfact south = $south north = $north yrange = $yrange yfact = $yfact" >> dcw-gmt.log
	gmt math -fig --IO_FIRST_HEADER=always --FORMAT_FLOAT_OUT=%.16g $prefix.txt -C0 $west SUB 360 ADD 360 FMOD DUP 359.99999999999 LT MUL -C1 $south SUB  -Ca 0 MAX = bad.txt
	gmt math -fig --IO_FIRST_HEADER=always $prefix.txt -C0 $west SUB 360 ADD 360 FMOD DUP 359.99999999999 LT MUL $xrange DIV 65534 MUL RINT -C1 $south SUB $yrange DIV 65534 MUL RINT -Ca 0 MAX = tmp.txt
	nd=`gmt info -Fi -o2 tmp.txt`
	ns=`gmt info -Fi -o1 tmp.txt`
	let n=$nd+$ns
	VAR=`sed -n ${k}p var.lis`
cat << EOF >> dim.cdl
		${VAR}_length = $n;
EOF
cat << EOF >> var.cdl
	ushort ${VAR}_lon(${VAR}_length);
		${VAR}_lon:valid_range = 0, 65535;
		${VAR}_lon:units = "0-65535";
		${VAR}_lon:min = $west;
		${VAR}_lon:max = $east;
		${VAR}_lon:scale = $xfact;
	ushort ${VAR}_lat(${VAR}_length);
		${VAR}_lat:valid_range = 0, 65535;
		${VAR}_lat:units = "0-65535";
		${VAR}_lat:min = $south;
		${VAR}_lat:max = $north;
		${VAR}_lat:scale = $yfact;
EOF
	awk -f xyformat.awk name="${VAR}_lon" COL=1 tmp.txt >> data.cdl
	awk -f xyformat.awk name="${VAR}_lat" COL=2 tmp.txt >> data.cdl
done < t.lis
cat dim.cdl >> dcw-gmt.cdl
cat var.cdl >> dcw-gmt.cdl
cat data.cdl >> dcw-gmt.cdl
cat <<- EOF >> dcw-gmt.cdl
}
EOF
echo "Generate netCDF4..."
rm -f dcw-gmt.nc dcw-gmt.nc.tmp
ncgen -b -k 3 -o dcw-gmt.nc.tmp -x dcw-gmt.cdl # make netcdf-4 file
nccopy -k 3 -d 9 -s dcw-gmt.nc.tmp dcw-gmt.nc  # deflate netcdf-4 file
rm -f dcw-gmt.nc.tmp
echo ""
if [ ! -f dcw-gmt.nc ]; then
   rm -f data.cdl dim.cdl var.cdl xyformat.awk t.lis var.lis BB.txt tmp.txt this.txt
   exit 1
else
   rm -f data.cdl dim.cdl var.cdl xyformat.awk t.lis var.lis BB.txt tmp.txt this.txt
   exit 0
fi
