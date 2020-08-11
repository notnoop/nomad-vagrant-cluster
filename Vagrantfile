# -*- mode: ruby -*-
# vi: set ft=ruby :

SERVERS = 3
CLIENTS = 1

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  configureProviders(config)

  1.upto(SERVERS) do |n|
    serverName = "server-%02d" % [n]
    serverIP = "10.199.0.%d" % [10+n]

    config.vm.define serverName, autostart: true, primary: false do |vmCfg|
      vmCfg.vm.hostname = serverName
      configureLinux(vmCfg)
      configureServer(vmCfg)

			vmCfg.vm.provider "virtualbox" do |_|
				vmCfg.vm.network :private_network, ip: serverIP
			end
    end
  end

  1.upto(CLIENTS) do |n|
    serverName = "client-%02d" % [n]
    serverIP = "10.199.0.%d" % [20+n]

    config.vm.define serverName, autostart: true, primary: false do |vmCfg|
      vmCfg.vm.hostname = serverName
      configureLinux(vmCfg)
      configureClient(vmCfg)

			vmCfg.vm.provider "virtualbox" do |_|
				vmCfg.vm.network :private_network, ip: serverIP
			end
    end
  end
end

def configureProviders(vmCfg, cpus: "2", memory: "2048")
	vmCfg.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--cableconnected1", "on", "--audio", "none"]
		v.memory = memory
		v.cpus = cpus
	end
end

def configureLinux(vmCfg)
  vmCfg.vm.provision "shell",
                     privileged: true,
                     path: './scripts/provision-box.sh'
end

def configureClient(vmCfg)
  vmCfg.vm.provision "shell",
                     privileged: true,
                     path: './scripts/provision-client.sh'
  vmCfg.vm.provision "shell",
                     privileged: true,
                     path: './scripts/start-client.sh'
end

def configureServer(vmCfg)
  vmCfg.vm.provision "shell",
                     privileged: true,
                     path: './scripts/start-server.sh',
                     env: {'SERVER_COUNT': SERVERS}
end
