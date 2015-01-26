# Nubis project
#
# Build AMIs using packer
#
# Type `make ubuntu` to build for Ubuntu
# Type `make amazon-linux` to build for Amazon Linux
#
# When you're ready to increment the release type `make release-increment` and then build for ubuntu or amazon-linux as appropriate above.
#
# Variables
RELEASE_FILE=nubis/packer/release.json

# Top level build targets
all:
	@echo "Please use 'make amazon-linux' or 'make ubuntu' to build for those respective platforms."

amazon-linux: build packer-amazon-linux

ubuntu: build packer-ubuntu

build: build-increment nubis-puppet

release: release-increment nubis-puppet packer

# Internal build targets
force: ;

nubis-puppet: force
	cd nubis && librarian-puppet clean
	cd nubis && librarian-puppet install --path=nubis-puppet
	tar --exclude='nubis-puppet/.*' --exclude=.git -C nubis -zpcf nubis/nubis-puppet.tar.gz nubis-puppet

release-increment:
	./nubis/bin/release.sh -f $(RELEASE_FILE) -r

build-increment:
	./nubis/bin/release.sh -f $(RELEASE_FILE)

packer-ubuntu: force
	packer build -var-file=nubis/packer/variables.json -var-file=$(RELEASE_FILE) nubis/packer/ubuntu.json

packer-amazon-linux: force
	packer build -var-file=nubis/packer/variables.json -var-file=$(RELEASE_FILE) nubis/packer/amazon-linux.json

clean:
	rm -rf nubis/nubis-puppet
