# Nubis project
#
# Build AMIs using packer

# Variables
RELEASE_FILE=nubis/packer/release.json
PROJECT_FILE=nubis/packer/project.json
AMI_FILE=nubis/packer/ami.json

# Top level build targets
all: build

build: build-increment nubis-puppet

release: release-increment nubis-puppet

# Internal build targets
force: ;

nubis-puppet: force
	cd nubis && librarian-puppet clean
	cd nubis && rm -f Puppetfile.lock
	cd nubis && librarian-puppet install --path=nubis-puppet
	tar --exclude='nubis-puppet/.*' --exclude=.git -C nubis -zpcf nubis/nubis-puppet.tar.gz nubis-puppet

release-increment:
	./nubis/bin/release.sh -f $(RELEASE_FILE) -r

build-increment:
	./nubis/bin/release.sh -f $(RELEASE_FILE)

generate-amis:
	PATH=$(PATH):./nubis/bin ./nubis/bin/generate-latest-amis $(PROJECT_FILE)

packer: $(PROJECT_FILE)
	packer build -var-file=nubis/packer/variables.json -var-file=$(RELEASE_FILE) -var-file=$(PROJECT_FILE) -var-file=$(AMI_FILE) nubis/packer/main.json

clean:
	rm -rf nubis/nubis-puppet
