## ZNAP START ###

# if [[ "${TERM_PROGRAM}" =~ "vscode" ]]; then
#     tmux new-session -A -s "vscode:${PWD##*/}" -e TERM_ORIGIN="${TERM_PROGRAM}"
# fi

# znap: Install and source
[[ -r ~/.znap/core/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.znap/core
source ~/.znap/core/znap.zsh

# znap: set the repos directory
zstyle ':znap:*' repos-dir ~/.znap/repos

# znap: set prompt to startship if available, and if not spaceship
# znap eval direnv 'direnv hook zsh'
znap eval starship 'starship init zsh --print-full-init'

# znap: install plugins
znap source ohmyzsh/ohmyzsh lib/{functions,history,directories} plugins/{brew,kubectl,git,npm,fzf,pip,multipass,tmux,command-not-found}
znap source Aloxaf/fzf-tab
znap source zsh-users/zsh-syntax-highlighting
znap source zdharma-continuum/fast-syntax-highlighting
znap source zsh-users/zsh-autosuggestions
# znap source jeffreytse/zsh-vi-mode

# Mise
znap eval mise 'mise activate zsh' # mise activation
znap fpath _mise 'mise completion zsh' # mise completions
alias mr="mise run"

# Zoxide
znap eval zoxide 'zoxide init zsh'
alias cd="z"

# znap: completions
# znap fpath _multipass '< ~[ohmyzsh]/plugins/multipass/_multipass'
# fpath+=( ~[ohmyzsh]/plugins/{multipass,pass} )
# znap fpath _kubectl 'kubectl completion zsh'

### ZNAP END ###

# partial command history search with Up key
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# zvm_after_init_commands+=("zvm_bindkey viins '^R' fzf-history-widget" "bindkey '^[[A' up-line-or-beginning-search" "bindkey '^[[B' down-line-or-beginning-search")

# exports
export VISUAL=vim
export EDITOR="$VISUAL"
export PAGER=

# Adding custom paths to PATH

# VSCODE shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

alias vim="nvim"
alias ls="ls --color=auto" # Add color to output
alias grep="grep --color=auto" # Add color to output

# alias vnc="/Applications/TigerVNC\ Viewer\ 1.13.1.app/Contents/MacOS/TigerVNC\ Viewer"
alias ssh-list-tunnel="ps aux | grep 'ssh*.-f'"
alias ssh-kill-tunnel="pkill -f 'ssh.*-f'"

function asp { export AWS_PROFILE="$1"; }

alias k='kubectl "--context=${KUBECTL_CONTEXT:-$(kubectl config current-context)}" ${KUBECTL_NAMESPACE/[[:alnum:]-]*/--namespace=${KUBECTL_NAMESPACE}}'
function kc { export KUBECTL_CONTEXT="$1"; }
function kn { export KUBECTL_NAMESPACE="$1"; }
function kw { echo "${KUBECTL_CONTEXT:-$(kubectl config current-context)} (${KUBECTL_NAMESPACE:-$(kubectl config view --minify --output 'jsonpath={..namespace}')})"; }

function rds-erc-dev() {
    asp cfaiotnp-admin
    cmd="54321:riot-rds-cluster.cluster-c4kua9ptpy1t.us-east-1.rds.amazonaws.com:5432"
    alias=$(aws iam list-account-aliases --output text --query 'AccountAliases[0]')
    instance_id=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aloha' --output text --query 'Reservations[*].Instances[*].InstanceId')
    echo "Connecting to ${alias} via the aloha instance (${instance_id}) and creating tunnel: ${cmd}"
    ssh -fNT $instance_id -L "${cmd}"
}
function rds-goauth-dev() {
    asp cfaiotnp-admin
    cmd="54322:goauth-2021-03-03-cluster.cluster-c4kua9ptpy1t.us-east-1.rds.amazonaws.com:5432"
    alias=$(aws iam list-account-aliases --output text --query 'AccountAliases[0]')
    instance_id=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aloha' --output text --query 'Reservations[*].Instances[*].InstanceId')
    echo "Connecting to ${alias} via the aloha instance (${instance_id}) and creating tunnel: ${cmd}"
    ssh -fNT $instance_id -L "${cmd}"
}
function rds-erc-mirror() {
    asp cfaioprod-admin
    cmd="54331:riot-mirror-rds-instance.cluster-c8cexsfstnyt.us-east-1.rds.amazonaws.com:5432"
    alias=$(aws iam list-account-aliases --output text --query 'AccountAliases[0]')
    instance_id=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aloha' --output text --query 'Reservations[*].Instances[*].InstanceId')
    echo "Connecting to ${alias} via the aloha instance (${instance_id}) and creating tunnel: ${cmd}"
    ssh -fNT $instance_id -L "${cmd}"
}
function rds-erc-prod() {
    asp cfaiotprod-admin
    secret=$(aws secretsmanager get-secret-value --secret-id "rds/riot-rds-08242021-cluster/erc-host-service-prod-app-secret" --query SecretString --output text)
    echo $secret
    port="$(echo $secret | jq -r '.port')"
    host="$(echo $secret | jq -r '.host')"
    cmd="54341:$host:$port"
    alias=$(aws iam list-account-aliases --output text --query 'AccountAliases[0]')
    instance_id=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aloha' --output text --query 'Reservations[*].Instances[*].InstanceId')
    echo "Connecting to ${alias} via the aloha instance (${instance_id}) and creating tunnel: ${cmd}"
    ssh -fNT $instance_id -L "${cmd}"
}
function ensure-chick-fi-login() {
    FILE="$HOME/.oauth/okta_token"
    # How many seconds before file is deemed "older"
    OLDTIME=3000
    # Get current and file times
    CURTIME=$(date +%s)
    FILETIME=$(stat -t %s -f %m $FILE)
    TIMEDIFF=$(expr $CURTIME - $FILETIME)

    # Check if file older
    if [ "$TIMEDIFF" -gt "$OLDTIME" ]; then
        echo "Token needs to be refreshed"
        chick-fi-login -e prod -a riot_util
    fi
    # tokenReturnCode=$(curl -s -o /dev/null -w "%{http_code}" --header "Authorization: Bearer $(cat ~/.oauth/okta_token)" --location 'https://hams.riot.cfahome.com/theboot/locations/01029')
    # if [[ $tokenReturnCode != "200" ]]; then
    #     chick-fi-login -e prod -a riot_util
    # fi
}
function nuc-image() {
    asp cfaiotnp-admin
    export ISOVERSION=$(aws s3 ls s3://dev-255539238673-us-east-1-nuc-images | awk '{print $2}' | grep "v" | sed 's:/*$::' | fzf --header="Select which image version to use:") && echo "Selected image version: $ISOVERSION..." && ( test -f /tmp/nuc-image-$ISOVERSION.iso || aws s3 cp s3://dev-255539238673-us-east-1-nuc-images/$ISOVERSION/clonezilla.iso /tmp/nuc-image-$ISOVERSION.iso ) && sudo balena local flash /tmp/nuc-image-$ISOVERSION.iso
}
function host-wipe-get() {
    ensure-chick-fi-login
    curl -s --location --request GET "https://hams.riot-dev.cfadevelop.com/wipe/${1}" --header "Authorization: Bearer $(cat ~/.oauth/okta_token)" | jq '.'
}
function host-wipe() {
    min_ago="$(date -u -v -10M +"%Y-%m-%dT%H:%M:%S%z")"
    today="$(date -u +"%Y-%m-%d")"
    ensure-chick-fi-login
    WIPE_INFO=$(host-wipe-get "${1}")
    last_wipe="$(echo "$WIPE_INFO" | jq -r '.LastWipeRequestedISO')"
    wipe_confirmed="$(echo "$WIPE_INFO" | jq -r '.LastWipeConfirmed')"
    if [[ ${last_wipe} == *"${today}"* ]] && [[ "$last_wipe" < "$min_ago" ]] && [[ $wipe_confirmed == "false" ]]; then
        line="${1} ? Online but not responding to wipes"
        grep -qxF "${line}" /Users/tim.harris/Code/github/cfacorp/erc-host-agent-deployment/replace.txt || echo "${line}" >>/Users/tim.harris/Code/github/cfacorp/erc-host-agent-deployment/replace.txt
        echo "- Online but not responding to wipes"
    elif [[ ${last_wipe} == *"${today}"* ]]; then
        if [[ $wipe_confirmed == "true" ]]; then
            echo "- Already succesfully wiped today @ ${last_wipe}"
        elif [[ $wipe_confirmed == "false" ]]; then
            echo "- Already wiped today, but waiting to see if it succeeds"
        fi
    else
        echo "Wiping..."
        curl -s --location --request PUT "https://hams.riot.cfahome.com/wipe/${1}" --header "Authorization: Bearer $(cat ~/.oauth/okta_token)"
    fi
}

function loc-reset() {
    ensure-chick-fi-login
    curl -s --location --request POST "https://hosts.riot.cfahome.com/actions/reset/${1}" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $(cat ~/.oauth/okta_token)"
}
function host-reboot() {
    ensure-chick-fi-login
    curl -s --location --request POST "https://hosts.riot.cfahome.com/actions/hosts/${1}" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $(cat ~/.oauth/okta_token)" \
        --data '{
            "action": "reboot"
        }' | jq '.'
}
function host-reboot-get() {
    ensure-chick-fi-login
    curl -s --location --request GET "https://hosts.riot.cfahome.com/actions/hosts/${1}" \
        --header 'Accept: application/json' \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $(cat ~/.oauth/okta_token)" | jq '.'
}
