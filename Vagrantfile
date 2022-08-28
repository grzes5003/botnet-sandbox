# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_EXPERIMENTAL'] = "typed_triggers,dependency_provisioners"

Vagrant.configure("2") do |config|
  secSwitch ='Mirai'
  config.vm.provider "hyperv"

  config.trigger.before :up do |trigger|
    trigger.run = {path: "setup_scripts/xcompilers_downloader.ps1"}
  end

  # =============================
  # =       Configure CNC       =
  # =============================
  config.vm.define "cnc" do |cnc|
    cnc.vm.box = "generic/ubuntu1804"
    cnc.vm.hostname = "cnc"
    cnc.vm.network "public_network", bridge: "Default Switch"

    cnc.trigger.after :'Vagrant::Action::Builtin::SetHostname', type: :hook do |hook|
        hook.info = 'Sync files'
        hook.run = {inline: "python setup_scripts/run_after.py cnc"}
    end

    cnc.vm.provision "shell",
      inline: "ifconfig eth1 10.10.10.1 netmask 255.255.255.0"

    cnc.vm.provision "shell", path: "setup_scripts/cnc_setup.sh"

    cnc.vm.provider :hyperv do |h, override|
        h.maxmemory = 2048
        h.memory = 2048
        h.vmname = "cnc"

        override.trigger.before :'VagrantPlugins::HyperV::Action::StartInstance', type: :action do |trigger|
          trigger.run = { inline: "./add_net_int.ps1 -VmName cnc -SwitchName \"'#{secSwitch}'\" " }
        end
    end

  end


  # =============================
  # =       Configure Node      =
  # =============================
  N = 1
  (1..N).each do |node_id|
    config.vm.define "vm#{node_id}" do |node|
      node.vm.hostname = "vm#{node_id}.local"
      node.vm.box = "generic/alpine38"
      node.vm.network "public_network", bridge: "Default Switch"

#       node.vm.synced_folder "./shared", "/vagrant"

      node.vm.provider :hyperv do |h, override|
        h.maxmemory = 256
        h.memory = 256
        h.vmname = "vm#{node_id}"

        override.trigger.before :'VagrantPlugins::HyperV::Action::StartInstance', type: :action do |trigger|
          trigger.run = { inline: "./add_net_int.ps1 -VmName vm#{node_id} -SwitchName \"'#{secSwitch}'\" " }
        end
      end

      node.vm.provision "shell",
        inline: "ifconfig eth1 10.10.10.#{20+node_id} netmask 255.255.255.0"
      node.vm.provision "shell", path: "setup_scripts/node_setup.sh"

    end
  end

end
