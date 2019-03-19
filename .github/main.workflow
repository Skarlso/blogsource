workflow "Publish Blog" {
  on = "push"
  resolves = ["publish_it"]
}

action "build_it" {
  uses = "build_it"
  secrets = ["GITHUB_TOKEN"]
}

action "publish_it" {
  uses = "publish_it"
  needs = ["build_it"]
  secrets = ["GITHUB_TOKEN"]
}