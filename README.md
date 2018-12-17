# Ansible Formatter

This program is designed to convert Ansible one-line syntax to map syntax.

Converts this:
```
- name: foo src=/tmp/bar dest=/tmp/baz state=present
```

to this:
```
- name: foo
  file:
    src: /tmp/bar
    dest: /tmp/baz
    state: present
```

### Usage

First, make executable:
```
chmod +x formatter.rb
```

Then use `./formatter.rb` with one or more files and/or directories

The following options are available:

| Option             | Argument    | Required      | Default | Description                                                        |
| :----------------- | :---------- | :------------ | :------ | :----------------------------------------------------------------- |
| `-v`, `--verbose`  | None        | No            | False   | Print which files are being formatted                              |
| `-n`               | N (integer) | No            | 2       | Specify the maximum number of `key=value` pairs in one-line syntax |

**Example**:
```
./formatter.rb -v ~/development/atmosphere-ansible/roles ~/development/clank/roles/install-dependencies/tasks/main.yml
Changed 2 lines in /home/calvinmclean/development/clank/roles/app-alter-kernel-for-imaging/tasks/main.yml
Changed 2 lines in /home/calvinmclean/development/clank/roles/app-generate-ini-config/tasks/main.yml
Changed 3 lines in /home/calvinmclean/development/clank/roles/setup-webserver-user-group/tasks/main.yml
Changed 1 lines in /home/calvinmclean/development/clank/roles/noc-enable-new-relic/tasks/main.yml
Changed 3 lines in /home/calvinmclean/development/clank/roles/app-config-postgres/tasks/main.yml
Changed 1 lines in /home/calvinmclean/development/clank/roles/install-dependencies/tasks/main.yml
Changed 2 lines in /home/calvinmclean/development/clank/roles/app-setup-ssh-keys/tasks/main.yml
Changed 2 lines in /home/calvinmclean/development/clank/roles/setup-postgres/tasks/main.yml
Changed 2 lines in /home/calvinmclean/development/clank/roles/logrotate-files/tasks/main.yml
```
