#!/bin/bash
"Flag suzen14 is: $(ls part1 ../john/*/* |egrep '^[0-9a-zA-Z]{9,10}' | tr -d '\n')"