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

The collection is populated by running the following ETL script on the `oracle` server:

```bash
source ~/secrets.env
bash scripts/export-typesense.py
```

Once the ETL process is complete, you can re-check the collection to ensure it has the expected
number of documents (see above).
