# docker build -t xampp/proxy -f src/proxy.Dockerfile .
# docker run -d --hostname proxy --name proxy --network local -v /var/run/docker.sock:/var/run/docker.sock -p 80:80 -p 443:443 xampp/proxy
FROM traefik

LABEL traefik.enable=true
LABEL traefik.port=8080
LABEL traefik.frontend.rule=Host:proxy.localhost
LABEL traefik.docker.network=local

COPY resources/certs /certs

CMD [ \
	"--api", \
	"--logLevel=error", \
	"--entrypoints=Name:http Address::80 Redirect.EntryPoint:https", \
	"--entrypoints=Name:https Address::443 TLS:/certs/localhost.crt,/certs/localhost.key", \
	"--defaultentrypoints=http,https", \
	"--docker", \
	"--docker.exposedbydefault=false" \
]
