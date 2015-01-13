# nubis-base

You can build an image like so:

$> cat packer/variables.json 
{
  "aws_access_key": "XXX",
  "aws_secret_key": "XXX",
}

$> packer build -var-file=packer/variables.json -var release=20 packer/main.json



