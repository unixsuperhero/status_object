#!/bin/bash

# echo
# echo
# echo 'OLD WAY:'
# echo
# echo

# echo 'find lib -type f' | zsh | cat -t | gsed 's/.[^0-9]*[0-9]*;/$> /g' | egrep -o '[^\^]+' | sed 's/^G//' | gtac | grep -v 'status_object:' | while read f; do echo; printf '# ------- %s -------\n' $f; echo; cat $f; echo; done | sed '/^require_relative [^[:space:]]key_value/d' | tee dist/rails/app/tools/key_value.rb

# echo
# echo
# echo 'NEW WAY:'
# echo
# echo

find lib -type f | grep -v 'enum_type' | gtac | while read f; do echo; printf '# ------- %s -------\n' $f; echo; cat $f; echo; done | sed '/^require_relative [^[:space:]]key_value/,/^$/d' | tee dist/rails/app/tools/enum_object.rb

