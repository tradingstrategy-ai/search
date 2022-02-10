# Trading Strategy Search

[tradingstrategy.ai](https://tradingstrategy.ai) uses [Typesense](https://typesense.org) to index
trading entity data, documentation and blog posts. Typesense can be
[self-hosted](https://typesense.org/docs/) or run as a
[fully managed service](https://cloud.typesense.org).

This repo provides Docker configuration, utility scripts and documentation on how to run Typesense
self-hosted.

TBD - additional info on how data from each of these sources is added to the search index.

## Running

### Master API Key

Set the `TYPESENSE_API_KEY` key. This is the master API key with full privileges – keep it secure!

```bash
export TYPESENSE_API_KEY=super_secret_ts_key
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
