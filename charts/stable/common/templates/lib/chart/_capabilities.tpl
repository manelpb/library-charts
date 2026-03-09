{{/* Allow KubeVersion to be overridden. */}}
{{- define "common.capabilities.ingress.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/* Return the appropriate apiVersion for Ingress objects */}}
{{- define "common.capabilities.ingress.apiVersion" -}}
  {{- print "networking.k8s.io/v1" -}}
{{- end -}}

{{/* Check Ingress stability */}}
{{- define "common.capabilities.ingress.isStable" -}}
  {{- true -}}
{{- end -}}
