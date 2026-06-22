{{/*
The Prometheus Operator PodMonitor object to be created.
*/}}
{{- define "common.podMonitor" -}}
  {{- if .Values.podMonitor.enabled -}}
    {{- $pm := .Values.podMonitor -}}
    {{- if not $pm.podMetricsEndpoints -}}
      {{- fail "podMonitor.podMetricsEndpoints is required when podMonitor is enabled" -}}
    {{- end }}
---
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: {{ include "common.names.fullname" . }}
  {{- with (merge ($pm.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($pm.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  selector:
    matchLabels:
      {{- include "common.labels.selectorLabels" . | nindent 6 }}
  namespaceSelector:
    matchNames:
      - {{ .Release.Namespace }}
  podMetricsEndpoints:
    {{- toYaml $pm.podMetricsEndpoints | nindent 4 }}
  {{- with $pm.jobLabel }}
  jobLabel: {{ . }}
  {{- end }}
  {{- end -}}
{{- end -}}
