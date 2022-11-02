# Trading Entities Collection

The **trading entity collection** includes records for all searchable trading entities on
[tradingstrategy.ai](https://tradingstrategy.ai). Currently, this includes `exchanges`, `tokens` and
token `pairs`. The schema is a flattened, normalized data representation that includes all
text-based attributes that are useful for searching, as well as numeric measures that are useful
for filtering and sorting.

## Schema Definition

See [Typesense field types](https://typesense.org/docs/0.22.2/api/collections.html#field-types)

| Field | Type | Required | Index | Facet | Details |
| --- | --- | :---: | :---: | :---: | --- |
| `id` | `string` | &#x2713; | &#x2717; | &#x2717; | `exchange_1` \| `token_2345` \| `pair_45678` |
| `type` | `string` | &#x2713; | &#x2717; | &#x2713; | `exchange` \| `token` \| `pair`<br>for faceting and possibly grouping results |
| `type_rank` | `int32` | &#x2713; | &#x2717; | &#x2717; | `exchange=1` \| `token=2` \| `pair=3`<br>for ranking; may not need this (depends how we rank and group results)|
| `name` | `string` | &#x2713; | &#x2713; | &#x2717; | `exchange:` "QuickSwap" \| `token:` "Aave (AAVE)" \| `pair:` "AAVE-ETH" |
| `description` | `string` | &#x2713; | &#x2713; | &#x2717; | `exchange:` "QuickSwap on Polygon" \| `token:` "Aave (AAVE) token on Ethereum" \| `pair:` "AAVE-ETH trading pair on SushiSwap on Ethereum" |
| `blockchain` | `string` | &#x2713; | &#x2717; | &#x2713; | e.g., "polygon", "ethereum" |
| `exchange` | `string` | &#x2713; | &#x2717; | &#x2713; | e.g., "Uniswap v2", "Sushiswap"<br>same as `name` for exchanges; set to `exchange.name` for pairs; set to `""` (empty string) for tokens |
| `smart_contract_addresses` | `string[]` | &#x2713; | &#x2713; | &#x2717; | array of all indexable addresses for the type |
| `token_tickers` | `string[]` | &#x2717; | &#x2713; | &#x2717; | array of all indexable token tickers for the type |
| `token_names` | `string[]` | &#x2717; | &#x2713; | &#x2717; | array of all indexable token names for the type |
| `quality_factors` | `string[]` | &#x2717; | &#x2717; | &#x2717; | array of factors used to identify "low quality" entities<br>current possible values: `liquidity` |
| `volume_24h` | `float` | &#x2717; | &#x2717; | &#x2717; | in USD; advanced search filtering / ranking |
| `liquidity` | `float` | &#x2717; | &#x2717; | &#x2717; | in USD; advanced search filtering / ranking |
| `price_change_24h` | `float` | &#x2717; | &#x2717; | &#x2717; | percent (expresed as decimal); secondary sort criterion for tokens & pairs |
| `price_usd_latest` | `float` | &#x2717; | &#x2717; | &#x2717; | in USD; not valuable for filtering / ranking - used for display only |
| `pool_swap_fee` | `float` | &#x2717; | &#x2717; | &#x2717; | percent (expressed as decimal); only applies to Uniswap V3 (or similar) pairs<br>current possible values: `0.0005` (`0.05%`), `0.003` (`0.3%`), `0.01` (1%) |
| `url_path` | `string` | &#x2717; | &#x2717; | &#x2717; | path of entity on tradingstrategy.ai (not including URL base) |

## File Format

Collection import files should be in [JSON Lines](https://jsonlines.org) format – one line of JSON per-row.

## Example Records

### Exchange Record

```json
{
  "id": "exchange_1762",
  "type": "exchange",
  "type_rank": 1,
  "name": "QuickSwap",
  "description": "Quickswap exchange on Polygon",
  "blockchain": "Polygon",
  "exchange": "QuickSwap",
  "smart_contract_addresses": ["0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32"],
  "token_tickers": [],
  "token_names": [],
  "price_change_24h": null,
  "volume_24h": null,
  "liquidity": null,
  "url_path": "/polygon/quickswap"
}
```

### Token Record

```json
{
  "id": "token_23456",
  "type": "token",
  "type_rank": 2,
  "name": "Aave (AAVE)",
  "description": "Aave (AAVE) token on Ethereum",
  "blockchain": "Ethereum",
  "exchange": "",
  "smart_contract_addresses": ["0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9"],
  "token_tickers": ["AAVE"],
  "token_names": ["Aave"],
  "price_change_24h": 0.0123,
  "volume_24h": 123456.78,
  "liquidity": 234567.89,
  "url_path": "/ethereum/aave"
}
```

### Pair Record

```json
{
  "id": "pair_3456789",
  "type": "pair",
  "type_rank": 3,
  "name": "AAVE-ETH",
  "description": "AAVE-ETH trading pair on SushiSwap on Ethereum",
  "blockchain": "Ethereum",
  "exchange": "SushiSwap",
  "smart_contract_addresses": ["0xd75ea151a61d06868e31f8988d28dfe5e9df57b4", "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9", "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"],
  "token_tickers": ["AAVE", "ETH"],
  "token_names": ["Aave", "Ether"],
  "quality_factors": ["liquidity"],
  "price_change_24h": -0.0345,
  "volume_24h": 123456.78,
  "liquidity": 234567.89,
  "pool_swap_fee": null,
  "url_path": "/ethereum/sushiswap/aave-eth"
}
```
