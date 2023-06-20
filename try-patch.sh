#!/bin/bash

INDEX=$(printf "%02d" $1)
# index is like 01, 02, 03

# lookup patch from index for example: ../patches-argo-cd/05-a-b-c-d.patch
PATCH="../patches-argo-cd/${INDEX}-*.patch"

git apply -3 $PATCH
git diff
git status
