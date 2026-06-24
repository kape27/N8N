FROM python:3-alpine AS python-build

FROM n8nio/n8n:1.68.0

USER root

COPY --from=python-build /usr/local/bin/python* /usr/local/bin/
COPY --from=python-build /usr/local/bin/pip* /usr/local/bin/
COPY --from=python-build /usr/local/bin/idle* /usr/local/bin/
COPY --from=python-build /usr/local/bin/pydoc* /usr/local/bin/
COPY --from=python-build /usr/local/lib/libpython3* /usr/local/lib/
COPY --from=python-build /usr/local/lib/pkgconfig/ /usr/local/lib/pkgconfig/
COPY --from=python-build /usr/local/lib/python3.14/ /usr/local/lib/python3.14/

RUN ln -sf /usr/local/bin/python3 /usr/local/bin/python

WORKDIR /data

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1

EXPOSE 5678

USER node
