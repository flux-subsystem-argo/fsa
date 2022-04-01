VERSION=$(cat VERSION)

(cd argo-cd && IMAGE_NAMESPACE=ghcr.io/flux-subsystem-argo/fsa IMAGE_TAG=$VERSION DOCKER_PUSH=true make image)
