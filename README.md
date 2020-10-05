# PostgreSQL-TimescaleDB-PipelineDB

PostgreSQL + TimescaleDB + PipelineDB docker image 🐘📈🔀

Based on [Alpine Linux](https://alpinelinux.org).

Docker image with:
* [PostgreSQL](https://www.postgresql.org/)
* [TimescaleDB](https://www.timescale.com/)
* [PipelineDB](https://www.pipelinedb.com/)

Current versions of components:
* PostgreSQL: **11.3** ([Source docker image](https://store.docker.com/images/postgres))
* TimescaleDB: **1.3.0** ([Release archive](https://github.com/timescale/timescaledb/releases/tag/1.3.0))
* PipelineDB: **1.0.0-13** ([Release archive](https://github.com/pipelinedb/pipelinedb/releases/tag/1.0.0-13))

How to build:

```bash
$ docker build -t binakot/postgresql-timescaledb-pipelinedb .
```

How to run:

```bash
$ docker run -d --name postgres -e POSTGRES_PASSWORD=postgres binakot/postgresql-timescaledb-pipelinedb
```

You can also build and run the docker image using `docker-compose`

```sh
# Building Image
docker-compose build
# Running the postgres image
docker-compose up
```