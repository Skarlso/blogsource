workflow "Publish Blog" {
  on = "push"
  resolves = ["publish_it"]
}

action "build_it" {
  uses = "./actions/builds_it@master"
  secrets = ["GITHUB_TOKEN"]
}

action "publish_it" {
  uses = "./actions/publish_it@master"
  needs = ["build_it"]
  secrets = ["GITHUB_TOKEN"]
}