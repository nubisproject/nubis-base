# nubis-base

You can build an image like so:

$> cat packer/nubis/variables.json
{
  "aws_access_key": "XXX",
  "aws_secret_key": "XXX",
  "iam_instance_profile": "packer"
}

$> make

The structure of the project is like this:

nubis/
  puppet/
  packer/
  terraform/


nubis/puppet/*.pp

is for the puppet manifests specific to this image you are building

nubis/packer/main.json

is for the packer definition of the image you are building. Ideally, should
basically just be a puppet-masterless provisionner into nubis/puppet/init.pp

nubis/terraform/main.tf

is for describing the production deployment of this component. Ideally, should
be just infrastructure components as well as AMIs baked by nubis.
