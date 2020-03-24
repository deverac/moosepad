#!/bin/sh

# This will extract Mousepad source, apply patch, and build a .deb package. 

# Exit on error.
set -e

# The moosepad.diff file expects the directory name to be 'mousepad'.
SRCDIR=mousepad

rm -f moosepad.deb
rm -rf project/$SRCDIR
cd project



#
# Extract and apply patch.
#
tar -xzf mousepad-0.4.2.tar.gz
mv mousepad-0.4.2 $SRCDIR
git apply moosepad.diff



#
# Build.
#
cd $SRCDIR
./autogen.sh
make



#
# Create Debian package contents.
#
PKGDIR=moosepad
mkdir $PKGDIR
cd $PKGDIR

mkdir -p usr/bin/
cp ../mousepad/mousepad   usr/bin/moosepad
strip usr/bin/moosepad

mkdir -p usr/share/icons
cp ../../moosepad-text-editor.svg   usr/share/icons

mkdir -p usr/share/applications
DESKTOP=usr/share/applications/moosepad.desktop
touch $DESKTOP
echo [Desktop Entry]>> $DESKTOP
echo Name=Moosepad>> $DESKTOP
echo Comment=Simple Text Editor>> $DESKTOP
echo GenericName=Text Editor>> $DESKTOP
echo Exec=moosepad %F>> $DESKTOP
echo Icon=moosepad-text-editor>> $DESKTOP
echo Terminal=false>> $DESKTOP
echo StartupNotify=true>> $DESKTOP
echo Type=Application>> $DESKTOP
echo Categories=Utility\;TextEditor\;GTK\;>> $DESKTOP
echo MimeType=application/octet-stream\;>> $DESKTOP

mkdir -p DEBIAN
SZ=`du -s . | cut -f 1`
CONTROL=DEBIAN/control
touch $CONTROL
echo Package: moosepad>> $CONTROL
echo Version: 0.1>> $CONTROL
echo Section: custom>> $CONTROL
echo Priority: optional>> $CONTROL
echo Architecture: all>> $CONTROL
echo Essential: no>> $CONTROL
echo Installed-Size: $SZ>> $CONTROL
echo Maintainer: https://github.com/deverac/moosepad>> $CONTROL
echo Description: An enhancement to Mousepad>> $CONTROL
cd ..



#
# Build .deb package
#
# Setting timestamps is unneccessary and complexifies the build, but helps
# ensure that hashes (MD5, SHA, etc.) do not change between builds.
# The Thunar file manager displays timestamps of 0 as 'Unknown', so one second
# is added to timestamp.
TIMESTAMP="1970-01-01 00:00:01 +0000"
find $PKGDIR -exec touch -d "$TIMESTAMP" {} \;
dpkg-deb --root-owner-group --build $PKGDIR tmp.deb
DEBDIR=debdir
mkdir $DEBDIR
cd $DEBDIR
ar x ../tmp.deb
# For deb package, file order is critical. By default, ar sets timestamps
# to 0 and group/owner to 0.
DEBFILE=../../../moosepad.deb
ar -r $DEBFILE debian-binary control.tar.xz data.tar.xz 
touch -d "$TIMESTAMP" $DEBFILE

