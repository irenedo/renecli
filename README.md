# renecli

Reusable Nushell commands for local CLI workflows.

## Install

Load the module from Nushell:

```nu
use <project-directory>/commands.nu *
```

To load it automatically, add that same line to your Nushell config file.

You can open the config with:

```nu
config nu
```

For Bash, define `CLIPATH` in your Bash profile and source the aliases file from it:

```bash
export CLIPATH="$HOME/renecli"
source "$CLIPATH/aliases.sh"
```

## Commands

### `aws-profile`

Lists `aws configure list-profiles` through `fzf`, then sets the selected value as the current shell's `AWS_PROFILE` and sets the AWS region to `us-east-1`.

If the selected profile name contains `prod`, iTerm2's background is changed to dark red. Selecting a non-prod profile resets the terminal background to the profile default color.

```nu
aws-profile
```

From Bash, use the alias:

```bash
awsprof
```

Dependencies:

- `aws`
- `fzf`

The selected profile is exported only for the current Nushell session and any processes started from it.

### `kube-namespace`

Lists Kubernetes namespaces through `fzf`, then sets the selected namespace on the current Kubernetes context.

```nu
kube-namespace
```

From Bash, use the alias:

```bash
kns
```

Dependencies:

- `kubectl`
- `fzf`

### `eks-ingress`

Lists all ingress host names in the current Kubernetes cluster through `fzf`, then opens the selected host in the default browser.

```nu
eks-ingress
```

From Bash, use the alias:

```bash
king
```

Dependencies:

- `kubectl`
- `fzf`
- `open`

### `kube-context`

Lists configured Kubernetes contexts through `fzf`, switches to the selected context, then asks you to select a namespace for that context.

```nu
kube-context
```

From Bash, use the alias:

```bash
kcon
```

Dependencies:

- `kubectl`
- `fzf`
