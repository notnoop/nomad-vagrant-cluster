.PHONY: up
up:
	vagrant up

.PHONY: download_binaries
download_binaries:
	cd bin; ./download.sh nomad 0.12.1+ent
	cd bin; ./download.sh vault 1.5.0
	cd bin; ./download.sh consul 1.8.2

clean:
	vagrant destroy -f
