# Self-Hosted GitLab CI/CD Infrastructure (Ansible + Docker)
---

## Project Overview

This project automates the deployment of a self-hosted GitLab CI/CD environment using Ansible and Docker Compose. It is designed to provide a fully reproducible environment with a single command.

### Features

- **Automated Docker Installation**: Installs and configures Docker and Docker Compose.
- **GitLab Deployment**: Deploys GitLab CE container with customizable settings.
- **GitLab Runner**: Deploys and configures GitLab Runner container.
- **Network Configuration**: Configures Docker network for seamless communication between containers.
- **Security**: Optionally sets a custom root password for GitLab.

---

## Architecture

The architecture of this project includes the following components:

1. **Ansible Playbook**: Automates the installation and configuration of Docker, and deploys GitLab and GitLab Runner.
2. **Docker Compose**: Manages the deployment of GitLab and GitLab Runner containers.
3. **GitLab CE**: Self-hosted GitLab instance for source code management and CI/CD pipelines.
4. **GitLab Runner**: Executes CI/CD jobs defined in GitLab.

---

## Prerequisites

Before you begin, ensure you have met the following requirements:

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
* Follow the prompts to set the root password fo GitLab.

---

## Usage

After deployment, you can access GitLab at `http://localhost:8080` or `http://gitlab:8080`.

### Registering GitLab Runner

- Go to `http://localhost:8080/admin/runners`.
- Copy the registration token.
- Register the runner using the token:
  - Change directory to `gitlab-docker`
  - Use ``docker exec -it gitlab-runner gitlab-runner register`` and follow instruction.

## Roadmap

- [x] Ansible playbook.
- [x] Template docker compose.
- [x] Self-hosted GitLab CE and GitLab Runner.
- [ ] GitLab Runners.

<a href="#self-hosted-gitlab-cicd-infrastructure-ansible--docker">Back to top</a>




