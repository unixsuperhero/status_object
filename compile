#!/bin/bash

echo 'find lib -type f' | zsh | cat -t | gsed 's/.[^0-9]*[0-9]*;/$> /g' | egrep -o '[^\^]+' | sed 's/^G//' | gtac | grep -v 'status_object:' | while read f; do echo; printf '# ------- %s -------\n' $f; echo; cat $f; echo; done | tee dist/rails/app/tools/key_value.rb

