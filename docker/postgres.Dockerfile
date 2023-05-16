FROM postgres

ENV POSTGRES_PASSWORD root
ENV PGDATA=/var/lib/postgresql/data/pgdata
ENV POSTGRES_DB sandbox

COPY sandbox.sql /docker-entrypoint-initdb.d/
