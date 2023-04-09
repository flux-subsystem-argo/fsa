source ./VERSION

bash -x ./init-gitops-engine.sh

pushd .
git clone https://github.com/argoproj/argo-cd
cd argo-cd
git checkout -b workspace ${BASE_VERSION}
stg init
stg import -t --series ../patches-argo-cd/series
stg_version_output=$(stg --version | grep -i stacked | head -n 1)
if [ "$stg_version_output" == "Stacked Git 2.2.2" ]; then
	# for stg 2.2.2
	SERIES=$(stg series --color never --all -P)
	echo "$SERIES" | while read -r line; do
	    cleaned_line=$(echo "$line" | sed -e 's/^[0-9]*-//')
	    stg rename $line $cleaned_line
	done
fi

mv ../gitops-engine .
popd
