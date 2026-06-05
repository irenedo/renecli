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

# Pick an ingress host with fzf and open it in the default browser.
export def eks-ingress [] {
    let host = (
        kubectl get ingress --all-namespaces --output jsonpath='{range .items[*]}{range .spec.rules[*]}{.host}{"\n"}{end}{end}'
        | lines
        | where {|host| not ($host | is-empty) }
        | uniq
        | to text
        | fzf --prompt 'Ingress host> ' --layout reverse --height 40% --border rounded
        | str trim
    )

    if ($host | is-empty) {
        print 'No ingress host selected'
        return
    }

    ^open $'https://($host)'
}

# Pick any Kubernetes resource kind, including CRDs, and inspect it.
export def eks-inspect [] {
    let resource = (
        kubectl api-resources --request-timeout 10s --verbs list --output name
        | lines
        | where {|resource| not ($resource | is-empty) }
        | sort
        | uniq
        | to text
        | fzf --prompt 'Kubernetes resource> ' --layout reverse --height 40% --border rounded
        | str trim
    )

    if ($resource | is-empty) {
        print 'No Kubernetes resource selected'
        return
    }

    kubectl inspect $resource
}

# Pick a pod in the current namespace and follow its logs.
export def kube-logs [] {
    let pod = (
        kubectl get pods --output jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
        | fzf --prompt 'Kubernetes pod> ' --layout reverse --height 40% --border rounded
        | str trim
    )

    if ($pod | is-empty) {
        print 'No Kubernetes pod selected'
        return
    }

    kubectl logs -f $pod
}

# Pick an app.kubernetes.io/name label in the current namespace and follow matching logs.
export def kube-app-logs [] {
    let name = (
        kubectl get pods --output jsonpath='{range .items[*]}{.metadata.labels.app\.kubernetes\.io/name}{"\n"}{end}'
        | lines
        | where {|name| not ($name | is-empty) }
        | sort
        | uniq
        | to text
        | fzf --prompt 'Kubernetes app name> ' --layout reverse --height 40% --border rounded
        | str trim
    )

    if ($name | is-empty) {
        print 'No Kubernetes app name selected'
        return
    }

    kubectl logs -f -l $'app.kubernetes.io/name=($name)' --all-containers --max-log-requests=100
}
