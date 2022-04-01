(cd gitops-engine && stg push --all || stg export -n -p -d ../patches-gitops-engine)
(cd argo-cd       && stg push --all || stg export -n -p -d ../patches-argo-cd)
