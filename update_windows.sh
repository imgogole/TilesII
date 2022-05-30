#!/bin/bash
# Automatically update Windows build to run it with Wine

set -eu

[[ -f .release-wine ]] || echo "v0.0.0" > .release-wine
LAST_RELEASE=$(cat .release-wine)

# Grab latest release
RELEASE=$(gh release list | grep Windows | head -n 1 | awk -F'\t' '{print $3}')

if [[ "$RELEASE" == "$LAST_RELEASE" ]]; then
	echo "Déjà à jour. ($RELEASE)"
else
	# Add desktop entry for Tiles II Wine
	cp tiles_ii.desktop ~/.local/share/applications/tiles_ii_windows.desktop
	sed 's|$SCRIPT_DIR|'"$PWD"/wine'|g' ~/.local/share/applications/tiles_ii_windows.desktop -i
	sed 's/Tiles II/Tiles II Windows/g' ~/.local/share/applications/tiles_ii_windows.desktop -i

	rm .cache-win -rf
	mkdir -p .cache-win
	mkdir -p wine
	gh release download "$RELEASE" --dir .cache-win

	# Unzip and install the release
	cd .cache-win
	unzip *.zip
	rm "../wine/MonoBleedingEdge" "../wine/Tiles II_Data" -rf
	mv ./* ../wine/ -fu
	cd ..

	echo "Mise à jour terminée. ($RELEASE)"
	echo "$RELEASE" > .release-wine
fi
