
# RiskReady-cli

This is a simple cli to generate migration files and start the docker postgres container. And believe me.. this is not well implemented, if the container is already running or already created, the output is kinda ugly 💩.

# Docker

```bash
# Build the docker container, only for building a new container.
> rr docker -b

# Run and start the docker container, doesnt work if the container is already running and gives some ugly shit. But Im too lazy to fix it and it doesnt really matter
> rr docker -r

# Stop the docker container
> rr docker -s

# Build and run the container, only run this is a completely new container.
> rr docker -br
```

# Migrations

The `rr mig` command takes in a file name. It will then prepend the current timestamp and append the `.sql` extension.

```bash
# New file.
# Will create something like this 20221212303030_hello_world.sql
> rr mig -n hello_world

# Run the migrations (!Not tested)
> rr mig -r
```
