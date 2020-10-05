# PostgreSQL-TimescaleDB-PipelineDB

PostgreSQL + TimescaleDB + PipelineDB docker image 🐘📈🔀

Based on [Alpine Linux](https://alpinelinux.org).

Docker image with:
* [PostgreSQL](https://www.postgresql.org/) 
* [TimescaleDB](https://www.timescale.com/)
* [PipelineDB](https://www.pipelinedb.com/)

Current versions of components:
* PostgreSQL: **11.9** ([Source docker image](https://store.docker.com/images/postgres))
* TimescaleDB: **1.7.4** ([Release archive](https://github.com/timescale/timescaledb/releases/tag/1.7.4))
* PipelineDB: **1.0.0-13** ([Release archive](https://github.com/pipelinedb/pipelinedb/releases/tag/1.0.0-13))

How to build:

```bash
$ docker build -t binakot/postgresql-timescaledb-pipelinedb .
```

How to run:

```bash
$ docker run -d --name postgres -e POSTGRES_PASSWORD=postgres binakot/postgresql-timescaledb-pipelinedb
```

---

## IMPORTANT

PipelineDB has joined Confluent. 
PipelineDB will not have new releases beyond 1.0.0, although critical bugs will still be fixed.
PipelineDB currently supports PostgreSQL versions 10.1, 10.2, 10.3, 10.4, 10.5, and 11.0 on 64-bit architectures.
PipelineDB is under maintenance and will not support PostgreSQL after version 11.

Also you should check the `TimescaleDB` features with continues computing: 
[https://docs.timescale.com/latest/using-timescaledb/continuous-aggregates](https://docs.timescale.com/latest/using-timescaledb/continuous-aggregates).
