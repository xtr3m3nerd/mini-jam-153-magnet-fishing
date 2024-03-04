#!/bin/bash

# Clean up old
rm ./linux/*
rm ./windows/*
rm ./html/*
rm ./*.zip

GAMENAME="magna_fisher"

cd ..
godot --headless --export-debug "Linux/X11" ./build/linux/$GAMENAME.x86-64
godot --headless --export-debug "Windows Desktop" ./build/windows/$GAMENAME.exe
godot --headless --export-debug "Web" ./build/html/index.html
cd build


cd linux
zip -r ../$GAMENAME_linux.zip ./*
cd ../windows
zip -r ../$GAMENAME_windows.zip ./*
cd ../html
zip -r ../$GAMENAME_html.zip ./*
cd ..

