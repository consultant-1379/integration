{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "eric-adp-5g-udm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eric-adp-5g-udm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart version as used by the chart label.
*/}}
{{- define "eric-adp-5g-udm.version" -}}
{{- printf "%s" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the resource name for the log-shipper.
*/}}
{{- define "eric-adp-5g-udm.log-shipper.name" -}}
{{- default (printf "%s-log-shipper" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-log-shipper" "logshipper" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the resource name for the pm-server.
*/}}
{{- define "eric-adp-5g-udm.pm-server.serviceaccount.name" }}
{{- if not (index .Values "eric-pm-server" "rbac" "appMonitoring" "enabled") }}
  {{- if .Values.global.security }}
    {{- if .Values.global.security.policyBinding }}
      {{- if .Values.global.security.policyBinding.create }}
        {{- default (printf "eric-pm-server") | trunc 63 | trimSuffix "-" -}}
      {{- else }}
        {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}
      {{- end }}
    {{- else }}
      {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}
    {{- end }}
  {{- else }}
    {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- else }}
  {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
Create the resource name for the pm-server.
*/}}
{{- define "eric-adp-5g-udm.pm-server.clusterrole.name" }}
{{- if not (index .Values "eric-pm-server" "rbac" "appMonitoring" "enabled") }}
  {{- if .Values.global.security }}
    {{- if .Values.global.security.policyBinding }}
      {{- if .Values.global.security.policyBinding.create }}
        {{- default (printf "eric-pm-server") | trunc 63 | trimSuffix "-" -}}-{{ .Release.Namespace }}
      {{- else }}
        {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}-{{ .Release.Namespace }}
      {{- end }}
    {{- else }}
      {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}-{{ .Release.Namespace }}
    {{- end }}
  {{- else }}
    {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}-{{ .Release.Namespace }}
  {{- end }}
{{- else }}
  {{- default (printf "%s-pm-server" (include "eric-adp-5g-udm.name" .)) (index .Values "eric-pm-server" "server" "serviceAccountName") | trunc 63 | trimSuffix "-" -}}-{{ .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "eric-adp-5g-udm.eric-pm-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Handle prefixURL and baseURL values
*/}}
{{- define "eric-adp-5g-udm.eric-pm-server.prefix" -}}
  {{- $prefix := "" }}
  {{- if (index .Values "eric-pm-server" "server" "prefixURL") -}}
    {{- $prefix = (index .Values "eric-pm-server" "server" "prefixURL") -}}
  {{- else }}
    {{- if (index .Values "eric-pm-server" "server" "baseURL") -}}
      {{- $baseURLDict := urlParse (index .Values "eric-pm-server" "server" "baseURL") -}}
      {{- $prefix = get $baseURLDict "path" -}}
    {{- end -}}
  {{- end -}}
  {{- printf "%s" $prefix -}}
{{- end -}}
