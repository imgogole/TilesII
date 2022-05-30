#!/bin/bash
# Automatically update build to latest Linux one

set -eu

[[ -f .release ]] || echo "v0.0.0" > .release
LAST_RELEASE=$(cat .release)

# Grab latest release
RELEASE=$(gh release list | grep Linux | head -n 1 | awk -F'\t' '{print $3}')

if [[ "$RELEASE" == "$LAST_RELEASE" ]]; then
	echo "Déjà à jour. ($RELEASE)"
else
	# Add desktop entry for Tiles II
	cp tiles_ii.desktop ~/.local/share/applications/tiles_ii.desktop
	sed 's|$SCRIPT_DIR|'"$PWD"'|g' ~/.local/share/applications/tiles_ii.desktop -i

	rm .cache -rf
	mkdir -p .cache
	gh release download "$RELEASE" --dir .cache

	# Unzip and install the release
	cd .cache
	unzip *.zip
	chmod +x 'Tiles II.x86_64'
	rm "../Tiles II_Data" -rf
	mv "Tiles II_Data" "Tiles II.x86_64" ..
	cd ..

	echo "Mise à jour terminée. ($RELEASE)"
	echo "$RELEASE" > .release
fi
