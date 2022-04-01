bash -x ./init-gitops-engine.sh

pushd .
git clone https://github.com/argoproj/argo-cd
cd argo-cd
git checkout -b workspace v2.2.8
stg init
stg import -t --series ../patches-argo-cd/series
mv ../gitops-engine .
popd
