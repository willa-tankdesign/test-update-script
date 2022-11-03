#!/bin/bash

# ------ COLORS ------
RED='\033[0;31m'
ORANGE='\033[0;33m'
LIGHTBLUE='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'
# --------------------

LOCAL_FILE_PATHS=( "test.MD" )
PANTHEON_FILE_PATHS=( "test/test.MD" )

git checkout master
if ! git config remote.test-2.url > /dev/null; then
    echo "${ORANGE}No remote pantheon repository found.${NC}"
    echo "${GREEN}Adding remote pantheon repo...${NC}"
    git remote add test-2 git@github.com:willa-tankdesign/test-2.git
else
    echo "${GREEN}Remote pantheon repo found!${NC}"
fi

git fetch test-2

for idx in ${!LOCAL_FILE_PATHS[@]}
do
    echo "${LIGHTBLUE}Checking for changes to: $path${NC}"
    git diff HEAD:"${LOCAL_FILE_PATHS[$idx]}" test-2/master:"${PANTHEON_FILE_PATHS[$idx]}" > mypatch.patch
    git apply -p1 mypatch.patch
    RESULT=$?

    if [ "$RESULT" == "0" ]; then
      echo "${GREEN}Check on $path check complete.${NC}"
    else
      echo "${RED}ERROR: Cannot do diff on $path${NC}" 1>&2
      exit 1
    fi
done

echo "${GREEN}Check on pantheon files complete.${NC}"