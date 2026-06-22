{{/*
This template serves as a blueprint for RBAC objects (Role/ClusterRole and the
matching binding) created within the common library. The binding always wires
the role to the chart's ServiceAccount.
*/}}
{{- define "common.classes.rbac" -}}
  {{- $values := .ObjectValues.rbac -}}
  {{- $key := $values.nameOverride -}}
  {{- $name := printf "%s-%s" (include "common.names.fullname" .) $key -}}
  {{- $type := $values.type | default "Role" -}}
  {{- if not (or (eq $type "Role") (eq $type "ClusterRole")) -}}
    {{- fail (printf "rbac %s: type must be Role or ClusterRole" $key) -}}
  {{- end -}}
  {{- $bindingType := ternary "ClusterRoleBinding" "RoleBinding" (eq $type "ClusterRole") -}}
  {{- $roleName := $values.existingRole | default $name -}}
  {{- if and (not $values.existingRole) (not $values.rules) -}}
    {{- fail (printf "rbac %s: rules are required when not using existingRole" $key) -}}
  {{- end -}}
  {{- if not $values.existingRole }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: {{ $type }}
metadata:
  name: {{ $name }}
  {{- if eq $type "Role" }}
  namespace: {{ .Release.Namespace }}
  {{- end }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
rules:
  {{- toYaml $values.rules | nindent 2 }}
  {{- end }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: {{ $bindingType }}
metadata:
  name: {{ $name }}
  {{- if eq $bindingType "RoleBinding" }}
  namespace: {{ .Release.Namespace }}
  {{- end }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: {{ $type }}
  name: {{ $roleName }}
subjects:
  - kind: ServiceAccount
    name: {{ include "common.names.serviceAccountName" . }}
    namespace: {{ .Release.Namespace }}
{{- end }}

{{/*
Renders the RBAC objects required by the chart.
*/}}
{{- define "common.rbac" -}}
  {{- range $name, $rbac := .Values.rbac }}
    {{- if $rbac.enabled -}}
      {{- $rbacValues := $rbac -}}
      {{- if not $rbacValues.nameOverride -}}
        {{- $_ := set $rbacValues "nameOverride" $name -}}
      {{ end -}}
      {{- $_ := set $ "ObjectValues" (dict "rbac" $rbacValues) -}}
      {{- include "common.classes.rbac" $ }}
    {{- end }}
  {{- end }}
{{- end }}
