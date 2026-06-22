# ExternalSecret support — design

Date: 2026-06-22
Status: approved

## Goal

Add first-class support for the External Secrets Operator (ESO) to the `common`
library chart, so consumer charts can declare `ExternalSecret` resources the
same way they declare services, ingresses, and configMaps.

## Scope

- Emit `external-secrets.io/v1` `ExternalSecret` resources.
- Reference an **existing** `SecretStore`/`ClusterSecretStore` via
  `secretStoreRef`. The chart does **not** create a store.
- Support all three common pull shapes: `dataFrom`, `data`, and
  `target.template`.
- Pure passthrough for ESO-native fields (`data`, `dataFrom`, `target`) so the
  chart does not have to track ESO schema changes.

Out of scope: creating `SecretStore`/`ClusterSecretStore`, ESO `PushSecret`,
Sealed Secrets, the older `kubernetes-client/external-secrets` CRD.

## Values structure

Named dictionary, matching the existing `service` / `ingress` / `configmap`
pattern. Each key produces one `ExternalSecret`.

```yaml
externalSecrets:
  main:
    enabled: false
    # nameOverride:                 # optional suffix override
    annotations: {}
    labels: {}
    refreshInterval: 1h             # omitted from output if empty
    secretStoreRef:
      name:                         # REQUIRED when enabled
      kind: ClusterSecretStore      # default; override to SecretStore
    target:                         # optional; whole block conditional
      # secretName:                 # defaults to the ExternalSecret name
      creationPolicy: Owner
      # deletionPolicy: Retain
      template: {}                  # optional; reshape/connection-string
    dataFrom: []                    # optional
    data: []                        # optional
```

## Rendered output

```yaml
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: <fullname>-<key>            # nameOverride replaces <key>
  labels: {common.labels + item.labels}
  annotations: {common.annotations + item.annotations}   # only if non-empty
spec:
  refreshInterval: <refreshInterval>                      # only if set
  secretStoreRef:
    name: <required>
    kind: <kind | ClusterSecretStore>
  target:
    name: <target.secretName | metadata.name>
    creationPolicy: <target.creationPolicy | Owner>
    deletionPolicy: <target.deletionPolicy>               # only if set
    template: {...}                                        # only if set
  dataFrom: [...]                                          # only if set
  data: [...]                                              # only if set
```

If neither `data` nor `dataFrom` is set, render `data: []` so the resource is
valid (ESO requires at least one of the two; an empty `data` list is accepted).

## Design decisions

- **Naming**: always append the dict key as a suffix (`main` ->
  `<fullname>-main`). External secrets have no "primary" concept, so unlike
  services/ingresses there is no bare-name special case. Override per item with
  `nameOverride`.
- **`secretStoreRef.kind`** defaults to `ClusterSecretStore` (stores are
  cluster-wide infra in our setups).
- **`secretStoreRef.name`** uses `required` for a clear failure instead of
  rendering `<nil>`.
- **`target.secretName`** defaults to the ExternalSecret's own name so the
  synced Kubernetes Secret name is predictable.
- All optional blocks are gated with `with`/`if` to avoid empty-block YAML parse
  errors (a known gotcha with the unittest plugin).

## Files

Two-tier, matching every other resource in the chart:

- `charts/stable/common/templates/classes/_externalsecret.tpl` —
  `common.classes.externalsecret` blueprint (renders one resource from
  `ObjectValues.externalsecret`).
- `charts/stable/common/templates/_externalsecret.tpl` —
  `common.externalsecret` wrapper; ranges enabled items, sets `nameOverride`
  default to the key, sets `ObjectValues`, includes the blueprint.
- `charts/stable/common/templates/_all.tpl` — add
  `{{- include "common.externalsecret" . }}` next to the configmap include.
- `charts/stable/common/values.yaml` — add the documented `externalSecrets`
  block (helm-docs annotated, disabled by default, with a commented example).
- `charts/stable/common/Chart.yaml` — bump `5.0.0` -> `5.1.0`.

## Tests

`helper-charts/common-test/tests/externalsecret/`:

- presence: disabled by default (no ExternalSecret rendered); enabled renders one.
- naming: default `<fullname>-<key>`, and `nameOverride`.
- `secretStoreRef`: default kind `ClusterSecretStore`; override to `SecretStore`.
- `data` and `dataFrom` passthrough.
- `target.template` passthrough and `target.name` default.
- metadata merge (labels/annotations + global).

## Verification

- `helm unittest` green (existing 125 + new cases).
- `helm template` of a representative `ExternalSecret` is valid YAML with the
  expected `external-secrets.io/v1` shape.
