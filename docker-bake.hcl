target "docker-metadata-action" {}

target "build" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm", "linux/arm64"]
#  cache-from = ["type=gha"]
#  cache-to = ["type=gha,mode=max"]
}
