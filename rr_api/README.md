
# RiskReady - rust backend API

## Database - Postgres

You can either use the `rr` cli I made or do it step by step.

### RR-cli

```bash
rr docker -br
docker exec -it postgres-sbx bash
```

### Step By Step

#### Build

```bash
docker build -t postgres-sbx -f postgres.Dockerfile .
```

#### Run

You can run this command or start the container via the docker desktop.

```bash
docker run -d --name postgres-sbx -p 5432:5432 postgres-sbx

docker start postgres-sbx
```

#### Enter

Take the name and use it to enter the container.

```bash
docker exec -it postgres-sbx bash
```

#### Enter psql

```bash
postgres##: psql -U postgres -W
Password: root
```

#### Enter into the sandbox database

If the database doesnt exist yet you have to create it.

```bash
postgres=# create database sandbox;
```

Then you can connect to it.

```bash
postgres=# \c sandbox
Password: root
```

#### Starting the server

Technically you dont have to wait until here. But, once the docker container is running, you can start the rust server.

If you then enter the sandbox database and run

```bash
sandbox=# \d

# It should show this

                List of relations
 Schema |       Name       |   Type   |  Owner
--------+------------------+----------+----------
 public | _sqlx_migrations | table    | postgres
 public | scenarios        | table    | postgres
 public | scenarios_id_seq | sequence | postgres
 public | users            | table    | postgres
 public | users_id_seq     | sequence | postgres
(5 rows)

```

You can then select from the pre populated users table.

```bash
sandbox=# select * from users;
id |   username   |          email           |  password   |  full_name   |    phone    |          created_at           |          updated_at
----+--------------+--------------------------+-------------+--------------+-------------+-------------------------------+-------------------------------
  1 | john_doe     | john_doe@example.com     | password123 | John Doe     | +1234567890 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  2 | jane_doe     | jane_doe@example.com     | password456 | Jane Doe     | +2345678901 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  3 | bob_smith    | bob_smith@example.com    | password789 | Bob Smith    | +3456789012 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  4 | mary_jones   | mary_jones@example.com   | password321 | Mary Jones   | +4567890123 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  5 | mike_johnson | mike_johnson@example.com | password654 | Mike Johnson | +5678901234 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  6 | susan_wilson | susan_wilson@example.com | password987 | Susan Wilson | +6789012345 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  7 | david_lee    | david_lee@example.com    | passwordabc | David Lee    | +7890123456 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  8 | lisa_wang    | lisa_wang@example.com    | passworddef | Lisa Wang    | +8901234567 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
  9 | steve_lee    | steve_lee@example.com    | passwordghi | Steve Lee    | +9012345678 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
 10 | emily_chen   | emily_chen@example.com   | passwordjkl | Emily Chen   | +0123456789 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
 11 | adam_kim     | adam_kim@example.com     | passwordmno | Adam Kim     | +1234567890 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
 12 | jennifer_lee | jennifer_lee@example.com | passwordpqr | Jennifer Lee | +2345678901 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
 13 | brian_harris | brian_harris@example.com | passwordstu | Brian Harris | +3456789012 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
 14 | amy_johnson  | amy_johnson@example.com  | passwordvwx | Amy Johnson  | +4567890123 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
 15 | mark_smith   | mark_smith@example.com   | passwordyz1 | Mark Smith   | +5678901234 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
 16 | kelly_wilson | kelly_wilson@example.com | password234 | Kelly Wilson | +6789012345 | 2023-04-01 17:20:04.658212+00 | 2023-04-01 17:20:04.658212+00
(16 rows)
```
