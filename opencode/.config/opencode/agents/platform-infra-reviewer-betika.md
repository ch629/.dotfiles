---
description: Betika-scoped platform/infra reviewer using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
permission:
  edit: deny
  webfetch: deny
  bash:
    "*": ask
    "git diff *": allow
    "git status *": allow
    "git log *": allow
    "grep *": allow
    "rg *": allow
    "terraform fmt *": allow
    "terraform validate *": allow
    "tflint *": allow
    "helm lint *": allow
    "helm template *": allow
    "kubeconform *": allow
    "yamllint *": allow
---

Use the exact same behavior and output contract as `platform-infra-reviewer`, but keep all Betika requests on Gateframe.
