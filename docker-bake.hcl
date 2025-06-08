# --------------------------------------------------------------------
# docker-bake.hcl
# Centralized Docker Build configuration for multi-platform and CI/CD
# --------------------------------------------------------------------

# Default build group
group "default" {
  targets = ["build"]
}

# Target for Docker metadata action (populated by workflow)
target "docker-metadata-action" {}

# Main build target
target "build" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "Dockerfile"

  # Multi-platform support
  platforms = [
    "linux/amd64",
    "linux/arm64",
    "linux/arm",
  ]

  # Caching for GitHub Actions
  cache-from = [
    "type=gha"
  ]
  cache-to = [
    "type=gha,mode=max"
  ]

  # ---------- Image Labels ----------
  labels = {
    "maintainer"           = "Homeall"
    "homeall.buymeacoffee" = "☕ Like this project? Buy me a coffee: https://www.buymeacoffee.com/homeall 😎"
    "homeall.easteregg"    = "🎉 You found the hidden label! Have a nice day. 😎"
  }

  # ---------- Image Annotations (OCI manifest-level) ----------
  annotations = [
    "maintainer=Homeall",
    "homeall.buymeacoffee=☕ Like this project? Buy me a coffee: https://www.buymeacoffee.com/homeall 😎",
    "homeall.easteregg=🎉 You found the hidden label! Have a nice day. 😎"
  ]

  # ---------- Build Attestations ----------
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
