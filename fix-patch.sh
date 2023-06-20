#!/bin/bash

INDEX=$(printf "%02d" $1)
# index is like 01, 02, 03

# lookup patch from index for example: ../patches-argo-cd/05-a-b-c-d.patch
PATCH="../patches-argo-cd/${INDEX}-*.patch"

COMMIT_MESSAGE=$(cat $PATCH | head -1)

# do commit and convert into stg patch
git commit -s -am "${COMMIT_MESSAGE}"
stg repair

# double check
stg series
