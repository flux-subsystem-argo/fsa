pushd .
git clone https://github.com/argoproj/gitops-engine
cd gitops-engine
git checkout -b workspace v0.5.2
stg init
stg import -t --series ../patches-gitops-engine/series
popd

pushd .
git clone https://github.com/argoproj/argo-cd
cd argo-cd
git checkout -b workspace v2.2.5
stg init
stg import -t --series ../patches-argo-cd/series
mv ../gitops-engine .
popd
