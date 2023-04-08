source ./VERSION

pushd .
git clone https://github.com/argoproj/gitops-engine
cd gitops-engine
git checkout -b workspace ${GITOPS_ENGINE_VERSION}
stg init
stg import -t --series ../patches-gitops-engine/series
stg_version_output=$(stg --version | head -n 1)
if [ "$stg_version_output" == "Stacked Git 2.2.2" ]; then
	# for stg 2.2.2
	SERIES=$(stg series --color never --all -P)
	echo "$SERIES" | while read -r line; do
	    cleaned_line=$(echo "$line" | sed -e 's/^[0-9]*-//')
	    stg rename $line $cleaned_line
	done
if

popd
