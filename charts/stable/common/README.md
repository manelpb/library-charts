# common

![Version: 5.5.0](https://img.shields.io/badge/Version-5.5.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

A general-purpose Helm library chart for Kubernetes applications

This library chart provides common templates and helpers to reduce maintenance cost between Helm charts that use it, following a DRY approach.

Originally based on the [k8s-at-home](https://github.com/k8s-at-home/library-charts) common library (no longer maintained).

## Requirements

Kubernetes: `>=1.23.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|

## Installing the Chart

This is a [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm).

**WARNING: THIS CHART IS NOT MEANT TO BE INSTALLED DIRECTLY**

## Using this library

Include this chart as a dependency in your `Chart.yaml` e.g.

```yaml
# Chart.yaml
dependencies:
- name: common
  version: 5.0.0
  repository: https://manelpb.github.io/library-charts/
```

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.

## Custom configuration

N/A

## Values

**Important**: When deploying an application Helm chart you can add more values from the common library chart [here](https://github.com/manelpb/library-charts/tree/main/charts/stable/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalContainers | object | `{}` | Specify any additional containers here as dictionary items. Each additional container should have its own key. Helm templates can be used. |
| affinity | object | `{}` | Defines affinity constraint rules. [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| args | list | `[]` | Override the args for the default container |
| automountServiceAccountToken | bool | `true` | Specifies whether a service account token should be automatically mounted. |
| autoscaling | object | <disabled> | Add a Horizontal Pod Autoscaler |
| command | list | `[]` | Override the command(s) for the default container |
| configmap | object | See below | Configure configMaps for the chart here. Additional configMaps can be added by adding a dictionary key similar to the 'config' object. |
| configmap.config.annotations | object | `{}` | Annotations to add to the configMap |
| configmap.config.data | object | `{}` | configMap data content. Helm template enabled. |
| configmap.config.enabled | bool | `false` | Enables or disables the configMap |
| configmap.config.labels | object | `{}` | Labels to add to the configMap |
| controller.annotations | object | `{}` | Set annotations on the deployment/statefulset/daemonset |
| controller.cronjob | object | See below | CronJob configuration. Only used when `controller.type` is `cronjob`. |
| controller.cronjob.concurrencyPolicy | string | `nil` | How to treat concurrent executions. Options: Allow, Forbid, Replace. |
| controller.cronjob.failedJobsHistoryLimit | string | `nil` | How many failed jobs to keep. |
| controller.cronjob.schedule | string | `nil` | Cron schedule. Required when `controller.type` is `cronjob`. |
| controller.cronjob.startingDeadlineSeconds | string | `nil` | Deadline in seconds for starting a job if it misses its schedule. |
| controller.cronjob.successfulJobsHistoryLimit | string | `nil` | How many completed jobs to keep. |
| controller.cronjob.suspend | string | `nil` | Suspend subsequent executions. |
| controller.cronjob.timeZone | string | `nil` | IANA time zone for the schedule (Kubernetes >=1.27). |
| controller.enabled | bool | `true` | enable the controller. |
| controller.job | object | See below | Job configuration. Used when `controller.type` is `cronjob` or `job`. |
| controller.job.activeDeadlineSeconds | string | `nil` | Deadline in seconds before the job is terminated. |
| controller.job.backoffLimit | string | `nil` | Number of retries before marking the job failed. |
| controller.job.completionMode | string | `nil` | Job completion mode. Options: NonIndexed (default), Indexed. |
| controller.job.completions | string | `nil` | Desired number of successfully finished pods. |
| controller.job.parallelism | string | `nil` | Maximum desired number of pods running at any instant. |
| controller.job.ttlSecondsAfterFinished | string | `nil` | TTL in seconds to clean up a finished job. `0` deletes immediately. |
| controller.labels | object | `{}` | Set labels on the deployment/statefulset/daemonset |
| controller.podManagementPolicy | string | `nil` | Set statefulset podManagementPolicy, valid values are Parallel and OrderedReady (default). |
| controller.progressDeadlineSeconds | string | `nil` | Set the maximum time in seconds for a deployment to make progress before being considered failed. This helps ArgoCD detect stuck rollouts (e.g. ImagePullBackOff). Defaults to 600 (Kubernetes default). Only applies to Deployments. |
| controller.replicas | int | `1` | Number of desired pods |
| controller.restartPolicy | string | `nil` | Pod restartPolicy for `cronjob`/`job` controllers. Defaults to `Never`. Valid options are `Never` and `OnFailure`. |
| controller.revisionHistoryLimit | int | `3` | ReplicaSet revision history limit |
| controller.rollingUpdate.partition | string | `nil` | Set statefulset RollingUpdate partition |
| controller.rollingUpdate.surge | string | `nil` | Set deployment RollingUpdate max surge |
| controller.rollingUpdate.unavailable | string | `nil` | Set deployment RollingUpdate max unavailable |
| controller.strategy | string | `nil` | Set the controller upgrade strategy For Deployments, valid values are Recreate and RollingUpdate (default). For StatefulSets, valid values are OnDelete and RollingUpdate (default). DaemonSets ignore this. |
| controller.type | string | `"deployment"` | Set the controller type. Valid options are deployment, daemonset, statefulset, cronjob or job |
| dnsConfig | object | `{}` | Optional DNS settings, configuring the ndots option may resolve nslookup issues on some Kubernetes setups. |
| dnsPolicy | string | `nil` | Defaults to "ClusterFirst" if hostNetwork is false and "ClusterFirstWithHostNet" if hostNetwork is true. |
| enableServiceLinks | bool | `true` | Enable/disable the generation of environment variables for services. [[ref]](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#accessing-the-service) |
| env | string | `nil` | Main environment variables. Template enabled. Syntax options: A) TZ: UTC B) PASSWD: '{{ .Release.Name }}' C) PASSWD:      configMapKeyRef:        name: config-map-name        key: key-name D) PASSWD:      valueFrom:        secretKeyRef:          name: secret-name          key: key-name      ... E) - name: TZ      value: UTC F) - name: TZ      value: '{{ .Release.Name }}' |
| envFrom | list | `[]` | Secrets and/or ConfigMaps that will be loaded as environment variables. [[ref]](https://unofficial-kubernetes.readthedocs.io/en/latest/tasks/configure-pod-container/configmap/#use-case-consume-configmap-in-environment-variables) |
| externalSecrets | object | See below | Configure ExternalSecrets (External Secrets Operator) for the chart here. Each key creates an `ExternalSecret` that syncs from an existing SecretStore/ClusterSecretStore into a Kubernetes Secret. The store itself is NOT created by this chart. Additional items can be added by adding a dictionary key similar to 'main'. |
| externalSecrets.main.annotations | object | `{}` | Annotations to add to the ExternalSecret |
| externalSecrets.main.data | list | `[]` | Pull individual keys from a remote secret. [[ref]](https://external-secrets.io/latest/api/externalsecret/) |
| externalSecrets.main.dataFrom | list | `[]` | Pull entire remote secrets. [[ref]](https://external-secrets.io/latest/api/externalsecret/) |
| externalSecrets.main.enabled | bool | `false` | Enables or disables the ExternalSecret |
| externalSecrets.main.labels | object | `{}` | Labels to add to the ExternalSecret |
| externalSecrets.main.nameOverride | string | `nil` | Override the name suffix used for this ExternalSecret (and its target Secret) |
| externalSecrets.main.refreshInterval | string | `"1h"` | How often the operator reconciles the secret. Omitted from output if empty. |
| externalSecrets.main.secretStoreRef | object | `{"kind":"ClusterSecretStore","name":null}` | Reference to an existing SecretStore or ClusterSecretStore. |
| externalSecrets.main.secretStoreRef.kind | string | `"ClusterSecretStore"` | Kind of store. Options: `ClusterSecretStore` (default) or `SecretStore`. |
| externalSecrets.main.secretStoreRef.name | string | `nil` | Name of the (Cluster)SecretStore. Required when enabled. |
| externalSecrets.main.target | object | See below | Target Kubernetes Secret configuration. |
| externalSecrets.main.target.creationPolicy | string | `"Owner"` | creationPolicy for the target Secret. Options: Owner (default), Orphan, Merge, None. |
| externalSecrets.main.target.deletionPolicy | string | `nil` | deletionPolicy for the target Secret. Options: Retain, Delete, Merge. |
| externalSecrets.main.target.secretName | string | `nil` | Name of the resulting Secret. Defaults to the ExternalSecret name. |
| externalSecrets.main.target.template | object | `{}` | Template used to shape the resulting Secret (e.g. build a connection string). |
| global.annotations | object | `{}` | Set additional global annotations. Helm templates can be used. |
| global.fullnameOverride | string | `nil` | Set the entire name definition |
| global.labels | object | `{}` | Set additional global labels. Helm templates can be used. |
| global.nameOverride | string | `nil` | Set an override for the prefix of the fullname |
| hostAliases | list | `[]` | Use hostAliases to add custom entries to /etc/hosts - mapping IP addresses to hostnames. [[ref]](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/) |
| hostNetwork | bool | `false` | When using hostNetwork make sure you set dnsPolicy to `ClusterFirstWithHostNet` |
| hostname | string | `nil` | Allows specifying explicit hostname setting |
| image.pullPolicy | string | `nil` | image pull policy |
| image.repository | string | `nil` | image repository |
| image.tag | string | `nil` | image tag |
| imagePullSecrets | list | `[]` | Set image pull secrets |
| ingress | object | See below | Configure the ingresses for the chart here. Additional ingresses can be added by adding a dictionary key similar to the 'main' ingress. |
| ingress.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| ingress.main.enabled | bool | `false` | Enables or disables the ingress |
| ingress.main.hosts[0].host | string | `"chart-example.local"` | Host address. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].path | string | `"/"` | Path.  Helm template can be passed. |
| ingress.main.hosts[0].paths[0].pathType | string | `"Prefix"` | Ignored if not kubeVersion >= 1.14-0 |
| ingress.main.hosts[0].paths[0].service.name | string | `nil` | Overrides the service name reference for this path |
| ingress.main.hosts[0].paths[0].service.port | string | `nil` | Overrides the service port reference for this path |
| ingress.main.ingressClassName | string | `nil` | Set the ingressClass that is used for this ingress. Requires Kubernetes >=1.19 |
| ingress.main.labels | object | `{}` | Provide additional labels which may be required. |
| ingress.main.nameOverride | string | `nil` | Override the name suffix that is used for this ingress. |
| ingress.main.primary | bool | `true` | Make this the primary ingress (used in probes, notes, etc...). If there is more than 1 ingress, make sure that only 1 ingress is marked as primary. |
| ingress.main.tls | list | `[]` | Configure TLS for the ingress. Both secretName and hosts can process a Helm template. |
| initContainers | object | `{}` | Specify any initContainers here as dictionary items. Each initContainer should have its own key. The dictionary item key will determine the order. Helm templates can be used. |
| lifecycle | object | `{}` | Configure the lifecycle for the main container |
| nodeSelector | object | `{}` | Node selection constraint [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistence | object | See below | Configure persistence for the chart here. Additional items can be added by adding a dictionary key similar to the 'config' key. [[ref]](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) |
| persistence.config | object | See below | Default persistence for configuration files. |
| persistence.config.accessMode | string | `"ReadWriteOnce"` | AccessMode for the persistent volume. Make sure to select an access mode that is supported by your storage provider! [[ref]](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) |
| persistence.config.enabled | bool | `false` | Enables or disables the persistence item |
| persistence.config.existingClaim | string | `nil` | If you want to reuse an existing claim, the name of the existing PVC can be passed here. |
| persistence.config.mountPath | string | `nil` | Where to mount the volume in the main container. Defaults to `/<name_of_the_volume>`, setting to '-' creates the volume but disables the volumeMount. |
| persistence.config.nameOverride | string | `nil` | Override the name suffix that is used for this volume. |
| persistence.config.readOnly | bool | `false` | Specify if the volume should be mounted read-only. |
| persistence.config.retain | bool | `false` | Set to true to retain the PVC upon `helm uninstall` |
| persistence.config.size | string | `"1Gi"` | The amount of storage that is requested for the persistent volume. |
| persistence.config.storageClass | string | `nil` | Storage Class for the config volume. If set to `-`, dynamic provisioning is disabled. If set to something else, the given storageClass is used. If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner. |
| persistence.config.subPath | string | `nil` | Used in conjunction with `existingClaim`. Specifies a sub-path inside the referenced volume instead of its root |
| persistence.config.type | string | `"pvc"` | Sets the persistence type Valid options are pvc, emptyDir, hostPath, secret, configMap or custom |
| persistence.shared | object | See below | Create an emptyDir volume to share between all containers [[ref]]https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) |
| persistence.shared.medium | string | `nil` | Set the medium to "Memory" to mount a tmpfs (RAM-backed filesystem) instead of the storage medium that backs the node. |
| persistence.shared.sizeLimit | string | `nil` | If the `SizeMemoryBackedVolumes` feature gate is enabled, you can specify a size for memory backed volumes. |
| podAnnotations | object | `{}` | Set annotations on the pod |
| podDisruptionBudget | object | <disabled> | Add a PodDisruptionBudget for the controller's pods. Set only one of `minAvailable` or `maxUnavailable`. If neither is set, `minAvailable: 1` is used. The selector is wired to the chart's pods. |
| podDisruptionBudget.annotations | object | `{}` | Annotations to add to the PodDisruptionBudget |
| podDisruptionBudget.labels | object | `{}` | Labels to add to the PodDisruptionBudget |
| podDisruptionBudget.maxUnavailable | string | `nil` | Maximum number/percentage of pods that can be unavailable. |
| podDisruptionBudget.minAvailable | string | `nil` | Minimum number/percentage of pods that must remain available. |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `nil` | Eviction policy for unhealthy pods (Kubernetes >=1.27). Options: IfHealthyBudget (default), AlwaysAllow. |
| podLabels | object | `{}` | Set labels on the pod |
| podMonitor | object | <disabled> | Add a Prometheus Operator PodMonitor. Selector and namespaceSelector are wired to the chart's pods automatically. Requires the Prometheus Operator CRDs. |
| podMonitor.annotations | object | `{}` | Annotations to add to the PodMonitor. |
| podMonitor.jobLabel | string | `nil` | jobLabel to use for the scrape job. |
| podMonitor.labels | object | `{}` | Extra labels (e.g. `release: kube-prometheus-stack`). |
| podMonitor.podMetricsEndpoints | list | `[]` | Pod scrape endpoints. Required when enabled. |
| podSecurityContext | object | `{}` | Configure the Security Context for the Pod |
| priorityClassName | string | `nil` | Custom priority class for different treatment by the scheduler |
| probes | object | See below | [[ref]](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| probes.liveness | object | See below | Liveness probe configuration |
| probes.liveness.custom | bool | `false` | Set this to `true` if you wish to specify your own livenessProbe |
| probes.liveness.enabled | bool | `true` | Enable the liveness probe |
| probes.liveness.spec | object | See below | The spec field contains the values for the default livenessProbe. If you selected `custom: true`, this field holds the definition of the livenessProbe. |
| probes.readiness | object | See below | Readiness probe configuration |
| probes.readiness.custom | bool | `false` | Set this to `true` if you wish to specify your own readinessProbe |
| probes.readiness.enabled | bool | `true` | Enable the readiness probe |
| probes.readiness.spec | object | See below | The spec field contains the values for the default readinessProbe. If you selected `custom: true`, this field holds the definition of the readinessProbe. |
| probes.startup | object | See below | Startup probe configuration |
| probes.startup.custom | bool | `false` | Set this to `true` if you wish to specify your own startupProbe |
| probes.startup.enabled | bool | `true` | Enable the startup probe |
| probes.startup.spec | object | See below | The spec field contains the values for the default startupProbe. If you selected `custom: true`, this field holds the definition of the startupProbe. |
| rbac | object | See below | Configure RBAC for the chart here. Each key creates a Role/ClusterRole (with the given rules) plus a matching binding wired to the chart's ServiceAccount. Set an existing role to bind to it instead of creating one. Typically used together with `serviceAccount.create: true`. |
| rbac.main.annotations | object | `{}` | Annotations to add to the role and binding |
| rbac.main.enabled | bool | `false` | Enables or disables this RBAC item |
| rbac.main.existingRole | string | `nil` | Bind to this existing (Cluster)Role instead of creating one. When set, `rules` is ignored and no role is created. |
| rbac.main.labels | object | `{}` | Labels to add to the role and binding |
| rbac.main.nameOverride | string | `nil` | Override the name suffix used for the role and binding. |
| rbac.main.rules | list | `[]` | Policy rules. Required unless `existingRole` is set. |
| rbac.main.type | string | `"Role"` | Role scope. Options: `Role` (namespaced) or `ClusterRole`. |
| resources | object | `{}` | Set the resource requests / limits for the main container. |
| runtimeClassName | string | `nil` | Allow specifying a runtimeClassName other than the default one (ie: nvidia) |
| schedulerName | string | `nil` | Allows specifying a custom scheduler name |
| secret | object | `{}` | Use this to populate a secret with the values you specify. Be aware that these values are not encrypted by default, and could therefore visible to anybody with access to the values.yaml file. |
| securityContext | object | `{}` | Configure the Security Context for the main container |
| service | object | See below | Configure the services for the chart here. Additional services can be added by adding a dictionary key similar to the 'main' service. |
| service.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| service.main.enabled | bool | `true` | Enables or disables the service |
| service.main.externalTrafficPolicy | string | `nil` | [[ref](https://kubernetes.io/docs/tutorials/services/source-ip/)] |
| service.main.ipFamilies | list | `[]` | The ip families that should be used. Options: IPv4, IPv6 |
| service.main.ipFamilyPolicy | string | `nil` | Specify the ip policy. Options: SingleStack, PreferDualStack, RequireDualStack |
| service.main.labels | object | `{}` | Provide additional labels which may be required. |
| service.main.nameOverride | string | `nil` | Override the name suffix that is used for this service |
| service.main.ports | object | See below | Configure the Service port information here. Additional ports can be added by adding a dictionary key similar to the 'http' service. |
| service.main.ports.http.enabled | bool | `true` | Enables or disables the port |
| service.main.ports.http.nodePort | string | `nil` | Specify the nodePort value for the LoadBalancer and NodePort service types. [[ref]](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) |
| service.main.ports.http.port | string | `nil` | The port number |
| service.main.ports.http.primary | bool | `true` | Make this the primary port (used in probes, notes, etc...) If there is more than 1 service, make sure that only 1 port is marked as primary. |
| service.main.ports.http.protocol | string | `"HTTP"` | Port protocol. Support values are `HTTP`, `HTTPS`, `TCP` and `UDP`. HTTPS and HTTPS spawn a TCP service and get used for internal URL and name generation |
| service.main.ports.http.targetPort | string | `nil` | Specify a service targetPort if you wish to differ the service port from the application port. If `targetPort` is specified, this port number is used in the container definition instead of the `port` value. Therefore named ports are not supported for this field. |
| service.main.primary | bool | `true` | Make this the primary service (used in probes, notes, etc...). If there is more than 1 service, make sure that only 1 service is marked as primary. |
| service.main.type | string | `"ClusterIP"` | Set the service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceMonitor | object | <disabled> | Add a Prometheus Operator ServiceMonitor. Selector and namespaceSelector are wired to the chart's service automatically. Requires the Prometheus Operator CRDs. |
| serviceMonitor.annotations | object | `{}` | Annotations to add to the ServiceMonitor. |
| serviceMonitor.endpoints | list | `[]` | Scrape endpoints. If empty, a single endpoint is derived from the primary service port using `path`/`interval` below. |
| serviceMonitor.interval | string | `nil` | Default scrape interval for the derived endpoint. |
| serviceMonitor.jobLabel | string | `nil` | jobLabel to use for the scrape job. |
| serviceMonitor.labels | object | `{}` | Extra labels (e.g. `release: kube-prometheus-stack` for Prometheus selection). |
| serviceMonitor.path | string | `nil` | Default scrape path for the derived endpoint. |
| serviceMonitor.scrapeTimeout | string | `nil` | Default scrape timeout for the derived endpoint. |
| serviceMonitor.targetLabels | list | `[]` | Service labels to transfer onto the scraped target. |
| termination.gracePeriodSeconds | string | `nil` | [[ref](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle)] |
| termination.messagePath | string | `nil` | [[ref](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle-1)] |
| termination.messagePolicy | string | `nil` | [[ref](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle-1)] |
| tolerations | list | `[]` | Specify taint tolerations [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| topologySpreadConstraints | list | `[]` | Defines topologySpreadConstraint rules. [[ref]](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/) |
| volumeClaimTemplates | list | `[]` | Used in conjunction with `controller.type: statefulset` to create individual disks for each instance. |

## Changelog

All notable changes to this library Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [5.5.0]

#### Added

- `rbac` block — create Role/ClusterRole plus a matching RoleBinding/ClusterRoleBinding wired to the chart's ServiceAccount. Supply `rules`, or bind to an `existingRole`.

### [5.4.0]

#### Added

- `serviceMonitor` and `podMonitor` blocks — render Prometheus Operator `ServiceMonitor`/`PodMonitor` resources with selector and namespaceSelector wired to the chart automatically. ServiceMonitor derives a default endpoint from the primary service port when none is given.

### [5.3.0]

#### Added

- `podDisruptionBudget` block — render a `policy/v1` PodDisruptionBudget whose selector is wired to the chart's pods. Set `minAvailable` or `maxUnavailable` (defaults to `minAvailable: 1`).

### [5.2.0]

#### Added

- `controller.type: cronjob` and `controller.type: job` — render `batch/v1` CronJob/Job resources reusing the existing pod and container templating. New `controller.cronjob`, `controller.job`, and `controller.restartPolicy` value blocks.

### [5.1.0]

#### Added

- Support for ExternalSecrets (External Secrets Operator). Declare `external-secrets.io/v1` `ExternalSecret` resources via the new `externalSecrets` dictionary. Each entry references an existing SecretStore/ClusterSecretStore and supports `data`, `dataFrom`, and `target.template`.

### [5.0.1]

#### Fixed

- StatefulSet `podLabels` are now processed through `tpl`, matching Deployment and DaemonSet.
- Container ports gathered from multiple services are de-duplicated to avoid duplicate `containerPort`/port-name entries that Kubernetes rejects.
- NOTES output: ingress host/path are templated and `https` is detected correctly for TLS-enabled ingresses.

### [5.0.0]

#### Changed

- **BREAKING**: Removed all add-ons (VPN, code-server, promtail, netshoot). Use dedicated sidecar containers via `additionalContainers` instead.
- **BREAKING**: Default Deployment strategy changed from `Recreate` to `RollingUpdate`.
- Updated minimum Kubernetes version to `>=1.23.0-0` (required for `autoscaling/v2`).
- Rebranded chart — removed all k8s-at-home references. This is now a general-purpose library chart.

#### Added

- Support for `controller.progressDeadlineSeconds` on Deployments.

### [4.5.9]

#### Changed
- Update HPA to support new k8s versions (fix)

### [4.5.8]

#### Changed
- Update HPA to support new k8s versions (fix)

### [4.5.7]

#### Changed
- Update HPA to support new k8s versions

### [4.5.6]

#### Changed
- Disable replicas on deployments when HPA is set

### [4.5.2]

#### Fixed

- Fixed environment variable processing logic for main container when initContainers or additionalContainers were set.

### [4.5.1]

#### Fixed

- Fixed environment variable processing logic for initContainers and additionalContainers.

### [4.5.0]

#### Added

- Support checksum/config annotations for configMaps to automate roll deployments/daemonsets/statefulsets after config changes.

#### Fixed

- `valueFrom` now works correctly when `env` is a list of variables.

[5.5.0]: #550
[5.4.0]: #540
[5.3.0]: #530
[5.2.0]: #520
[5.1.0]: #510
[5.0.1]: #501
[5.0.0]: #500
[4.5.9]: #459

## Support

- Open an [issue](https://github.com/manelpb/library-charts/issues/new/choose)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
