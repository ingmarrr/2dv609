
# RiskReady - rust backend API

## Database - Postgres

### Problem

> ! The migrations dont work yet.
> ! You will have to run:

#### Build

```bash
docker build -t postgres-sbx -f postgres.Dockerfile .
```

#### Run

You can run this command or start the container via the docker desktop.

```bash
docker run -d --name postgres-sbx -p 5432:5432 postgres-sbx

# Should return the name, something like this:
a1d52b71f42ce87bc06121988405fc1ec7305323b701f2a002b5352d6d840058
```

#### Enter

Take the name and use it to enter the container.

```bash
docker exec -it a1d52b71f42ce87bc06121988405fc1ec7305323b701f2a002b5352d6d840058 /bin/bash
```

#### Enter psql

```bash
postgres#: psql -U postgres -W
password#: root
```
