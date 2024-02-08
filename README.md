# Atlas migrations with Gorm

https://atlasgo.io/guides/orms/gorm

## Installation:

```sh
brew install ariga/tap/atlas # or curl -sSf https://atlasgo.sh | sh
```

## What is it good for?

- We do not have to manually write schema definition commands as with golang-migrate package
- Declarative migrations: developers do only have to describe the desired state, which are the Gorm models essentially

## Demo scenario

_Have a look at the Makefile for predifined commands_

To use this tool successfully you need to use two distinct databases. The "dev" database is used to compute schemas and replay the sql files from migrations folder. The other one is used to store the data and is considered the production database that the app would eventually use.
I solved this by defining the "dev" virtual database on the postgres instance alongside the default "postgres".

More info: [Atlas Diff](https://atlasgo.io/versioned/diff)

### Development phase

In the beginning we have a database populated with data from running cmd/main/main.go (`make migrate-apply` and `make run` later explained)

We first uncomment the "not null" tag in models/foo.go on the Number field and convert it to a non pointer type, then create the new migration that will migrate the database from its latest revision to the current GORM schema:

```sh
atlas migrate diff --env gorm
```

Doing this will create the new sql file under migrations.

Note: Dev database has to be clean otherwise you will get the following error:

```
Error: sql/migrate: taking database snapshot: sql/migrate: connected database is not clean: found schema "atlas_schema_revisions"
```

In order to clean dev db in this current setup please run `make stop-db` then `make clear-db` and `make start-db`.

### Deployment phase

First we set data database url on which we want to run the migrations:

```sh
export PROD_DATABASE_URL=postgres://user:password@localhost:5432/postgres?sslmode=disable
#                                                                ^^^^^^^^
```

Then check the current state of that database:

```sh
atlas migrate status --url $PROD_DATABASE_URL
```

After that we can apply the newly created migrations:

```sh
# Here atlas will notify you if there are incompatibility between stored data and the new schema
atlas migrate apply --url $PROD_DATABASE_URL
```

### Down migration

Rolling back to the previous migration:

You first delete the last migration file, and overwrite atlas.sum:

```sh
atlas migrate hash
```

After that, you can set the prod database schema to the one stored in dev:

```sh
# Here atlas will notify you if there are incompatibility between stored data and the new schema
atlas schema apply \
  --url $PROD_DATABASE_URL \
  --to "file://migrations" \
  --dev-url "postgres://user:password@localhost:5432/dev?sslmode=disable" \
  --exclude "atlas_schema_revisions"

atlas migrate set 20240209120704 --url $PROD_DATABASE_URL --dir "file://migrations"
```

More info about the apply command: [Apply command](https://atlasgo.io/versioned/apply)

## Good to know

- Create statements always use the non null zero value of the given type when not provided, even if that certain column is defined as nullable.
- You have to explicitly provide which column you want to use as foreign key within Gorm.
- All columns are nullable by default, even if you did not make that particular field having a pointer type in the model (except for IDs and primary keys).
  This behavior is of Gorm, but it was not clear for me before using Atlas migrations, since the sql files make it unambiguous what type of tables we really have.
