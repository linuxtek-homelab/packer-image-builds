## Packer config to build vSphere virtual machines template from Ubuntu Server 21.10 live-server ISO file as a source.

This project is designed to build a template for use with VMware vSphere from the base live-server ISO file for Ubuntu Server 21.10.

The focus is on using HCL formatting, as JSON is becoming deprecated.  

As Ubuntu is discontinuing support for the Debian installer which uses a preseed technique, this project focuses instead on using the autoinstall method with subiquity.  In order to configure the autoinstaller, cloud-init is used, for which the configuration data is stored in the http directory, and provided in the user-data file.

## Preparation

Clone the repo, and rename the vsphere.pkrvars.sanitized.hcl file to vsphere.pkrvars.hcl.  Edit this file to add all of the vSphere values.  This should be the only file that needs editing.

Download the Ubuntu Server 21.10 live server ISO [here](https://releases.ubuntu.com/21.10/ubuntu-21.10-live-server-amd64.iso) and upload it to the [datastore]/iso_path folder on your vSphere server.  For example, I have an ISO folder on my main datastore where this is saved.

## Execution

Run the following to build template using Packer:

```bash
packer build -var-file variables.pkrvars.hcl -var-file vsphere.pkrvars.hcl ubuntu-21.10.pkr.hcl
```

## References

* [Efkan Isazade Blog](https://efkan-isazade.com/p/automating-ubuntu-20.04-live-server-template-generation-with-packer-vsphere-iso-build./)

* [Efkan Isazade Github - Ubuntu 20.04 Packer Project](https://github.com/efops/packer-ubuntu20.04)

* [TeKanAid - Packer Ubuntu 20.04](https://tekanaid.com/posts/hashicorp-packer-build-ubuntu20-04-vmware)

* [Hashicorp VMware Builder Documentation](https://www.packer.io/docs/builders/vmware/iso)

* [Imagineer Blog](https://imagineer.in/blog/packer-build-for-ubuntu-20-04/)

* [Cloud Init Documentation](https://cloudinit.readthedocs.io/)

* [BerryJu Automating Ubuntu 20.04 with Packer](https://beryju.org/blog/automating-ubuntu-server-20-04-with-packer/)