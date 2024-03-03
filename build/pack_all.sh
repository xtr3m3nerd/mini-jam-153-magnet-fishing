#!/bin/bash

rm ./*.zip
cd linux
zip -r ../magna_fisher_linux.zip ./*
cd ../windows
zip -r ../magna_fisher_windows.zip ./*
cd ../html
zip -r ../magna_fisher_html.zip ./*
cd ..

