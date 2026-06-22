{{/*
This template serves as the blueprint for the CronJob objects that are created
within the common library.
*/}}
{{- define "common.cronjob" }}
{{- $cron := .Values.controller.cronjob | default dict -}}
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ include "common.names.fullname" . }}
  {{- with (merge (.Values.controller.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge (.Values.controller.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  schedule: {{ required "controller.cronjob.schedule is required when controller.type is cronjob" $cron.schedule | quote }}
  {{- with $cron.timeZone }}
  timeZone: {{ . | quote }}
  {{- end }}
  {{- with $cron.concurrencyPolicy }}
  concurrencyPolicy: {{ . }}
  {{- end }}
  {{- with $cron.startingDeadlineSeconds }}
  startingDeadlineSeconds: {{ . }}
  {{- end }}
  {{- if kindIs "bool" $cron.suspend }}
  suspend: {{ $cron.suspend }}
  {{- end }}
  {{- if not (kindIs "invalid" $cron.successfulJobsHistoryLimit) }}
  successfulJobsHistoryLimit: {{ $cron.successfulJobsHistoryLimit }}
  {{- end }}
  {{- if not (kindIs "invalid" $cron.failedJobsHistoryLimit) }}
  failedJobsHistoryLimit: {{ $cron.failedJobsHistoryLimit }}
  {{- end }}
  jobTemplate:
    spec:
      {{- with (include "common.controller.jobSpec" . | trim) }}
      {{- . | nindent 6 }}
      {{- end }}
      template:
        {{- include "common.controller.jobPodTemplate" . | nindent 8 }}
{{- end }}
