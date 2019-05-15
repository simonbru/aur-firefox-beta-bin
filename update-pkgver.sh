#!/bin/bash -e

last_version() {
    curl -s https://brulhart.me/rss-bridge/\?action\=display\&bridge\=MozillaFirefoxReleasesBridge\&format\=JsonFormat \
    | jq -r '.items[0].title' || true
}

cd "$(dirname "$0")/.."
git pull
echo Last Revisions:
git log --format=oneline | head -n3
echo
preselection="$(last_version)"
echo 'Next version number:'
read -e -i "$preselection" version
sed -i "s/pkgver=.*/pkgver=${version}/"  PKGBUILD
sed -i "s/pkgrel=.*/pkgrel=1/"  PKGBUILD
updpkgsums
makepkg --printsrcinfo > .SRCINFO
git commit PKGBUILD .SRCINFO -m "Upgpkg: ${version}"

