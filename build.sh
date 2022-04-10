source ./VERSION
VERSION="${BASE_VERSION}-${SUFFIX_VERSION}"

(cd argo-cd && IMAGE_NAMESPACE=ghcr.io/flux-subsystem-argo/fsa IMAGE_TAG=$VERSION DOCKER_PUSH=true make image)
