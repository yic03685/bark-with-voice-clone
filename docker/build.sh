# --no-cache \
DOCKER_BUILDKIT=0
docker build --ssh \
  github=./.ssh/id_ed25519 \
  --progress=plain \
  -t yic/bark_rvc \
  .
