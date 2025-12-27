[![DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/formalism-labs/devka)

<p align="center">
  <img src="docs/devka.png" alt="Logo" />
</p>
<h1 align="center">Devka</h1>

### What is Devka?
**Devka** is a set of tools to help developers with organizing and constructing development environments.
It is pronouced `/ˈdɛv.kə/`. You can try, at your own risk, pronouncing it according to its Russian origin.

### It can help you to:
* Organize configuration in "environments", which are named sets of definitions that can be invoked interactively or by script.
* Neatly arrange the configuration of your machines (physical and virtual) and containers.
* If you manage a developers team, it can help in maintaining a consistent configuration across team members, which is easy to evolve, while giving developers freedom to personally customize it.
* Ease common automation tasks with [**Classico**](https://github.com/formalism-labs/classico).
* Create containerized environments for development and experiments,
* Create VM-based work environments locally or in the cloud.

### Installation

#### Unix-like systems (Linux, macOS, WSL2, FreeBSD)

Invoke the following:

```
curl -fsSL https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.sh | bash
```

On macOS, make sure you're using Bash version 5 rather than the macOS native Bash version 3. Use `brew install bash` to install it.

#### Windows

In PowerShell, as Administrator, invoke:
```
iex "& { $(irm https://raw.githubusercontent.com/formalism-labs/devka/refs/heads/main/sbin/setup-host.ps1) } -PubKey 'ssh-rsa ...'"
```

This will install **msys2** along with all required artifacts to run Devka, as well as SSH service to access the system remotely.

The public key specified will enable SSH access to the host. One needs to verify the firewall allows SSH traffic to get through.

### Tools and Commands

* `devka`: controls the configuration of Devka.
* `se`: "set environment" - invokes an environment, activating its definitions.
* `ppath`: "print path" - print a PATH-style environment variable.
* `var`: display an environment variable.
* `eset`: edit the value of an environment variable.
* Classico `get*` commands: install all kinds of facilities.
* `dvm`: "docker-vm" - run a container equipped with Devka - mostly effective for ephemeral experimental sessions.
* `devbox`: construct and run developer's workstation in a container.

### Rationale

Development workstations face some common challenges:

- Unlike containers, their configuration is not formally specified,
- Performing experiments inside workstations makes them unstable in the long run,
- Not having a formal configuration makes it hard to standardize them,
- Developers like to customize their workstations, so we find ourselves with two layers of configuration,
- Workstation typically based on a specific OS or distribution, 

### Configuration

* $HOME/.devka
* $HOME/.devka-user
* `DEVKA_USER_REPO` variable

### Devka Internals
Read [more](docs/internals.md) to understand what's going on under the hood.

