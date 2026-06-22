{{/*
Shared batch/v1 JobSpec fields, used by both the Job controller and the
CronJob's jobTemplate. Numeric fields use an explicit nil check so a value of
0 (e.g. ttlSecondsAfterFinished: 0) is still rendered.
*/}}
{{- define "common.controller.jobSpec" -}}
{{- $job := .Values.controller.job | default dict -}}
{{- if not (kindIs "invalid" $job.backoffLimit) }}
backoffLimit: {{ $job.backoffLimit }}
{{- end }}
{{- if not (kindIs "invalid" $job.completions) }}
completions: {{ $job.completions }}
{{- end }}
{{- if not (kindIs "invalid" $job.parallelism) }}
parallelism: {{ $job.parallelism }}
{{- end }}
{{- with $job.activeDeadlineSeconds }}
activeDeadlineSeconds: {{ . }}
{{- end }}
{{- if not (kindIs "invalid" $job.ttlSecondsAfterFinished) }}
ttlSecondsAfterFinished: {{ $job.ttlSecondsAfterFinished }}
{{- end }}
{{- with $job.completionMode }}
completionMode: {{ . }}
{{- end }}
{{- end -}}

{{/*
The pod template metadata shared by Job and CronJob controllers.
*/}}
{{- define "common.controller.jobPodTemplate" -}}
metadata:
  {{- with include ("common.podAnnotations") . }}
  annotations:
    {{- . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "common.labels.selectorLabels" . | nindent 4 }}
    {{- with .Values.podLabels }}
    {{- tpl (toYaml .) $ | nindent 4 }}
    {{- end }}
spec:
  {{- include "common.controller.pod" . | nindent 2 }}
{{- end -}}

{{/*
This template serves as the blueprint for the Job objects that are created
within the common library.
*/}}
{{- define "common.job" }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "common.names.fullname" . }}
  {{- with (merge (.Values.controller.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge (.Values.controller.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with (include "common.controller.jobSpec" . | trim) }}
  {{- . | nindent 2 }}
  {{- end }}
  template:
    {{- include "common.controller.jobPodTemplate" . | nindent 4 }}
{{- end }}
