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
# get the commit message from the patch
COMMIT_MESSAGE=$(cat ../patches-argo-cd-v2.2/01<press tab> | head -1)

# check the commit message
echo $COMMIT_MESSAGE

# do commit and convert into stg patch
git commit -s -am "${COMMIT_MESSAGE}"
stg repair

# double check
stg series
```

Then we can export all patches.

```shell
cd ..
make export-patches
```

## Here's another example:

```shell
$ git apply -3 ../patches-argo-cd-v2.7/05-ui-show-kstatus-in-ui.patch
Applied patch to 'ui/src/app/applications/components/application-node-info/application-node-info.tsx' with conflicts.
U ui/src/app/applications/components/application-node-info/application-node-info.tsx

$ git status
On branch workspace
Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
        both modified:   ui/src/app/applications/components/application-node-info/application-node-info.tsx


... We then resolved conflicts


$ COMMIT_MESSAGE=$(cat ../patches-argo-cd-v2.7/05-ui-show-kstatus-in-ui.patch | head -1)
$ echo $COMMIT_MESSAGE
ui: show kstatus in ui

$ git commit -s -am "${COMMIT_MESSAGE}"
[workspace 71623a0b0] ui: show kstatus in ui
 1 file changed, 13 insertions(+)

$ stg repair
Reading commit DAG ... done
Creating 1 new patch ... 
  Creating patch ui-show-kstatus-in-ui from commit 71623a0b03bcfb0b39fae3090cc1a365f2c22e76
done
Checking patch appliedness ... 
  ui-show-kstatus-in-ui is now applied
done

$ stg series
+ build-with-local-gitops-engine
+ implement-loopback
+ allow-flux-and-oci-schemes
+ ui-fix-find-leaf-pod-bug
> ui-show-kstatus-in-ui


... We continud with the remaining patches

$ stg import -t ../patches-argo-cd-v2.7/06-show-custom-info.patch
Checking for changes in the working directory ... done
Importing patch "show-custom-info" ... done
Now at patch "show-custom-info"

$ stg import -t ../patches-argo-cd-v2.7/07-ui-add-resource-icons.patch
Checking for changes in the working directory ... done
Importing patch "ui-add-resource-icons" ... done
Now at patch "ui-add-resource-icons"

$ stg import -t ../patches-argo-cd-v2.7/08-ui-implement-health-checks-and.patch
Checking for changes in the working directory ... done
Importing patch "ui-implement-health-checks-and" ... done
Now at patch "ui-implement-health-checks-and"

$ stg import -t ../patches-argo-cd-v2.7/09-auto-create-flux-resources.patch
Checking for changes in the working directory ... done
Importing patch "auto-create-flux-resources" ... done
Now at patch "auto-create-flux-resources"

$ stg import -t ../patches-argo-cd-v2.7/10-add-flux-options-to-the-ui.patch
Checking for changes in the working directory ... done
Importing patch "add-flux-options-to-the-ui" ... done
Now at patch "add-flux-options-to-the-ui"

$ stg import -t ../patches-argo-cd-v2.7/11-support-helm-oci-and.patch
Checking for changes in the working directory ... done
Importing patch "support-helm-oci-and" ... done
Now at patch "support-helm-oci-and"

... Now it broke at patch no 12

$ stg import -t ../patches-argo-cd-v2.7/12-change-logo-to-flamingo.patch
Checking for changes in the working directory ... done
Importing patch "change-logo-to-flamingo" ... error: patch failed: ui/src/app/sidebar/sidebar.tsx:47
error: ui/src/app/sidebar/sidebar.tsx: patch does not apply
stg import: Diff does not apply cleanly


... Let's git apply -3


$ git apply -3 ../patches-argo-cd-v2.7/12-change-logo-to-flamingo.patch
Applied patch to 'ui/src/app/login/components/login.scss' cleanly.
Applied patch to 'ui/src/app/login/components/login.tsx' cleanly.
Applied patch to 'ui/src/app/sidebar/sidebar.tsx' with conflicts.
Applied patch to 'ui/src/assets/images/argo.png' cleanly.
Applied patch to 'ui/src/assets/images/argo_o.svg' cleanly.
Applied patch to 'ui/src/assets/images/argologo.svg' cleanly.
Falling back to direct application...
U ui/src/app/sidebar/sidebar.tsx

$ git status
On branch workspace
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   ui/src/app/login/components/login.scss
        modified:   ui/src/app/login/components/login.tsx
        modified:   ui/src/assets/images/argo.png
        modified:   ui/src/assets/images/argo_o.svg
        modified:   ui/src/assets/images/argologo.svg
        new file:   ui/src/assets/images/flamingo.png

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
        both modified:   ui/src/app/sidebar/sidebar.tsx

... We then fix to resolve conflicts again, then commit

$ COMMIT_MESSAGE=$(cat ../patches-argo-cd-v2.7/12-change-logo-to-flamingo.patch | head -1)                                                                                                                           
$ git commit -s -am "${COMMIT_MESSAGE}"
[workspace b04e1fe44] change logo to flamingo
 7 files changed, 261 insertions(+), 26 deletions(-)
 create mode 100644 ui/src/assets/images/flamingo.png

$ stg repair
Reading commit DAG ... done
Creating 1 new patch ... 
  Creating patch change-logo-to-flamingo from commit b04e1fe44e569996319e04755593bca02bd74bdf
done
Checking patch appliedness ... 
  change-logo-to-flamingo is now applied
done

$ stg import -t ../patches-argo-cd-v2.7/13-add-open-in-weave-gitops.patch 
Checking for changes in the working directory ... done
Importing patch "add-open-in-weave-gitops" ... done
Now at patch "add-open-in-weave-gitops"

$ stg import -t ../patches-argo-cd-v2.7/14-upgrade-to-flux-v2-0-0-rc-1.patch 
Checking for changes in the working directory ... done
Importing patch "upgrade-to-flux-v2-0-0-rc-1" ... done
Now at patch "upgrade-to-flux-v2-0-0-rc-1"

$ stg import -t ../patches-argo-cd-v2.7/15-fix-branch-and-rev-info-of.patch 
Checking for changes in the working directory ... done
Importing patch "fix-branch-and-rev-info-of" ... done
Now at patch "fix-branch-and-rev-info-of"

$ cd ..
$ make export-patches
```
