{{- define "eric-log4shell-patch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create image registry url
*/}}
{{- define "eric-log4shell-patch.registryUrl" -}}
     {{- $registryUrl := .Values.defaultRegistry -}}
     {{- if .Values.global -}}
         {{- if .Values.global.registry -}}
             {{- if .Values.global.registry.url -}}
                 {{- $registryUrl = .Values.global.registry.url -}}
             {{- end -}}
         {{- end -}}
     {{- end -}}
     {{- if .Values.imageCredentials.registry -}}
         {{- if .Values.imageCredentials.registry.url -}}
           {{- $registryUrl = .Values.imageCredentials.registry.url -}}
         {{- end -}}
     {{- end -}}
     {{- print $registryUrl -}}
{{- end -}}
