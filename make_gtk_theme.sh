#!/bin/bash

set -e
set -x

current_dir=$(pwd)
work_dir=$(mktemp -d --suffix=gtktheme)
cd $work_dir

download_and_extract() {
    local url="$1"
    local filename="${url##*/}"

    wget -q "$url" -O "$filename" || { echo "Failed to download $filename"; exit 1; }
    sha256sum "$filename"
    tar -xf "$filename"
    rm "$filename"
}

ADAWAITA_VERSION=47.0
ADAWAITA_URL="https://download.gnome.org/sources/adwaita-icon-theme/47/adwaita-icon-theme-${ADAWAITA_VERSION}.tar.xz"
download_and_extract $ADAWAITA_URL "adwaita-icon-theme-${ADAWAITA_VERSION}.tar.xz"
mkdir -p gtk-themes/share/icons
mv adwaita-icon-theme-${ADAWAITA_VERSION}/Adwaita gtk-themes/share/icons || { echo "Failed to move adwaita-icon-theme"; exit 1; }

GTK_VER=3.24.48
GTK_URL="https://download.gnome.org/sources/gtk/3.24/gtk-$GTK_VER.tar.xz"
download_and_extract $GTK_URL "gtk-$GTK_VER.tar.xz"
cd gtk-$GTK_VER/gtk/theme/Adwaita || { echo "Failed to cd into Adwaita"; exit 1; }
./parse-sass.sh
if [ ! -f gtk-contained.css ]; then
    echo "Error: gtk-contained.css not found"
    exit 1
fi
cd $work_dir
mkdir -p gtk-themes/share/themes/Adwaita/gtk-3.0
mv gtk-$GTK_VER/gtk/theme/Adwaita/gtk-contained.css gtk-themes/share/themes/Adwaita/gtk-3.0/gtk.css

GNOME_THEMES_VER=3.28
GTKTHEMES_URL="https://download.gnome.org/sources/gnome-themes-extra/3.28/gnome-themes-extra-$GNOME_THEMES_VER.tar.xz"
download_and_extract $GTKTHEMES_URL "gnome-themes-extra-${GNOME_THEMES_VER}.tar.xz"
mkdir -p gtk-themes/share/icons/HighContrast
rm gnome-themes-extra-${GNOME_THEMES_VER}/themes/HighContrast/icons/scalable/Makefile.am
mv gnome-themes-extra-${GNOME_THEMES_VER}/themes/HighContrast/icons/scalable gtk-themes/share/icons/HighContrast || { echo "Failed to move HighContrast icons"; exit 1; }

7za a -tzip -mx=9 -mfb=258 -mpass=15 "$current_dir/gtk-themes.zip" gtk-themes
du -b "$current_dir/gtk-themes.zip"
sha256sum "$current_dir/gtk-themes.zip"
