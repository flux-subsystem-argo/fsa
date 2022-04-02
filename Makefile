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
