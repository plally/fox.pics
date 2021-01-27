#!/bin/bash
rm -rf public
mkdir -p public/js
cp index.html public/index.html

elm make src/Main.elm --output public/js/main.js --optimize
uglifyjs public/js/main.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters=true,keep_fargs=false,unsafe_comps=true,unsafe=true,passes=2' --output public/js/main.js && uglifyjs public/js/main.js --mangle --output public/js/main.js

