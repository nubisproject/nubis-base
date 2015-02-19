# nubis-base

## Quick start
0. `git clone git@github.com:bhourigan/nubis-builder.git`
0. `cd nubis-builder`
0. Setup secrets/variables.json
0. `@PATH=$(PATH):./bin nubis-builder build --project-path ~/path-to-your-project --verbose`

## File structure

##### `nubis`
All files related to the nubis base project

##### `nubis/bin`
Scripts related to configuring nubis-base AMIs

##### `nubis/nubis-puppet`
This is the puppet tree that's populated with librarian-puppet, it's in .gitignore and gets reset on every build.

##### `nubis/packer`
JSON files that describe the project, configure settings, and a special provisioner for `nubis/bin/packer-bootstrap`

##### `nubis/terraform`
Terraform deployment templates.
