###### Linux

###################
### Unix-y specific
###################

export EDITOR='vim'
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/opt/curl/bin"
export GPG_TTY=$(tty)
export PATH=$PATH:$HOME/bin
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
alias ls='ls --color=auto'
alias c='clear'
alias tree='tree -C'
alias latest='find . -mtime -30 -type f | grep -v DS_Store'
alias pping='prettyping --nolegend'
# Alias for running update
alias u="$HOME/.dotfiles/update-mac.sh"
function rand() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}
ulimit -n 8192
# Setting LSCOLORS. Set the folder colors to bold and yellow 
# Source: https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console
LS_COLORS=$LS_COLORS:'di=1;33:' ; export LS_COLORS

## Zsh
# Zsh completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# TIMEFMT environment variable for zsh's built-in time function
TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias preview="fzf --preview 'bat --color \"always\" {}'"
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

## Tmux
alias t='tmux'
# Settings for tmux window renaming
export DISABLE_AUTO_TITLE=true
# If you want to start a new tmux session remotely (while connecting using ssh)
function ssht () {
    /usr/bin/ssh -X -t $@ "tmux attach -t development || tmux new -s development";
}

###################################
### Editos and Software Programming
###################################

## Vim
# Alias to run bare bones Vim
alias vimn='vim -u .dotfiles/vim/vimrc-essential'

