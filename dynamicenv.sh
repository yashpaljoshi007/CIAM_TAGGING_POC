#!/bin/bash
ENV=$1
# testy -d build && cd build
export $(grep -v '^#' .env."${ENV}" | xargs )

# echo "ENV: $ENVIRONMENT"
# sed -i 's#environment: null#'"environment:"$ENVIRONMENT""'#g' public/env.js
# sed -i 's#pcf: null#'"pcf: "$PCF""'#g' public/env.js

# exec "$@"

# echo 'done'


# Recreate config file
rm -rf ./build/apps/groupretirement/withdrawal/env.js
touch ./build/apps/groupretirement/withdrawal/env.js

# Add assignment 
echo "window.env = {" >> ./build/apps/groupretirement/withdrawal/env.js

# Read each line in .env file
# Each line represents key=value pairs
while read -r line || [[ -n "$line" ]];
do
  # Split env variables by character `=`
  if printf '%s\n' "$line" | grep -q -e'='; then
    varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
    varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
  fi

  # Read value of current variable if exists as Environment variable
  value=$(printf '%s\n' "${!varname}")
  # Otherwise use value from .env file
  [[ -z $value ]] && value=${varvalue}
  
  # Append configuration property to JS file
  echo "  $varname: \"$value\"," >> ./build/apps/groupretirement/withdrawal/env.js
done < .env."${ENV}" 

echo "}" >> ./build/apps/groupretirement/withdrawal/env.js