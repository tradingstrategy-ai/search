# Trading Strategy Search – Initial Setup

Once the Typesense service is running (as described in the [README](../README.md)), the following
setup steps need to be completed in order for data to be loaded and searched. These steps can be
run from any client machine (assuming the Typesense web service is publically addressable). Some of
the steps below require files from this repository - be sure to clone this repo and run the commands
from the project root directory.

## 1. Configure `ENV` vars for setup

Set the following `ENV` vars in your terminal shell where you will be running the setup commands.
The `TYPESENSE_API_KEY` should be the same Admin API key used when starting the docker service.

```bash
export TYPESENSE_API_KEY=super_secret_ts_key                 # replace with a secure key
export TYPESENSE_BASE_URL=https://your.public.typesense.url  # replace with public search URL
```

## 2. Configure `trading-entities` collection

The following request creates the [trading-entities](./trading-entities.md) collection:

```bash
curl -X POST "${TYPESENSE_BASE_URL}/collections" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -d @schemas/trading-entities.json
```

You should receive a `JSON` response body that relfects the same collection and schema.

## 3. Generate private API key for `trading-entities` import

The Trading Entities collection will be populated from a script that runs on the `dex_ohlcv`
"oracle" server. The request below generates an API key that can be used by the import process (with
reduced privileges compared to the Admin API key):

```bash
curl -X POST "${TYPESENSE_BASE_URL}/keys" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -d '{"description":"Oracle import key","actions":["*"],"collections":["trading-entities"]}'
```

The `JSON` response body should include a `value` key. Stash this somewhere secure so it can be used
when configuring the `dex_ohlcv` import process.

## 4. Initial `trading-entities` import

You can now run an initial/test import of Trading Entities data. You'll need a data file (generated
by the `dex_ohlcv` export process) and the API key generated in step 3:

```bash
export TYPESENSE_ORACLE_API_KEY=oracle_api_key  # replace with value from step 3
export TYPESENSE_IMPORT_FILE=./typesense.jsonl  # replace with export file path/name

curl -X POST "${TYPESENSE_BASE_URL}/collections/trading-entities/documents/import?action=upsert" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_ORACLE_API_KEY}" \
     --data-binary @${TYPESENSE_IMPORT_FILE}
```

This request may take up to a minute to complete (depending on the size of your import file). The
response should include a `{"success":true}` for each imported document. You can verify the number
of imported documents by requesting the collection and checking the `num_documents` value:

```bash
curl "${TYPESENSE_BASE_URL}/collections/trading-entities" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_ORACLE_API_KEY}"
```

## 5. Generate public `search` API key

Similar to step #3 above, a custom API key (with limited permissions) is required for searches. This
key is _public_ – it will be used to submit search requests directly from the browser:

```bash
curl -X POST "${TYPESENSE_BASE_URL}/keys" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -d '{"description":"Public search key","actions":["documents:search"],"collections":["*"]}'
```

Note the `value` from the `JSON` response body. Stash this somewhere so it can be used when
configuring the [tradingstrategy-ai/frontend](https://github.com/tradingstrategy-ai/frontend)
application.
