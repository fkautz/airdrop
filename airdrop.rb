#!/usr/bin/env ruby

require 'rubygems'

require 'json'
require 'active_record'
require 'thor'

class RunningServices < ActiveRecord::Base
end

class Airdrop
  def self.start(service, parameters)
    if !running(service)
      dataDir = "#{@repoDir}/#{service}/data"
      logsDir = "#{@repoDir}/#{service}/logs"
      `mkdir -p #{dataDir}`
      `mkdir -p #{logsDir}`
      id = `docker run -d -v #{dataDir}:/data -v #{logsDir}:/logs #{parameters} #{service}`
      id = id.strip
      if id.length > 0
        state = RunningServices.new(service: service, container_id: id)
        state.save!
        true
      else
        raise "Unable to start service"
      end
    else
      raise "Service is already running"
    end
  end

  def self.stop(service)
    found_service = RunningServices.where(service: service).take
    if !found_service.nil?
      id = found_service.container_id
      `docker stop #{id}`
      RunningServices.where(container_id: id).take.destroy
      status_string = `docker wait #{id}`
      status = status_string.to_i
      status
    elsif
      raise "Cannot stop container, not running"
    end
  end

#  def self.upgrade(service)
#    # check if upgrade necessary
#    if upgradeAvailable(service)
#      id = getImageId(service)
#      # stop container
#      stop(service)
#      # backup container data and logs
#      backup(service, id)
#      # run
#      success = start(service)
#      if !success
#        rollback(service, version)
#      end
#    else
#      raise "Image is already at the latest version"
#    end
#  end

  def self.upgradeAvailable(service)
    current_image = getImageId(service)
    new_image = `docker images -notrunc | grep #{service} | grep latest | awk '{print $3}'`.strip
    current_image != new_image
  end

  def self.getImageId(service)
    id = RunningServices.where(service: service).take
    if id.nil?
      raise "Service is not running"
    end
    id = id.container_id
    json_string = `docker inspect #{id}`
    json = JSON.parse(json_string)
    json[0]["Image"].strip
  end

  def self.rollback
  end

  def self.backup(service, pre="noimage")
    target = "backups/#{service}/#{pre}/#{Time.now.to_i}"
    `mkdir -p #{target}`
    `cp -a /docker/#{service}/* #{target}`
  end

  def self.load(file)
    `docker load < #{file}`
  end

  def self.status
    RunningServices.all.each do |s|
      puts "#{s.service}: #{s.container_id}"
    end
  end

  def self.running(service)
    id = RunningServices.where(service: service).take
    if !id.nil?
      res = `docker inspect #{id}`
      res = res.strip
      if res.length != 0
        true
      elsif
        false
      end
    elsif
      false
    end
  end
end

class App < Thor
  package_name 'Airdrop'
  desc "migrate", "Migrates airdrop database to latest version"
  def migrate
    invoke :connect
    ActiveRecord::Migrator.migrate('db/migrate',  ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  desc "connect", "connect to the database"
  def connect
    ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))
    ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
  end

  desc "status", "shows running containers"
  def status
    connect
    Airdrop.status
  end

  desc "run SERVICE PARAMETERS", "starts a service"
  def start(service, parameters="")
    connect
    Airdrop.start(service, parameters)
  end

  desc "stop SERVICE", "stops a service"
  def stop(service)
    connect
    Airdrop.stop(service)
  end

  desc "backup SERVICE", "backups data from a service"
  def backup(service)
    connect
    Airdrop.backup(service)
  end

#  desc "upgrade SERVICE", "upgrades a service"
#  def upgrade(service)
#    connect
#    Airdrop.upgrade(service)
#  end
end

App.start
