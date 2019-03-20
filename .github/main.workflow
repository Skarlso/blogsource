workflow "Publish Blog" {
  on = "push"
  resolves = ["blog-publisher"]
}

action "build_it" {
  uses = "skarlso/blog-builder@master"
  secrets = ["GITHUB_TOKEN"]
}

action "publish_it" {
  uses = "skarlso/blog-publisher@master"
  needs = ["build_it"]
  secrets = ["GITHUB_TOKEN"]
}