workflow "Publish Blog" {
  on = "push"
  resolves = ["blog-publisher"]
}

action "blog-builder" {
  uses = "skarlso/blog-builder@master"
  secrets = ["GITHUB_TOKEN"]
}

action "blog-publisher" {
  uses = "skarlso/blog-publisher@master"
  needs = ["blog-builder"]
  secrets = ["GITHUB_TOKEN", "PUSH_TOKEN"]
}