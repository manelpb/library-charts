{{/*
The PodDisruptionBudget object to be created.
*/}}
{{- define "common.podDisruptionBudget" -}}
  {{- if .Values.podDisruptionBudget.enabled -}}
    {{- $pdb := .Values.podDisruptionBudget -}}
    {{- if and (not (kindIs "invalid" $pdb.minAvailable)) (not (kindIs "invalid" $pdb.maxUnavailable)) -}}
      {{- fail "podDisruptionBudget: set only one of minAvailable or maxUnavailable" -}}
    {{- end }}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "common.names.fullname" . }}
  {{- with (merge ($pdb.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($pdb.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if not (kindIs "invalid" $pdb.maxUnavailable) }}
  maxUnavailable: {{ $pdb.maxUnavailable }}
  {{- else }}
  minAvailable: {{ $pdb.minAvailable | default 1 }}
  {{- end }}
  {{- with $pdb.unhealthyPodEvictionPolicy }}
  unhealthyPodEvictionPolicy: {{ . }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "common.labels.selectorLabels" . | nindent 6 }}
  {{- end -}}
{{- end -}}
