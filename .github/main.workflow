workflow "Publish Blog" {
  on = "push"
  resolves = ["publish_it"]
}

action "build_it" {
  uses = "./.github/actions/build_it@master"
  secrets = ["GITHUB_TOKEN"]
}

action "publish_it" {
  uses = "./.github/actions/publish_it@master"
  needs = ["build_it"]
  secrets = ["GITHUB_TOKEN"]
}