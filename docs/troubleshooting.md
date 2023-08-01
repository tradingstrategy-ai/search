# Trading Strategy Search – Troubleshooting

Most of these commands can be run from any client machine. You will need the appropriate
keys, which can be found in `~/secrets.env` on the production server.

See [Typesense API Reference](https://typesense.org/docs/0.23.1/api/) for additional details on
Typesense APIs.

## Configure `ENV` variables

These values can be configured by sourcing `secrets.env` on production (or set them locally based
on the values found there).

```bash
export TYPESENSE_BASE_URL=https://typesense-instance.a1.typesense.net  # replace with real URL
export TYPESENSE_API_KEY=typesense_admin_key                           # replace with real API key
```
## Check `trading-entities` collection

A `GET` request of the `trading-entities` collection returns the collection schema (`fields`)
and the current number of indexed documents (`num_documents`):

```bash
curl "${TYPESENSE_BASE_URL}/collections/trading-entities" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     | jq
```

## Search `trading-entities` documents

The search query below is similar to those run from the Trading Strategy website search. Modify
the search params as needed (e.g., include a search term in the `q=` param).

The `facet_counts` values are very useful for verifying how many documents exist by type, blockchain
and exchange.

You can also add a `group_by=type` to force Typesense to return top results for each entity type,
but note that this will make the facet counts useless.

```bash
curl --get "${TYPESENSE_BASE_URL}/collections/trading-entities/documents/search" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     --data-urlencode "query_by=description,token_tickers,token_names,smart_contract_addresses" \
     --data-urlencode "facet_by=type,blockchain,exchange" \
     --data-urlencode "sort_by=liquidity:desc,_text_match:desc" \
     --data-urlencode "filter_by=type:[exchange,pair,token]" \
     --data-urlencode "q=" \
     | jq
```

## Delete and recreate `trading-entities` collection

If the search index gets corrupted for any reason, you'll need to delete and recreate the
collection. This occurs (for example) if the trading entities are regenerated on the backend with
different database IDs.

### Delete collection

```bash
curl -X DELETE "${TYPESENSE_BASE_URL}/collections/trading-entities" \
  -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}"
```

### Recreate collection

This must be run from the root directory of this repository (so the schema file is available).

```bash
curl -X POST "${TYPESENSE_BASE_URL}/collections" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -d @schemas/trading-entities.json \
     | jq
```

### Check collection

```bash
curl "${TYPESENSE_BASE_URL}/collections/trading-entities" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     | jq
```

### Repopulate collection

The collection is populated by running an ETL script on the `oracle` server. SSH to production and
configure your environment (check prod history for the latest `ORACLE_VERSION`):

```bash
ssh $PROD
cd ~/oracle/oracle
source ~/secrets.env
export ORACLE_VERSION=v258
```

You should now be able to run the Typesense ETL script via `docker-compose`:

```bash
docker-compose run -it --entrypoint /usr/local/bin/python oracle-console /usr/src/oracle/scripts/generic/export-typesense.py
```

This script will take several minutes to complete. Successful output should look something like
the following:

```log
2023-08-01 20:29:57 Started task export_typesense
2023-08-01 20:29:57 Starting JSONL export
2023-08-01 20:29:57 Exporting exchanges
2023-08-01 20:29:58 Exported 117 total exchanges, named -4415, unknown 4532, name data for 109
2023-08-01 20:29:58 Started task export_tokens
2023-08-01 20:29:58 Exporting tokens
2023-08-01 20:30:44 159263 token entries
2023-08-01 20:30:44 Ended task export_tokens, took 0:00:46.510067
2023-08-01 20:30:44 Started task export_trading_pairs
2023-08-01 20:30:44 Fetching pair eligibility data
2023-08-01 20:30:47 Fetching pairs
2023-08-01 20:31:02 Fetching exchanges
2023-08-01 20:31:03 Fetching stats
2023-08-01 20:32:03 We have 184487 pairs, 186367 stats entries
2023-08-01 20:33:37 184487 trading pair entries, 11167 price changes
2023-08-01 20:33:38 Ended task export_trading_pairs, took 0:02:54.023184
2023-08-01 20:33:38 Wrote Typesense export /root/oracle-datasets/typesense.jsonl, 343867 entries in 220.844973 seconds, size is 250,666,862 bytes
2023-08-01 20:33:38 Ended task export_typesense, took 0:03:40.853901
2023-08-01 20:33:38 Uploading data to Typesense
2023-08-01 20:34:42 Typesense upload complete in 63.892714 seconds
```


Once the ETL process is complete, you can re-check the collection to ensure it has the expected
number of documents (see above).
