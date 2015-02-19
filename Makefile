# Nubis project
#
# Build AMIs using packer

# Variables
PROJECT_FILE=nubis/packer/project.json
AMI_FILE=nubis/packer/ami.json
PROJECT=$(shell jq --raw-output .project < $(PROJECT_FILE))

# Top level build targets
all:
	@echo "type \`make puppet' to populate librarian puppet"
	@echo "type \`make generate-ami-json' to find latest AMIs to build against"
	@echo "type \`make packer' to build"
	@echo
	@echo "type \`make build' to do all three steps at once"
	@echo "type \`make release' to increment the release, and then build"
	@echo
	@exit 0

build: build-increment puppet generate-ami-json packer

release: release-increment build

# Internal build targets
force: ;

puppet: force
	cd nubis && librarian-puppet clean
	cd nubis && rm -f Puppetfile.lock
	cd nubis && librarian-puppet install --path=nubis-puppet
	cp -f $(PROJECT_FILE) nubis/nubis-puppet/$(PROJECT)-project.json
	tar --exclude='nubis-puppet/.*' --exclude=.git -C nubis -zpcf nubis/nubis-puppet.tar.gz nubis-puppet

release-increment: force
	./nubis/bin/increment-version --file $(PROJECT_FILE) --release

build-increment: force
	./nubis/bin/increment-version --file $(PROJECT_FILE) --build

generate-ami-json:
	PATH=$(PATH):./nubis/bin ./nubis/bin/generate-latest-amis $(AMI_FILE)

packer: build-increment
	@if [ ! -f $(AMI_FILE) ]; then \
		echo $(AMI_FILE) is required for building. tip: run make generate-ami-json to automatically generate this file ;\
		echo ;\
		exit 1 ;\
	fi
	packer build -var-file=nubis/packer/variables.json -var-file=$(PROJECT_FILE) -var-file=$(AMI_FILE) nubis/packer/main.json

clean:
	rm -rf nubis/nubis-puppet
