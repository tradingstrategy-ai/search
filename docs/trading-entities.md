# Trading Entities Collection

## Schema Definition

See [Typesense field types](https://typesense.org/docs/0.22.2/api/collections.html#field-types)

| Field | Type | Required | Facet | Index | Details |
| --- | --- | :---: | :---: | :---: | --- |
| `id` | `string` | &#x2713; | &#x2717; | &#x2717; | `exchange_1` \| `token_2345` \| `pair_45678` |
| `type` | `string` | &#x2713; | &#x2713; | &#x2717; | `exchange` \| `token` \| `pair`<br>for faceting and possibly grouping results |
| `type_rank` | `int32` | &#x2713; | &#x2717; | &#x2717; | `exchange=1` \| `token=2` \| `pair=3`<br>for ranking; may not need this (depends how we rank and group results)|
| `name` | `string` | &#x2713; | &#x2717; | &#x2713; | `exchange:` "QuickSwap" \| `token:` "Aave (AAVE)" \| `pair:` "AAVE-ETH" |
| `description` | `string` | &#x2713; | &#x2717; | &#x2717; | `exchange:` "QuickSwap on Polygon" \| `token:` "Aave (AAVE) token on Ethereum" \| `pair:` "AAVE-ETH trading pair on SushiSwap on Ethereum"
| `blockchain` | `string` | &#x2713; | &#x2717; | &#x2713; | e.g., "Polygon", "Ethereum" |
| `smart_contract_addresses` | `string[]` | &#x2713; | &#x2717; | &#x2713; | array of all addresses indexable for the type |
| `token_tickers` | `string[]` | &#x2717; | &#x2717; | &#x2713; | array of all token tickers indexable for the type |
| `token_names` | `string[]` | &#x2717; | &#x2717; | &#x2713; | array of all token names indexable for the type |
| `volume_24h` | `float?` | &#x2717; | &#x2717; | &#x2717; | is this needed? (used ever for ranking or filtering?) |
| `price_change_24h` | `float` | &#x2717; | &#x2717; | &#x2717; | secondary sort criteria for tokens & pairs if available |
| `icon_url` | `string` | &#x2717; | &#x2717; | &#x2717; | future use |
| `url_path` | `string` | &#x2713; | &#x2717; | &#x2717; | path of entity on tradingstrategy.ai (not including URL base) |
