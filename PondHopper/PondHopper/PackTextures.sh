#! /bin/sh

TP=/usr/local/bin/TexturePacker
#TP=~/Programming/TexturePacker/development/main-gui-build/source/app/TexturePacker.app/Contents/MacOS/TexturePacker

if [ "${ACTION}" = "clean" ]
then
	echo "cleaning..."
	rm ${SRCROOT}/Resources/sheet.png
	rm ${SRCROOT}/Resources/sheet.plist	

	rm ${SRCROOT}/Resources/sheet-hd.png
	rm ${SRCROOT}/Resources/sheet-hd.plist
else
	echo "building..."

	# create hd assets
	${TP} --smart-update ${SRCROOT}/PondHopper/assets/*.png \
          --format cocos2d \
		  --no-trim \
		  --shape-padding 2 \
          --data ${SRCROOT}/PondHopper/Resources/sheet-hd.plist \
          --sheet ${SRCROOT}/PondHopper/Resources/sheet-hd.png

	# create sd assets from same sprites
	${TP} --smart-update --scale 0.5 ${SRCROOT}/PondHopper/assets/*.png \
          --format cocos2d \
		  --no-trim \
		  --shape-padding 2 \
          --data ${SRCROOT}/PondHopper/Resources/sheet.plist \
          --sheet ${SRCROOT}/PondHopper/Resources/sheet.png
fi
exit 0