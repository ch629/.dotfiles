eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"

export GOPRIVATE=github.com/banked
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export EDITOR="nvim"
export CARGO_NET_GIT_FETCH_WITH_CLI="true"

alias helmlogin="export HELM_EXPERIMENTAL_OCI=1 && gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-docker.pkg.dev"
alias devproxy="cloudflared access tcp --hostname k8s.dev.bnkd.dev --url 127.0.0.1:8888"
alias devproxy-start="cloudflared access tcp --hostname k8s.dev.bnkd.dev --url 127.0.0.1:8888 &"
alias devproxy-stop="killall cloudflared"
