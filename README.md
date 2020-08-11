# Setup for a Nomad cluster

Simple scripts for setting up a Nomad+Consul+Vault cluster in Vagrant boxes.

Steps:

1. Download relevant Nomad binaries in `./bin` directory with: `make download_binaries`
   * you can also compile Linux binaries and place them in the folder
2. edit Vagrantfile with the number of desired SERVERS and CLIENTS
3. `make up`

The Nomad servers will be accessible at `http://10.199.0.1:4646`, Consul at `http://10.199.0.1:8500`.

To run a sample job:
```
$ vagrant ssh client-1 # or any servers


# generate a sample job file
$ nomad job init --short 
$ nomad job run ./example.nomad

# wait for a bit and check status
$ nomad job status example
$ docker ps
```

## TODO:

* [ ] Integrate Vault
* [ ] Setup TLS and ACL


## Helpful links:

* [Hashicorp Nomad Learn](https://learn.hashicorp.com/nomad)
* [Nomad Docs](https://www.nomadproject.io/docs)
* [Job specification docs](https://www.nomadproject.io/docs/job-specification)
