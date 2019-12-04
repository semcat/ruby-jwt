# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true
  config.vm.box = "ubuntu/bionic64"

  config.vm.network :forwarded_port, guest: 3012, host: 3012

  config.vm.provision :shell, path: "bootstrap.sh", keep_color: true

  config.vm.synced_folder ".", "/vagrant", fsnotify: true

  # vagrant-cachier is a plugin that keeps packages around so you don't have
  # to download them over and over
  config.cache.scope = :box if Vagrant.has_plugin?("vagrant-cachier")

  config.vm.provider "virtualbox" do |vb|
    vb.memory = ENV.fetch("RUBY_JWT_BOX_RAM", 2048).to_i
    vb.cpus = ENV.fetch("RUBY_JWT_BOX_CPUS", 2).to_i
  end
end
