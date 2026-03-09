# Library Charts

## Project Overview

This is a Helm **library chart** repository. The main chart is at `charts/stable/common/`. It is not installable directly — it provides reusable templates that other Helm charts depend on.

Originally forked from the k8s-at-home common library (now unmaintained). This is a general-purpose library chart.

## Repository Structure

```
charts/stable/common/          # The library chart
  templates/                   # Kubernetes resource templates
    _all.tpl                   # Main entrypoint — renders all resources
    _deployment.tpl            # Deployment
    _statefulset.tpl           # StatefulSet
    _daemonset.tpl             # DaemonSet
    _service.tpl               # Service
    _ingress.tpl               # Ingress
    _configmap.tpl             # ConfigMap
    _secret.tpl                # Secret
    _pvc.tpl                   # PersistentVolumeClaim
    _serviceaccount.tpl        # ServiceAccount
    classes/                   # Class templates (service, ingress, pvc, hpa)
    lib/chart/                 # Helpers: names, labels, annotations, values, capabilities
    lib/controller/            # Pod, container, env, ports, probes, volumes
  values.yaml                  # Default values with helm-docs annotations
  Chart.yaml                   # Chart metadata (type: library)
helper-charts/common-test/     # Test chart for CI validation
hack/                          # Scripts and doc templates
.github/                       # CI workflows
```

## Key Conventions

- **Template naming**: All templates use the `common.` prefix (e.g. `common.deployment`, `common.controller.pod`)
- **Values structure**: Controller type (`deployment`/`daemonset`/`statefulset`) is set via `controller.type`
- **Multi-resource support**: Services and ingresses use a named dictionary pattern (`service.main`, `ingress.main`) with a `primary` flag
- **Helm-docs annotations**: Values use `# --` comment prefix for auto-generated README
- **Default strategy**: Deployments default to `RollingUpdate`, StatefulSets to `RollingUpdate`

## Testing

```bash
cd helper-charts/common-test/
helm dependency update .
helm template test . -f ci/basic-values.yaml  # Render and inspect
helm unittest -f "tests/**/*_test.yaml" .      # Run unit tests
```

## Releasing

- Bump `version` in `charts/stable/common/Chart.yaml`
- Update `README_CHANGELOG.md.gotmpl` with changes
- Push to `main` — the `charts-release.yaml` workflow uses chart-releaser to publish to GitHub Pages and create a GitHub release

## Code Style

- Helm templates use `{{-` and `-}}` whitespace trimming carefully to avoid YAML formatting issues
- Use `with` blocks for optional fields to avoid rendering empty values
- Keep templates focused — one resource type per file