## Git
alias g='git'
alias gbage='for k in `git branch -r | perl -pe '\''s/^..(.*?)( ->.*)?$/\1/'\''`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r'
alias gll='gitloglive'
alias grch='generaterandomchanges'

## Go
export GOPATH=$HOME/workspace/2020/go-apps
export PATH=$GOPATH/bin:$PATH

## JVM Languages
export JAVA_HOME="/usr/local/java"
export GROOVY_HOME="/usr/local/opt/groovy/libexec"
export GRADLE_HOME="/usr/local/opt/gradle"
export GRADLE_OPTS="-Xmx1024m"
export M2_HOME="/usr/local/opt/maven"
export PATH=$JAVA_HOME/bin:$GROOVY_HOME/bin:$GRADLE_HOME/bin:$M2_HOME/bin:$HOME/.cargo/bin:$PATH
alias j='java'
alias jc='javac'
alias kt='kotlin'
alias kc='kotlinc'
alias kj='kotlinc-jvm'

## Python
alias p='python3'
alias p2='python2'
alias pipup='pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip3 install -U'

## Ruby
export PATH=/usr/local/opt/ruby/bin:$PATH

## JavaScript/Node
alias n='node'

## Cisco (codectl)
## codectl install or upgrade
function getcodectl () {
  curl -LO https://repo-art.cisco.com/artifactory/codectl/stable/latest/codectl-darwin-amd64 && sudo install codectl-darwin-amd64 /usr/local/bin/codectl
  rm codectl-darwin-amd64
  codectl
}
alias ctl='codectl'

## Rust
alias r='rustc'

## Fortran
alias f='gfortran'

#################
### Public Clouds 
#################

## All Clouds
# Switch to Cisco Cloud Account(s)
function csco() {
    profile="cisco"
    az_subscription_id="02187d59-a1ce-4f8c-9e59-0f3dd558e5c3"

    export AWS_PROFILE="${profile}" # switch AWS profile
    gcloud config configurations activate "${profile}" # switch GCP profile
    az account set --subscription "${az_subscription_id}" # switch Azure profile
    showcloud
}
# Switch to Personal Cloud Account(s)
function my() {
    profile="default"
    az_subscription_id="8cf5d499-2e9b-4161-a3b7-8c6747241dbb"

    export AWS_PROFILE="${profile}" # switch AWS profile
    gcloud config configurations activate "${profile}" # switch GCP profile
    az account set --subscription "${az_subscription_id}" # switch Azure profile
    showcloud
}
# Show Current Cloud Settings
function showcloud() {
    echo "AWS Profile Settings: "
    aws configure list
    echo
    echo "GCP Profile Settings: "
    gcloud config configurations list
    echo
    echo "Azure Profile Settings: "
    az account show
}

## GCP
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi
alias gcssh="gcloud compute ssh"
alias gcls="gcloud compute instances list"
#alias gcip='curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip'

## AWS
#export AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep -i aws_access_key_id | awk -F ' = ' '{print $2}')
#export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep -i aws_secret_access_key | awk -F ' = ' '{print $2}')
export PATH=/usr/local/aws-cli/v2/current/bin:$PATH
alias awsls='aws ec2 describe-instances --query "Reservations[*].Instances[*].{instance_id: InstanceId, type: InstanceType, ip_address_private: PrivateIpAddress, ip_address_public: PublicIpAddress, instance_state: State.Name, vpc_id: VpcId, subnet_id: SubnetId, availability_zone: Placement.AvailabilityZone, image_id: ImageId, ebs_volume_id: BlockDeviceMappings[0].Ebs.VolumeId}" --output table'
alias awsgw='aws ec2 describe-internet-gateways --query "InternetGateways[*].{internet_gateway_id: InternetGatewayId, vpc_id: Attachments[0].VpcId, state: Attachments[0].State}" --output table'
alias awsvpc='aws ec2 describe-vpcs --query "Vpcs[*].{vpc_id: VpcId, cidr_block: CidrBlock, state: State}" --output table'
alias awssub='aws ec2 describe-subnets --query "Subnets[*].{vpc_id: VpcId, subnet_id: SubnetId, availability_zone: AvailabilityZone, cidr_block: CidrBlock, public_network: MapPublicIpOnLaunch}" --output table'
alias awssec='aws ec2 describe-security-groups --query "SecurityGroups[*].{vpc_id: VpcId, group_id: GroupId, group_name: GroupName, group_description: Description}" --output table'
alias awsrt='aws ec2 describe-route-tables --query "RouteTables[*].{route_table_id: RouteTableId, vpc_id: VpcId}" --output table'
# The next line enables shell command completion for aws.
if [ -f '/Users/anasharm/Library/Python/3.7/bin/aws_zsh_completer.sh' ]; then source '/Users/anasharm/Library/Python/3.7/bin/aws_zsh_completer.sh'; fi

## Azure
alias azls='az vm list'

## DigitalOcean
alias dols="doctl compute droplet list"
alias dco="doctl compute"
function dossh() {
    if [[ ! -z $1 ]]; then
        instance=$1
    else
        instance="demo"
    fi
    if [[ ! -z $2 ]]; then
        userid=$2
    else
        userid="anasharm"
    fi
    doctl compute ssh "${instance}" --ssh-user "${userid}"
}
#export DO_TOKEN=$(head -1 ~/.config/doctl/config.yaml | awk '{print $2}')
#SSH_ID=$(doctl compute ssh-key list | grep "anand" | cut -d' ' -f1)
#export DO_SSH_KEY_FINGERPRINT=$(doctl compute ssh-key get $SSH_ID --format FingerPrint --no-header)

## OpenStack
alias o='openstack'
alias ols='openstack server list'
# Source into Cisco RTP Cluster
#source ~/rtp
# Cisco Cloud Login
#source ~/.cec

##############################################
### VMs, Containers & Container Orchestrators 
##############################################

## Containers
alias d='docker'
alias dm='docker-machine'
alias lzd='lazydocker'

## Kubectl and related K8s tools
# kubectl completion
# source <(kubectl completion zsh)
# stern completion
# source <(stern --completion=zsh)
export KUBE_EDITOR="subl"
export KUBECONFIG="/home/ubuntu/.kube/config"
# export KUBECONFIG="/home/ubuntu/.kube/config.cisco"
# export KUBECONFIG="/home/ubuntu/.kube/config:/Users/anasharm/.kube/config.cisco"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:$HOME/.linkerd2/bin
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias kt='kubetail'
alias s="stern"
alias kon="kubeon"
alias koff="kubeoff"
alias i='istioctl'
alias mk='minikube'
alias ms='minishift'
alias sk='skaffold'
alias h='helm'
alias ky='ksync'
alias dr='draft'
alias rhc='rhc 2>/dev/null' #Or log into laeusr-prod2-01.cisco.com with anasharm
function dp() {
    if [[ ! -z $1 ]]; then
        podname=$1
    else
        podname="debugpod"
    fi
    if [[ ! -z $2 ]]; then
        command=$2
    else
        command="bash"
    fi
    kubectl exec -it "${podname}" -- "${command}"
}
# Kube PS1 configurations
# KUBE_PS1_CTX_COLOR="black"
# KUBE_PS1_NS_COLOR="blue"
# KUBE_PS1_SYMBOL_COLOR="blue"
KUBE_PS1_CTX_COLOR="yellow"
KUBE_PS1_SYMBOL_USE_IMG="true"
KUBE_PS1_SYMBOL_COLOR="yellow"
#KUBE_PS1_SYMBOL_IMG="☸️ "
source "$HOME/.kube-ps1/kube-ps1.sh"
kubeon

################
### DevOps Tools
################

## Ansible
alias a='ansible'
alias ap='ansible-playbook'

## Terraform
alias tf='terraform'

## Spinnaker
# Everything below is for a local Spinnaker install
# NVM post-installation requirements
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# FRONT50=http://localhost:8080
# FIAT=http://localhost:7003
# ORCA=http://localhost:8083
# ROSCO=http://localhost:8087
# IGOR=http://localhost:8088
# REDIS=redis://localhost:6379
# ECHO=http://localhost:8089
# CLOUDDRIVER=http://localhost:7002
# DECK=http://localhost:9000
# GATE=http://localhost:8084

## Multipass
alias m='multipass'

## Vangrant
alias v='vagrant'

## VirtualBox
alias vb='vboxmanage'

############################
### Data-Intensive App Tools
############################

export PATH=$PATH:/usr/local/kafka/2.4.0/bin

##################
### Security Tools
##################

## SSH
alias sshallnpoc='ssh -o ProxyCommand="ssh ubuntu@173.37.28.89 nc %h %p"'

## SOPS
#export SOPS_PGP_FP="2A30D3C45B5C792CC603C82AA190E97F52B7DBAC"

## GPG
# Source: https://gist.github.com/bmhatfield/cc21ec0a3a2df963bffa3c1f884b676b
# Add the following to your shell init to set up gpg-agent automatically for every shell
eval $(gpg-agent --daemon)

#########################
### Miscellaneous Goodies
#########################

# Philip's goodies
alias current-id='find-id git $(git config --get remote.origin.url)'
function bit() {
    chrome $(git config --get remote.origin.url | gsed -E 's-^(ssh|https?)://(git@)?(.*?)\.cisco\.com/(scm/)?(.*?)/(.*?)\.git$-https://\3.cisco.com/projects/\5/repos/\6/browse-')'?at='$(git rev-parse HEAD)
}


###############################
### Let's make it look right...
###############################

# Get the terminal ready
clear

# Set this correctly please..;-)
DOTFILES_HOME=$HOME/.dotfiles
cat $DOTFILES_HOME/misc/om
. $DOTFILES_HOME/z/z.sh
w

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


