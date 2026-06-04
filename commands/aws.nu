# AWS-related commands.

# Pick an AWS CLI profile with fzf and set it as the current shell profile.
export def --env aws-profile [
    --bash-export # Print a Bash export command instead of setting Nushell's environment.
] {
    let profile = (
        aws configure list-profiles
        | fzf --prompt 'AWS profile> ' --layout reverse --height 40% --border rounded
        | str trim
    )

    if ($profile | is-empty) {
        print 'No AWS profile selected'
        return
    }

    let identity_check = (aws sts get-caller-identity --profile $profile | complete)

    if $identity_check.exit_code != 0 {
        print $'AWS session for profile "($profile)" is not active. Running SSO login...'
        aws sso login --profile $profile
    }

    let region = 'us-east-1'
    let is_prod = ($profile | str downcase | str contains 'prod')
    let iterm_bg = if $is_prod {
        $'printf "\\033]11;#5f0000\\a"'
    } else {
        $'printf "\\033]111\\a"'
    }

    if $bash_export {
        print $'__RENECLI_EXPORT__ export AWS_PROFILE=($profile | to json --raw); export AWS_REGION=($region | to json --raw); export AWS_DEFAULT_REGION=($region | to json --raw); ($iterm_bg)'
    } else {
        $env.AWS_PROFILE = $profile
        $env.AWS_REGION = $region
        $env.AWS_DEFAULT_REGION = $region
        if $is_prod {
            print --no-newline (ansi -o '11;#5f0000')
        } else {
            print --no-newline (ansi -o '111')
        }
        print $'AWS_PROFILE=($env.AWS_PROFILE) AWS_REGION=($env.AWS_REGION)'
    }
}
