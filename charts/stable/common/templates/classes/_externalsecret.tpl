{{/*
This template serves as a blueprint for all ExternalSecret objects (External
Secrets Operator) that are created within the common library.
*/}}
{{- define "common.classes.externalsecret" -}}
  {{- $fullName := include "common.names.fullname" . -}}
  {{- $secretName := $fullName -}}
  {{- $values := .Values.externalSecrets -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.externalsecret -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $secretName = printf "%v-%v" $secretName $values.nameOverride -}}
  {{- end -}}

  {{- $storeRef := $values.secretStoreRef | default dict -}}
  {{- $target := $values.target | default dict }}
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ $secretName }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with $values.refreshInterval }}
  refreshInterval: {{ . }}
  {{- end }}
  secretStoreRef:
    name: {{ required (printf "secretStoreRef.name is required for externalSecret %s" $secretName) $storeRef.name }}
    kind: {{ $storeRef.kind | default "ClusterSecretStore" }}
  target:
    name: {{ $target.secretName | default $secretName }}
    creationPolicy: {{ $target.creationPolicy | default "Owner" }}
    {{- with $target.deletionPolicy }}
    deletionPolicy: {{ . }}
    {{- end }}
    {{- with $target.template }}
    template:
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- with $values.dataFrom }}
  dataFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $values.data }}
  data:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if and (not $values.dataFrom) (not $values.data) }}
  data: []
  {{- end }}
{{- end }}
