FROM scratch

EXPOSE 1080
ENV VIWS_PORT 1080

HEALTHCHECK --retries=5 CMD [ "/viws", "-url", "http://localhost:1080/health" ]
ENTRYPOINT [ "/viws" ]

ARG VERSION
ENV VERSION=${VERSION}

ARG TARGETOS
ARG TARGETARCH

COPY mime.types /etc/mime.types
COPY cacert.pem /etc/ssl/certs/ca-certificates.crt
COPY release/viws_${TARGETOS}_${TARGETARCH} /viws
