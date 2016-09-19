#!/usr/bin/env bash

cat << EOF > ${SERVICE_VOLUME}/confd/etc/conf.d/go-dnsmasq-source.toml
[template]
src = "go-dnsmasq-source.tmpl"
dest = "${SERVICE_HOME}/etc/go-dnsmasq-source"
owner = "${SERVICE_USER}"
mode = "0644"
keys = [
  "/stacks",
]
EOF

cat << EOF > ${SERVICE_VOLUME}/confd/etc/templates/go-dnsmasq-source.tmpl
#!/usr/bin/env bash

export STUB_ZONES="
{{- \$first := "0" -}}
{{- range \$i, \$stack := ls "/stacks" -}}
  {{- range \$i2, \$service := ls (printf "/stacks/%s/services" \$stack) -}}
    {{- if exists (printf "/stacks/%s/services/%s/labels/io.skydns.domain" \$stack \$service) -}}
      {{- if eq \$first "1" -}},{{- end -}}
      {{- if eq \$first "0" -}}{{- \$first := "1" -}}{{- end -}}
      {{- \$domain := getv (printf "/stacks/%s/services/%s/labels/io.skydns.domain" \$stack \$service) -}}
      {{- range \$i3, \$container := ls (printf "/stacks/%s/services/%s/containers" \$stack \$service) -}}
        {{- if \$i3 -}},{{- end -}}
        {{- \$domain -}}/{{- getv (printf "/stacks/%s/services/%s/containers/%s/primary_ip" \$stack \$service \$container) -}}
      {{- end -}}
    {{- end -}}
  {{- end }}
{{- end }}"
export DNSMASQ_LISTEN=${DNSMASQ_LISTEN:-"0.0.0.0:53"}
export DNSMASQ_ENABLE_SEARCH=${DNSMASQ_ENABLE_SEARCH:-"true"}
if [ "${DNSMASQ_ENABLE_SEARCH}" == "false" ]; then
	export DNSMASQ_SEARCH_DOMAINS="" 
else
	DNSMASQ_SEARCH_DOMAINS=${DNSMASQ_SEARCH_DOMAINS:-""}
	for i in $(echo ${STUB_ZONES} | sed -e s'/,/ /g'); do 
		domain=$(echo $i | cut -d"/" -f1; done)
		if [ $(echo ${DNSMASQ_SEARCH_DOMAINS} | grep -w ${domain} ; echo $?) -eq 1 ]; then
			if [ DNSMASQ_SEARCH_DOMAINS="" ]; then 
				DNSMASQ_SEARCH_DOMAINS=${domain}
			else
				DNSMASQ_SEARCH_DOMAINS=${DNSMASQ_SEARCH_DOMAINS},${domain}
			fi
		fi
	done	
   	export DNSMASQ_SEARCH_DOMAINS
fi
export DNSMASQ_FWD_NDOTS=${DNSMASQ_FWD_NDOTS:-"0"}
export DNSMASQ_NDOTS=${DNSMASQ_NDOTS:-"0"}
export DNSMASQ_RCACHE=${DNSMASQ_RCACHE:-"0"}
export DNSMASQ_RR=${DNSMASQ_RR:-"True"}
export DNSMASQ_VERBOSE=${DNSMASQ_VERBOSE:-"true"}
export DNSMASQ_NOREC=${DNSMASQ_NOREC:-"false"}
if [ "${DNSMASQ_NOREC}" == "true" ]; then
	export DNSMASQ_SERVERS="" 
else
   	export DNSMASQ_SERVERS=${DNSMASQ_SERVERS:-"8.8.8.8:53,8.8.4.4:53"} 
fi
EOF

