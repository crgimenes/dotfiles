#!/bin/bash
for f in $(find . -name '*.png')
do
    convert "$f" "${f/\.png/.webp}"
done
