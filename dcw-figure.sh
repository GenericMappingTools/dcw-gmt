#!/bin/sh
# Make a single global figure with DCW-GMT

ps=dcw-figure.ps
here=`pwd`
grep -v '^#' dcw-countries.txt > /tmp/$$.C.txt
n_poly=`gmt info -Fi -o2 /tmp/$$.C.txt`
gmt makecpt -T0/$n_poly/1 -Ccategorical -N > /tmp/$$.cpt
paste /tmp/$$.cpt /tmp/$$.C.txt > /tmp/$$.txt
grep -v '^#' dcw-states.txt | awk '{printf "%s.%s\n", $1, $2}' > /tmp/$$.S.txt
gmt psxy -Rg -JN0/9i -Xc -K -T > $ps
while read z color flag	continent country name; do
	echo "Adding ${country} $name"
	gmt pscoast -R -J -O -K -E${country}+g${color}+pfaint --DIR_DCW=$here >> $ps
done < /tmp/$$.txt
while read code; do
	echo "Adding ${code} boundary"
	gmt pscoast -R -J -O -K -E${code}+pfaint --DIR_DCW=$here >> $ps
done < /tmp/$$.S.txt
gmt psbasemap -R -J -O -B0 >> $ps
gmt psconvert -Tf -P -A $ps
gmt psconvert -TG -P -A -E72 -Z $ps
rm -f /tmp/$$.*
