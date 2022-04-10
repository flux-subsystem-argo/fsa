source ./VERSION

pushd .
git clone https://github.com/argoproj/gitops-engine
cd gitops-engine
git checkout -b workspace ${GITOPS_ENGINE_VERSION}
stg init
stg import -t --series ../patches-gitops-engine/series
popd
