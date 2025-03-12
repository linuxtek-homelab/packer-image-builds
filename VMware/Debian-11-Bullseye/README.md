## Packer config to build vSphere virtual machines template from Debian 11 "Bullseye" ISO file as a source.

This project is designed to build a template for use with VMware vSphere from the base Debian 11 ISO.

The focus is on using HCL formatting, as JSON is becoming deprecated.  

## Preparation

Clone the repo, and rename the vsphere.pkrvars.sanitized.hcl file to vsphere.pkrvars.hcl.  Edit this file to add all of the vSphere values.  This should be the only file that needs editing.

Download the Debian 11 "Bullseye" DVD 1 ISO, for example [here](http://mirrors.ocf.berkeley.edu/debian-cd/11.2.0/amd64/iso-dvd/debian-11.2.0-amd64-DVD-1.iso) and upload it to the [datastore]/iso_path folder on your vSphere server.  For example, I have an ISO folder on my main datastore where this is saved.

## Execution

Run the following to build template using Packer:

```bash
packer build -var-file variables.pkrvars.hcl -var-file vsphere.pkrvars.hcl debian11-bullseye.pkr.hcl
```

## Updates

1/24/2021:  Modified setup_debian.sh to generate an SSH key and enable sshd service to start on boot.
Otherwise you get this error when attempting to start sshd: "sshd: no hostkeys available -- exiting"