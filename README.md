<a id="readme-top"></a>
# Self-Hosted GitLab CI/CD Infrastructure (Ansible + Docker)

![CI](https://github.com/XCVI1/selfhosted-gitlab-ansible/actions/workflows/ci.yml/badge.svg)

## Project Overview

This project automates the deployment of a self-hosted GitLab CI/CD environment using Ansible and Docker Compose. It is designed to provide a fully reproducible environment with a single command.

### Features

- **Automated Docker Installation**: Installs and configures Docker and Docker Compose.
- **GitLab Deployment**: Deploys GitLab CE container with customizable settings.
- **GitLab Runner**: Deploys and configures GitLab Runner container.
- **Network Configuration**: Configures Docker network for seamless communication between containers.
- **Automated Backups**: Daily backups with automatic rotation, runs before every upgrade.
- **Security**: Optionally sets a custom root password for GitLab.

---

## Architecture

The architecture of this project includes the following components:

1. **Ansible Playbook**: Automates the installation and configuration of Docker, and deploys GitLab and GitLab Runner.
2. **Docker Compose**: Manages the deployment of GitLab and GitLab Runner containers.
3. **GitLab CE**: Self-hosted GitLab instance for source code management and CI/CD pipelines.
4. **GitLab Runner**: Executes CI/CD jobs defined in GitLab.

---

## Project Structure

```
.
├── inventory.ini
├── playbook.yml          # Deployment
├── upgrade.yml           # Version upgrade
├── backup.yml            # Backup
├── restore.yml           # Restore to backup
├── group_vars/
│   └── gitlab.yml        # Variables (version, backup settings)
├── templates/
│   └── docker-compose.yml.j2
└── scripts/
    ├── ch_root_pswd.sh
    ├── register_runner.sh
    ├── status.sh        # Show gitlab status
    └── cleanup.sh       # Remove unused Docker images
```

---

## Prerequisites

Before you begin, you need to have:

- **Operating System**: Ubuntu 20.04/22.04 or any other Debian-based distribution.
- **Ansible**: Version 2.9 or higher.

---

## Getting Started

### Installation

1. Create directory and clone this repository:.

```sh
git clone https://github.com/XCVI1/selfhosted-gitlab-ansible.git
```

2. If you want to deploy on a remote server, modify the inventory.ini file to specify the IP addresses or hostnames of your target machines.

3. Run the Ansible playbook:

```sh
ansible-playbook -i inventory.ini playbook.yml -K
 ```
During execution, you need to:

* Enter the root (sudo) password.
* Follow the prompts to set the root password for GitLab.

---

## Usage

After deployment, you can access GitLab at `http://localhost:8080` or `http://gitlab:8080`.

### Makefile

For easier use long commands you can use short aliases:

| Command | Description |
|---|---|
| `make deploy` | Install Docker and deploy GitLab |
| `make backup` | Create backup |
| `make restore` | Restore latest backup |
| `make upgrade` | Upgrade GitLab version |
| `make status` | Show infrastructure status |
| `make cleanup` | Remove unused Docker images |

Example:
```sh
make deploy
make status
```

### Change password

Make the script executable and run it:

```sh
chmod +x ./scripts/ch_root_pswd.sh
./scripts/ch_root_pswd.sh
```
### Registering GitLab Runner

1. Go to `http://localhost:8080/user/runners` and copy the registration token.
2. Run the script with your token:
```sh
./scripts/register_runner.sh YOUR_TOKEN
```

Alternatively, you can pass the token as an environment variable:
```sh
REGISTRATION_TOKEN=your_token ./scripts/register_runner.sh
```

### Update version GitLab

1. Change `gitlab_version` in `group_vars/gitlab.yml`:
  `gitlab_version: "18.8.3-ce.0"`
2. Run:
  `make upgrade`

A backup is created automatically before upgrading.

### Backup Gitlab

To create a backup, run:
```sh
ansible-playbook -i inventory.ini backup.yml -K
```

Backups are stored in `~/gitlab-docker/data/backups/`.
The last 7 backups are kept saves automatically, older ones are deleted.

Backups run automatically before every update.

### Restore GitLab

To restore the latest backup:
```sh
ansible-playbook -i inventory.ini restore.yml -K
```

To restore a specific backup, use filename:
```sh
ansible-playbook -i inventory.ini restore.yml -K \
  -e "restore_backup=YOUR_BACKUP_FILENAME.tar"
```

List with available backups listed automatically at the start of the playbook.

> **Important:** `gitlab-secrets.json` is restored automatically.
> Without it, encrypted data cannot be decrypted.  

### Scripts

| Script | Description |
|---|---|
| `scripts/status.sh` | Shows containers, version, health, disk usage and backups |
| `scripts/cleanup.sh` | Removes unused Docker images and stopped containers |
| `scripts/ch_root_pswd.sh` | Changes GitLab root password |
| `scripts/register_runner.sh` | Registers GitLab Runner with token |

### Roadmap

- [x] Ansible playbook
- [x] Docker Compose template (Jinja2)
- [x] Self-hosted GitLab CE and GitLab Runner
- [x] Automatic GitLab Runner registration
- [x] GitLab version upgrade
- [x] Automated backups with rotation
- [x] Backup restore playbook
- [x] Makefile for common commands
- [x] Status and cleanup scripts
- [ ] HTTPS / SSL support
- [ ] Email notifications

<p align="right">
  <a href="#readme-top">
    <img src="https://img.shields.io/badge/Back_to_Top-↑-blue?style=for-the-badge" />
  </a>

