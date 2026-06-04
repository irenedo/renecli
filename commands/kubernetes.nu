# Kubernetes-related commands.

# Pick a Kubernetes namespace with fzf and set it on the current context.
export def kube-namespace [] {
    let namespace = (
        kubectl get namespaces --output jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
        | fzf --prompt 'Kubernetes namespace> ' --layout reverse --height 40% --border rounded
        | str trim
    )

    if ($namespace | is-empty) {
        print 'No Kubernetes namespace selected'
        return
    }

    kubectl config set-context --current --namespace $namespace
    print $'Kubernetes namespace=($namespace)'
}

# Pick a Kubernetes context with fzf, switch to it, then pick a namespace.
export def kube-context [] {
    let context = (
        kubectl config get-contexts --output name
        | fzf --prompt 'Kubernetes context> ' --layout reverse --height 40% --border rounded
        | str trim
    )

    if ($context | is-empty) {
        print 'No Kubernetes context selected'
        return
    }

    kubectl config use-context $context
    kube-namespace
}
