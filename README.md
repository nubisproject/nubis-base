# nubis-base

## Quick start
0. Copy nubis/packer/variables.json-dist to nubis/packer/variables.json and configure it with your AWS access keys
0. Run: `make build` and wait a few minutes

## Required files

Check out the -dist files in nubis/packer to get an idea of what they'll need to look like.

##### nubis/packer/ami.json
This file contains the source AMI IDs that nubis-base is built on top of. You can fill this in yourself if you have a specific *need* to pin to an older AMI, otherwise it's recommended that you run `make generate-ami-json` generate this file for you using the latest compatible AMIs. In the case of Ubuntu we pin it to the version major (currently trusty) as some required software is not yet packaged for utopic.

##### nubis/packer/project.json
This file contains the name and description of your project.

##### nubis/packer/variables.json
This file contains your secret data like access keys, certificate paths, etc and will be specific to your AWS account.

##### nubis/packer/release.json
This file tracks the release and build number for the project. Build numbers are automatically incremented, while a `make release` is required to increment the release number. It's created for you automatically when you run your first build.

## Dependencies

You'll need the AWS cli installed and configured with your access keys <https://aws.amazon.com/cli/>, and jq <https://stedolan.github.io/jq/>

## Make targets

##### `make puppet`
This will invoke librarian puppet and pull in all the required puppet sources for the packer provisioner. This step needs to run before packer can launch builders.

##### `make generate-ami-json`
This will run nubis/bin/generate-latest-amis which will populate nubis/packer/ami.json with source AMI IDs

##### `make packer`
Increments the build number in `nubis/packer/release.json` and kicks off a packer build

##### `make build`
Increments the build number, invokes puppet, invokes generate-ami-json, and invokes puppet all with one handy command.

##### `make release`
Increments the release number, resets the build number, invokes puppet, invokes generate-ami-json, and invokes puppet all with one handy command.

## File structure

##### `nubis`
All files related to the nubis build system, you probably don't want to put your project files in here.

##### `nubis/bin`
Build tools related to building AMIs

##### `nubis/nubis-puppet`
This is the puppet tree that's populated with librarian-puppet, it's in .gitignore and gets reset on every build.

##### `nubis/packer`
All of the variable files and the master build template for packer, 
###### `nubis/packer/main.json`
This is the main build template, take a look and add your own custom provisioners or tweak what's already there. It's good practice to avoid hard coding variables into this file, instead think about using variables.json for sensitive data or project.json for project specifics.

##### `nubis/terraform`
Terraform deployment templates.

###### `nubis/terraform/main.tf`
This file describes the production deployment of this project.
