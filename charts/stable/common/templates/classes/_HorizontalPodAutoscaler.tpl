{{/*
This template serves as a blueprint for horizontal pod autoscaler objects that are created
using the common library.
*/}}
{{- define "common.classes.hpa" -}}
  {{- if .Values.autoscaling.enabled -}}
    {{- $hpaName := include "common.names.fullname" . -}}
    {{- $targetName := include "common.names.fullname" . }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $hpaName }}
  labels: {{- include "common.labels" $ | nindent 4 }}
  annotations: {{- include "common.annotations" $ | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ include "common.names.controllerType" . }}
    name: {{ .Values.autoscaling.target | default $targetName }}
  minReplicas: {{ .Values.autoscaling.minReplicas | default 1 }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas | default 3 }}
  metrics:
    {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
          type: Utilization
    {{- end }}
    {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
          type: Utilization
    {{- end }}
  {{- end -}}
{{- end -}}
