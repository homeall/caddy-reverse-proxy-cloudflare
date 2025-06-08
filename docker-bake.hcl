# docker-bake.hcl
# Centralized Docker Build configuration

# Setting default group
group "default" {
  targets = ["build"]
}

# Importing metadata from other steps
target "docker-metadata-action" {}

# Setting building target
target "build" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "Dockerfile"

  # Multi-platform build
  platforms = [
    "linux/amd64",
    "linux/arm64",
    "linux/arm",
  ]

  # GitHub Actions cache
  cache-from = [
    "type=gha"
  ]
  cache-to = [
    "type=gha,mode=max"
  ]

  # Image labels
  labels = {
    "maintainer"           = "Homeall"
    "homeall.buymeacoffee" = "☕ Like this project? Buy me a coffee: https://www.buymeacoffee.com/homeall 😎"
    "homeall.easteregg"    = "🎉 You found the hidden label! Have a nice day. 😎"
  }
  # Image annotation
  annotations = [
    "maintainer"           = "Homeall"
    "homeall.buymeacoffee" = "☕ Like this project? Buy me a coffee: https://www.buymeacoffee.com/homeall 😎"
    "homeall.easteregg"    = "🎉 You found the hidden label! Have a nice day. 😎"
  ]

  # Build attestations: SBOM and provenance (max detail)
  attest = [
    {
      type = "provenance"
      mode = "max"
    },
    {
      type = "sbom"
    }
  ]
}
