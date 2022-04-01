pushd .
git clone https://github.com/argoproj/gitops-engine
cd gitops-engine
git checkout -b workspace v0.5.5
stg init
stg import -t --series ../patches-gitops-engine/series
popd
