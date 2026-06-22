{{/*
Renders the ExternalSecret objects required by the chart.
*/}}
{{- define "common.externalsecret" -}}
  {{- /* Generate named externalSecrets as required */ -}}
  {{- range $name, $externalSecret := .Values.externalSecrets }}
    {{- if $externalSecret.enabled -}}
      {{- $externalSecretValues := $externalSecret -}}

      {{/* set the default nameOverride to the externalSecret name */}}
      {{- if not $externalSecretValues.nameOverride -}}
        {{- $_ := set $externalSecretValues "nameOverride" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "externalsecret" $externalSecretValues) -}}
      {{- include "common.classes.externalsecret" $ }}
    {{- end }}
  {{- end }}
{{- end }}
