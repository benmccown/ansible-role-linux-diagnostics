
# Test Kitchen Setup

## Table of Contents

<!-- TOC -->

- [Test Kitchen Setup](#test-kitchen-setup)
    - [Table of Contents](#table-of-contents)
    - [Actions](#actions)
        - [Configure](#configure)
            - [Create Gemfile](#create-gemfile)
            - [Create Kitchen Config](#create-kitchen-config)
            - [Install Test Kitchen](#install-test-kitchen)
            - [Create SSH Test](#create-ssh-test)
        - [Add Test (Ansible)](#add-test-ansible)
            - [Add Ansible Config](#add-ansible-config)
            - [Create Initial Play](#create-initial-play)
            - [Create Initial Task](#create-initial-task)
        - [Run Test](#run-test)

<!-- /TOC -->

---

## Actions

### Configure

#### Create Gemfile

Set content of `Gemfile` with `cat << EOF > Gemfile`

```ruby
# -*- encoding: utf-8 -*-
source "https://rubygems.org"

group :development do
  gem 'test-kitchen',  '>=1.15.0'
  gem 'kitchen-vagrant', '>=1.3.1'
  gem 'kitchen-ansiblepush', '>=0.8.0'
  gem 'kitchen-inspec', '>=0.23.1'
end
```

#### Create Kitchen Config

Set content for `kitchen.yml` with `cat << EOF > kitchen.yml`

```json
---
driver:
  name: vagrant

provisioner:
  name: ansible_push
  ansible_config: test/ansible.cfg
  chef_bootstrap_url: nil

verifier:
  name: inspec

platforms:
  - name: centos-7.6

suites:
  - name: default
    provisioner:
      playbook: test/integration/default/default.yml
    verifier:
      inspec_tests:
        - test/integration/default
```

#### Install Test Kitchen

```sh
gem install bundler
bundle install
bundle exec kitchen init
rm chefignore
```

>     Successfully installed bundler-2.0.1
>     1 gem installed
>     Bundle complete! 4 Gemfile dependencies, 124 gems now installed.
>     Overwrite kitchen.yml? (enter "h" for help) [Ynaqdhm] n
>     skip    kitchen.yml
>     create  chefignore
>     create  test/integration/default

#### Create SSH Test

Set content for `ssh_spec.rb` with `cat << EOF > test/integration/default/ssh_spec.rb`

```ruby
control 'ssh-on' do
title 'Port 22 is listening'
desc 'SSH should be enabled and listening'
impact 1.0 # This is critical
  describe port(22) do
    it { should be_listening }
  end
  describe service('sshd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
```

### Add Test (Ansible)

#### Add Ansible Config

Set content for `ansible.cfg` with `cat << EOF > test/ansible.cfg`

```ini
[defaults]
roles_path = ../.roles:../..
nocows = 1
retry_files_enabled = false
host_key_checking = false
```

#### Create Initial Play

Set content for `default.yml` with `cat << EOF > test/integration/default/default.yml`

```yaml
---
- hosts: all
  gather_facts: true
  become: yes

  roles:
    - `echo $(basename $PWD)`
```

#### Create Initial Task

```sh
mkdir tasks
```

Set content for `main.yml` with `cat << EOF > tasks/main.yaml`

```yaml
---
- name: test
  debug:
    msg: "hello from {{ playbook_dir }} test"
```

### Run Test

Kitchen Options:

>     bundle exec kitchen {help|init|test|create|converge|verify|destroy|test} {optional:target}

```sh
bundle exec kitchen test
```

>      ✔  ssh-on: Port 22 is listening
>         ✔  Port 22 should be listening
>         ✔  Service sshd should be installed
>         ✔  Service sshd should be enabled
>         ✔  Service sshd should be running
