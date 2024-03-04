#!/bin/bash

GAMENAME="magna_fisher"

# Clean up old
rm ./linux/*
rm ./windows/*
rm ./html/*
rm ./*.zip


cd ..
godot --headless --export-debug "Linux/X11" ./build/linux/magna_fisher.x86-64
godot --headless --export-debug "Windows Desktop" ./build/windows/magna_fisher.exe
godot --headless --export-debug "Web" ./build/html/index.html
cd build


cd linux
zip -r ../magna_fisher_linux.zip ./*
cd ../windows
zip -r ../magna_fisher_windows.zip ./*
cd ../html
zip -r ../magna_fisher_html.zip ./*
cd ..

