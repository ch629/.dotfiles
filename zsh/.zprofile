export GOPRIVATE=github.com/banked
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export EDITOR="nvim"
export CARGO_NET_GIT_FETCH_WITH_CLI="true"

alias helmlogin="export HELM_EXPERIMENTAL_OCI=1 && gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-docker.pkg.dev"

eval "$(/opt/homebrew/bin/brew shellenv)"
