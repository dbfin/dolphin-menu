#!/bin/bash --

function error() {
    [[ -z "$1" ]] || echo "$1"
    exit 1
}

d="$(readlink -f "$(dirname "$0")")"
d="${d%\/}"

d5="$(kf5-config --path services | grep -oP '([^:]*/\.local/[^:]*)')" || error 'Cannot determine the KDE5 services directory.'
d5="${d5%\/}"
echo 'KDE5 services directory: '$d5
[[ -d "$d5" ]] || mkdir "$d5/" || error "Cannot create $d5."

find "$d/services/" -type f -name '*.desktop' -print0 | while read -d '' f; do
    f="${f##*\/}"
    from="$d5/$f"
    to="$d/services/$f"
    echo -n "Creating link $from -> $to... "
    ln -sf "$to" "$from" || error 'cannot create the link.'
    echo 'done.'
done

mkdir -p ~/.local/bin
ln -sf "$d/meld_compare" ~/.local/bin/meld_compare
