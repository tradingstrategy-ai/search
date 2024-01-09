# Trading Strategy Search

[tradingstrategy.ai](https://tradingstrategy.ai) uses [Typesense](https://typesense.org) as a
search index for trading entity data. We plan to add search index collections for documentation
and blog posts. Typesense can be [self-hosted](https://typesense.org/docs/) or run as a
[fully managed service](https://cloud.typesense.org).

This repo provides Docker configuration, utility scripts and documentation on how to run Typesense
self-hosted.

## Configuration

A template/example file is provided to simplify configuration. Copy this to `.env` and open it with
your favorite editor.

```bash
cp env.default .env
vim .env
```

> [!NOTE]
> The `.env` file may be renamed to something else (e.g., `typesense.env`). In this case,
> `docker-compose` must be started with the `--env-file` flag (see **Running** below). It does
> ***not*** work to use the `env_file:` option in the `docker-compose.yml` file. Sourcing the file
> this way only makes the env variables available within the container, *not* within the
> `docker-compose.yml` file itself (which is a requirement).

### Master API Key

Set the `TYPESENSE_SERVER_API_KEY` variable. This acts as the master API key with full privileges –
keep it secure!

```bash
TYPESENSE_SERVER_API_KEY=super_secret_ts_key  # replace with a secure key
```

### Typesense Data Directory

By default, Typesense data will be stored in `./typesense-data` on the host machine. You can
override this by setting the `TYPESENSE_HOST_DATA_DIR` environment variable, e.g.:
```bash
TYPESENSE_HOST_DATA_DIR=/var/lib/typesense/data
```

If you want to update path of Typesense data in the container, you can overide this by setting
the `TYPESENSE_DATA_DIR` environment variable (defaults to `/data`):
```bash
TYPESENSE_DATA_DIR=/typesense-data
```

## Running

### Start Typesense Service

If the configuration options above are specified in `.env` in the same directory as this repo,
*or* if they have been sourced into the shell's contect (e.g. using `source ~/secrets.env`), the
service can be started with the standard `docker-compose` command:

```bash
docker-compose up -d
```

If the config options are specified in a different location (e.g., `typesense.env`), add the
`--env-file` option:

```bash
docker-compose --env-file typesense.env up -d
```

### Stop Typesense Service

```bash
docker-compose down
```

## Additional Info

* [Initial Setup](docs/initial-setup.md) guide – explains how to create the `trading-entities`
  colllection and provision additional API keys for import and search.
* [Trading Entities](docs/trading-entities.md) – detailed schema documentation for the
  `trading-entities` collection.
* [Troubleshooting](docs/troubleshooting.md) guide – how to check the Typesense index status,
  run test queries, or delete and re-populate the index.
