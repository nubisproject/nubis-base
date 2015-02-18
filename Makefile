# Nubis project
#
# Build AMIs using packer

# Variables
RELEASE_FILE=nubis/packer/release.json
PROJECT_FILE=nubis/packer/project.json
AMI_FILE=nubis/packer/ami.json

# Top level build targets
all:
	@echo "type \`make puppet' to populate librarian puppet"
	@echo "type \`make generate-ami-json' to find latest AMIs to build against"
	@echo "type \`make packer' to build"
	@echo
	@exit 0

build: puppet generate-ami-json packer

release: release-increment build

# Internal build targets
force: ;

puppet: force
        cd nubis && librarian-puppet clean
        cd nubis && rm -f Puppetfile.lock
        cd nubis && librarian-puppet install --path=nubis-puppet
        tar --exclude='nubis-puppet/.*' --exclude=.git -C nubis -zpcf nubis/nubis-puppet.tar.gz nubis-puppet

release-increment: force
	./nubis/bin/release.sh -f $(RELEASE_FILE) -r

build-increment: force
	./nubis/bin/release.sh -f $(RELEASE_FILE)

generate-ami-json:
	PATH=$(PATH):./nubis/bin ./nubis/bin/generate-latest-amis $(AMI_FILE)

packer: build-increment
	@if [ ! -f $(AMI_FILE) ]; then \
		echo $(AMI_FILE) is required for building. tip: run make generate-ami-json to automatically generate this file ;\
		echo ;\
		exit 1 ;\
	fi
	packer build -var-file=nubis/packer/variables.json -var-file=$(RELEASE_FILE) -var-file=$(PROJECT_FILE) -var-file=$(AMI_FILE) nubis/packer/main.json

clean:
	rm -rf nubis/nubis-puppet
