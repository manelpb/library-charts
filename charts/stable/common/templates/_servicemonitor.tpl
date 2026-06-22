{{/*
The Prometheus Operator ServiceMonitor object to be created.
*/}}
{{- define "common.serviceMonitor" -}}
  {{- if .Values.serviceMonitor.enabled -}}
    {{- $sm := .Values.serviceMonitor -}}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "common.names.fullname" . }}
  {{- with (merge ($sm.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($sm.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  selector:
    matchLabels:
      {{- include "common.labels.selectorLabels" . | nindent 6 }}
  namespaceSelector:
    matchNames:
      - {{ .Release.Namespace }}
  endpoints:
    {{- if $sm.endpoints }}
    {{- toYaml $sm.endpoints | nindent 4 }}
    {{- else }}
    {{- $primaryService := get .Values.service (include "common.service.primary" .) -}}
    {{- if not $primaryService }}
      {{- fail "serviceMonitor: set serviceMonitor.endpoints or enable a service to derive an endpoint from" }}
    {{- end }}
    {{- $portName := include "common.classes.service.ports.primary" (dict "serviceName" (include "common.service.primary" .) "values" $primaryService) }}
    - port: {{ $portName }}
      path: {{ $sm.path | default "/metrics" }}
      interval: {{ $sm.interval | default "30s" }}
      {{- with $sm.scrapeTimeout }}
      scrapeTimeout: {{ . }}
      {{- end }}
    {{- end }}
  {{- with $sm.jobLabel }}
  jobLabel: {{ . }}
  {{- end }}
  {{- with $sm.targetLabels }}
  targetLabels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- end -}}
{{- end -}}
