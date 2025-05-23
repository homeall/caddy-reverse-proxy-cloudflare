group "default" {
  targets = ["main"]
}

target "main" {
  context = "."
  dockerfile = "./Dockerfile"
  platforms = ["linux/amd64", "linux/arm", "linux/arm64"]
  tags = []
  labels = {}
  push = true
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
}
