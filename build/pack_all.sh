#!/bin/bash

rm linux/*
rm windows/*
rm html/*

cd ..
godot --headless --export-debug "Linux/X11" ./build/linux/test
cd build


rm ./*.zip
cd linux
zip -r ../magna_fisher_linux.zip ./*
cd ../windows
zip -r ../magna_fisher_windows.zip ./*
cd ../html
zip -r ../magna_fisher_html.zip ./*
cd ..

