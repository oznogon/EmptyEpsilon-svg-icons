#!/bin/bash
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <svg-dir> <size> [output-dir]"
    echo ""
    echo "Uses Inkscape to export all SVG files in <svg-dir> to PNG files at <size>px wide."
    echo "Height is auto-scaled to preserve aspect ratio."
    echo ""
    echo "If no output directory is given, this writes a PNG alongside each SVG."
    echo ""
    echo "Examples:"
    echo "  $0 EmptyEpsilon-svg-icons/crew 128"
    echo "  $0 EmptyEpsilon-svg-icons/radar 256 output-pngs"
    exit 1
fi

svg_dir="$1"
size="$2"
out_dir="${3:-}"

if [ ! -d "$svg_dir" ]; then
    echo "Error: directory '$svg_dir' not found" >&2
    exit 1
fi

shopt -s nullglob
svgs=("$svg_dir"/*.svg)

if [ ${#svgs[@]} -eq 0 ]; then
    echo "No SVG files found in '$svg_dir'" >&2
    exit 1
fi

echo "Exporting ${#svgs[@]} SVGs at ${size}px wide from '$svg_dir'..."

for svg in "${svgs[@]}"; do
    base="$(basename "$svg" .svg)"

    if [ -n "$out_dir" ]; then
        mkdir -p "$out_dir"
        png="$out_dir/$base.png"
    else
        png="$(dirname "$svg")/$base.png"
    fi

    inkscape --export-filename="$png" --export-width="$size" --export-area-page "$svg"
    echo "  $base.png"
done

echo "Done."
