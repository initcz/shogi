#!/bin/bash
cd ../public/img/
pwd
echo bishop.svg golden-general.svg king.svg knight.svg lance.svg pawn.svg rook.svg silver-general.svg | xargs -n 1 cp -f ../../graphics/pieces.svg
ls -l | grep .svg
