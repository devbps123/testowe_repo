resource "github_repository" "repo" {
  name = "testowe_repo"
  description = "testowe repo bps"
  auto_init = true
}
resource "github_repository_file" "gitignore" {
  repository          = github_repository.repo.name
  branch              = "main"
  file                = ".gitignore"
  content             = "**/*.tfstate"
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true
}
resource "github_branch" "development" {
repository = github_repository.repo.name
  branch     = "development"
}
resource "github_branch" "tests" {
  repository = github_repository.repo.name
  branch     = "tests"
}
resource "github_branch" "prod" {
  repository = github_repository.repo.name
  branch     = "prod"
}