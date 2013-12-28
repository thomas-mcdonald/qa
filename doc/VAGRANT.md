# Developing with Vagrant

**At this point we have an automatic build of the Vagrant base box, but the environment might not be fully setup on box creation.**

```
cd vagrant
vagrant up
// wait for the vm to be setup
vagrant ssh
```

## Packer

The distributed Vagrant box is automatically built using [Packer](http://www.packer.io/). You don't need to build your own box (the Vagrantfile downloads the required one). The notes that follow are for reference if you are building your own box - although you will probably need to change a hardcoded path for the base ISO.

The packer files are located inside `vagrant/packer`.

### Build Instructions
```
cd vagrant/packer
packer build template.json
```