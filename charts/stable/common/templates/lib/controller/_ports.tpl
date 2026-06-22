{{/*
Ports included by the controller.

Container ports are gathered from every enabled service port. Because multiple
services frequently expose the same application port, the list is de-duplicated:
a port is skipped if its name, or its containerPort+protocol pair, was already
emitted. This keeps the rendered container ports valid (Kubernetes rejects
duplicate port names and duplicate containerPort/protocol pairs).
*/}}
{{- define "common.controller.ports" -}}
  {{- $ports := list -}}
  {{- $seenNames := dict -}}
  {{- $seenPorts := dict -}}
  {{- range .Values.service -}}
    {{- if .enabled -}}
      {{- range $name, $port := .ports -}}
        {{- if $port.enabled -}}
          {{- $_ := set $port "name" $name -}}
          {{- $containerPort := $port.targetPort | default $port.port -}}
          {{- $protocol := $port.protocol | default "TCP" -}}
          {{- if or (eq $protocol "HTTP") (eq $protocol "HTTPS") (eq $protocol "TCP") -}}
            {{- $protocol = "TCP" -}}
          {{- end -}}
          {{- $portKey := printf "%v/%s" $containerPort $protocol -}}
          {{- if and (not (hasKey $seenNames $name)) (not (hasKey $seenPorts $portKey)) -}}
            {{- $_ := set $seenNames $name true -}}
            {{- $_ := set $seenPorts $portKey true -}}
            {{- $ports = append $ports $port -}}
          {{- end -}}
        {{- end -}}
      {{- end }}
    {{- end }}
  {{- end }}

{{/* export/render the list of ports */}}
{{- if $ports -}}
{{- range $_ := $ports }}
- name: {{ .name }}
  {{- if and .targetPort (kindIs "string" .targetPort) }}
  {{- fail (printf "Our charts do not support named ports for targetPort. (port name %s, targetPort %s)" .name .targetPort) }}
  {{- end }}
  containerPort: {{ .targetPort | default .port }}
  {{- if .protocol }}
  {{- if or ( eq .protocol "HTTP" ) ( eq .protocol "HTTPS" ) ( eq .protocol "TCP" ) }}
  protocol: TCP
  {{- else }}
  protocol: {{ .protocol }}
  {{- end }}
  {{- else }}
  protocol: TCP
  {{- end }}
{{- end -}}
{{- end -}}
{{- end -}}
