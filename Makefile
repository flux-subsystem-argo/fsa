.PHONY: build-v22
build-v22:
	ln -s VERSION_22 VERSION
	ln -s patches-argo-cd-v2.2 patches-argo-cd
	make init
	make image
	unlink patches-argo-cd
	unlink VERSION

.PHONY: build-v23
build-v23:
	ln -s VERSION_23 VERSION
	ln -s patches-argo-cd-v2.3 patches-argo-cd
	make init
	make image
	unlink patches-argo-cd
	unlink VERSION

.PHONY: build-v24
build-v24:
	ln -s VERSION_24 VERSION
	ln -s patches-argo-cd-v2.4 patches-argo-cd
	make init
	make image
	unlink patches-argo-cd
	unlink VERSION

.PHONY: init
init:
	bash -x ./init.sh

.PHONY: init-gitops-engine
init-gitops-engine:
	bash -x ./init-gitops-engine.sh

.PHONY: image
image:
	bash -x ./build.sh

.PHONY: export-patches
export-patches:
	bash -x ./patch_export.sh
