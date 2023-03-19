# Development guide lines

## How to port patches across Argo CD versions

First, call `make init` to initialize the workspace branch and apply all patches.

```shell
make init
cd argocd
```

Import an individual patch, one by one, using the `stg import` command
For example, to port patches from v2.2 to v2.3, we would start with the following commands.

```shell
git checkout -b dev v2.3.7
stg init
stg import -t ../patches-argo-cd-v2.2/01<press tab>
```

If the applying process is failed, we have to use the `git apply -3` command to help apply the patch.
The git apply command will perform 3-way merge and put merge markings for us to resolve if conflicts happen.

```shell
git apply -3 ../patches-argo-cd-v2.2/01<press tab>
```

Example of a conflict. The "ours" marker is the base version (the upstream ArgoCD), the "theirs" marker is our patch.
```
<<<<<<< ours
		// If the length of revisions is not same as the length of sources,
		// we take the revisions from the sources directly for all the sources.
		if len(revisions) != len(sources) {
			revisions = make([]string, 0)
			for _, source := range sources {
				revisions = append(revisions, source.TargetRevision)
			}
		}

		targetObjs, manifestInfoMap, err = m.getRepoObjs(app, sources, appLabelKey, revisions, noCache, noRevisionCache, verifySignature, project)
		if err != nil {
			targetObjs = make([]*unstructured.Unstructured, 0)
			conditions = append(conditions, v1alpha1.ApplicationCondition{Type: v1alpha1.ApplicationConditionComparisonError, Message: err.Error(), LastTransitionTime: &now})
			failedToLoadObjs = true
=======
		if isFluxSubsystemEnabled(app) && app.Spec.Source.IsHelm() {
			targetObjs, conditions, failedToLoadObjs = m.getFluxHelmTargetObjects(app, conditions, now)
		} else if isFluxSubsystemEnabled(app) && !app.Spec.Source.IsHelm() {
			targetObjs, conditions, failedToLoadObjs = m.getFluxKustomizeTargetObjects(app, conditions, now)
		} else {
			targetObjs, manifestInfo, err = m.getRepoObjs(app, source, appLabelKey, revision, noCache, noRevisionCache, verifySignature, project)
			if err != nil {
				targetObjs = make([]*unstructured.Unstructured, 0)
				conditions = append(conditions, v1alpha1.ApplicationCondition{Type: v1alpha1.ApplicationConditionComparisonError, Message: err.Error(), LastTransitionTime: &now})
				failedToLoadObjs = true
			}
>>>>>>> theirs
```

After resolving conflicts, you can commit using the commit message of the original patch.
Then call `stg repair` to let Stg fix and create the new patch for us.

```shell
COMMIT_MESSAGE=$(cat ../patches-argo-cd-v2.2/01<press tab> | head -1)
git commit -s -am "${COMMIT_MESSAGE}"
stg repair
```

Then we can export all patches.

```shell
cd ..
make export-patches
```
