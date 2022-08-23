# Trading Strategy Search

[tradingstrategy.ai](https://tradingstrategy.ai) uses [Typesense](https://typesense.org) as a
search index for trading entity data. We plan to add search index collections for documentation
and blog posts. Typesense can be [self-hosted](https://typesense.org/docs/) or run as a
[fully managed service](https://cloud.typesense.org).

This repo provides Docker configuration, utility scripts and documentation on how to run Typesense
self-hosted.

## Running

### Master API Key

Set the `TYPESENSE_API_KEY` key. This is the master API key with full privileges – keep it secure!

```bash
export TYPESENSE_API_KEY=super_secret_ts_key  # replace with a secure key
```

### Typesense Data Files

By default, Typesense data will be stored in `./typesense-data`. You can override this by
setting the `TYPESENSE_DATA` environment variable, e.g.:

```bash
export TYPESENSE_DATA=/var/lib/typesense/data
```

### Start Typesense Service

```bash
docker-compose up -d
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
