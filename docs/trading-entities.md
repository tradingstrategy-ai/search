# Trading Entities Collection

The **trading entity collection** includes records for all searchable trading entities on
[tradingstrategy.ai](https://tradingstrategy.ai). Currently, this includes `exchanges`, `tokens` and
token `pairs`. The schema is a flattened, normalized data representation that includes all
text-based attributes that are useful for searching, as well as numeric measures that are useful
for filtering and sorting.

## Schema Definition

See [Typesense field types](https://typesense.org/docs/0.22.2/api/collections.html#field-types)

| Field | Type | Required | Index | Facet | Details |
| ---   | ---  | :---:    | :---: | :---: | ---     |
| `id`                       | `string`   | ✓ | ✗ | ✗ | `exchange_1` \| `token_2345` \| `pair_34567` \| `lending_reserve_456`<br>Typesense unique document identifier |
| `internal_id`              | `string`   | ✗ | ✓ | ✗ | e.g., "12345"<br>Trading Strategy's internal (database) ID for any entity type |
| `type`                     | `string`   | ✓ | ✓ | ✓ | `exchange` \| `token` \| `pair` \| `lending_reserve`<br>for faceting and possibly grouping results |
| `type_rank`                | `int32`    | ✓ | ✓ | ✗ | `exchange=1` \| `pair=2` \| `token=3` \| `lending_reserve=4`<br>for ranking in quick search |
| `name`                     | `string`   | ✓ | ✓ | ✗ | `exchange:` "QuickSwap"<br>`token:` "Aave (AAVE)"<br>`pair:` "AAVE-ETH"<br>`lending_reserve:` "Dai Stablecoin" |
| `description`              | `string`   | ✓ | ✓ | ✗ | `exchange:` "QuickSwap on Polygon"<br>`token:` "AAVE on Ethereum"<br>`pair:` "AAVE-ETH on SushiSwap"<br>`lending_reserve:` "Dai Stablecoin on Aave V3" |
| `blockchain`               | `string`   | ✓ | ✓ | ✓ | e.g., "polygon", "ethereum" |
| `exchange`                 | `string`   | ✗ | ✓ | ✓ | e.g., "Uniswap v2", "Sushiswap"<br>same as `name` for exchanges; set to `exchange.name` for pairs; leave blank for tokens and reserves |
| `exchange_type`            | `string`   | ✗ | ✗ | ✗ | e.g., "uniswap_v2", "uniswap_v2_incompatible"<br>set on exchanges and pairs; not set for tokens or reserves |
| `lending_protocol`         | `string`   | ✗ | ✓ | ✓ | e.g., "Aave V3"<br>set to `reserve.protocol_name` for lending reserves; leave blank for other entities |
| `smart_contract_addresses` | `string[]` | ✓ | ✓ | ✗ | array of all indexable addresses for the type |
| `token_tickers`            | `string[]` | ✗ | ✓ | ✗ | array of all indexable token tickers for the type |
| `token_names`              | `string[]` | ✗ | ✓ | ✗ | array of all indexable token names for the type |
| `quality_factors`          | `string[]` | ✗ | ✗ | ✗ | array of factors used to identify "low quality" entities<br>current possible values: `liquidity` |
| `volume_24h`               | `float`    | ✗ | ✓ | ✗ | in USD; advanced search filtering / ranking |
| `liquidity`                | `float`    | ✗ | ✓ | ✗ | in USD; advanced search filtering / ranking |
| `tvl`                      | `float`    | ✗ | ✓ | ✗ | in USD; advanced search filtering / ranking |
| `price_change_24h`         | `float`    | ✗ | ✓ | ✗ | percent (expresed as decimal); secondary sort criterion for tokens & pairs |
| `price_usd_latest`         | `float`    | ✗ | ✓ | ✗ | in USD; not valuable for filtering / ranking - used for display only |
| `pair_swap_fee`            | `float`    | ✗ | ✓ | ✓ | percent (expressed as decimal); only applies to trading pairs |
| `supply_apr`               | `float`    | ✗ | ✓ | ✗ | percent (expressed as percentage); only applies to lending reserves |
| `stable_borrow_apr`        | `float`    | ✗ | ✓ | ✗ | percent (expressed as percentage); only applies to lending reserves |
| `variable_borrow_apr`      | `float`    | ✗ | ✓ | ✗ | percent (expressed as percentage); only applies to lending reserves |
| `url_path`                 | `string`   | ✗ | ✗ | ✗ | path of entity on tradingstrategy.ai (not including URL base) |

## File Format

Collection import files should be in [JSON Lines](https://jsonlines.org) format – one line of JSON per-row.

## Example Records

### Exchange Record

```json
{
  "id": "exchange_1762",
  "internal_id": "1762",
  "type": "exchange",
  "type_rank": 1,
  "name": "QuickSwap",
  "description": "Quickswap on Polygon",
  "blockchain": "polygon",
  "exchange": "QuickSwap",
  "exchange_type": "uniswap_v2",
  "smart_contract_addresses": ["0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32"],
  "token_tickers": [],
  "token_names": [],
  "url_path": "/trading-view/polygon/quickswap"
}
```

### Token Record

```json
{
  "id": "token_23456",
  "internal_id": "23456",
  "type": "token",
  "type_rank": 3,
  "name": "Aave Token (AAVE)",
  "description": "AAVE on Ethereum",
  "blockchain": "ethereum",
  "smart_contract_addresses": ["0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9"],
  "token_tickers": ["AAVE"],
  "token_names": ["Aave Token"],
  "volume_24h": 123456.78,
  "liquidity": 234567.89,
  "url_path": "/trading-view/ethereum/aave"
}
```

### Pair Record

```json
{
  "id": "pair_3456789",
  "internal_id": "3456789",
  "type": "pair",
  "type_rank": 2,
  "name": "AAVE-ETH",
  "description": "AAVE-ETH on SushiSwap",
  "blockchain": "ethereum",
  "exchange": "SushiSwap",
  "exchange_type": "uniswap_v2",
  "smart_contract_addresses": [
    "0xd75ea151a61d06868e31f8988d28dfe5e9df57b4",
    "0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9",
    "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
  ],
  "token_tickers": ["AAVE", "ETH"],
  "token_names": ["Aave Token", "Wrapped Ether"],
  "quality_factors": ["liquidity"],
  "volume_24h": 123456.78,
  "liquidity": 234567.89,
  "tvl": null,
  "price_change_24h": -0.0345,
  "price_usd_latest": 93.5,
  "pair_swap_fee": 0.003,
  "url_path": "/trading-view/ethereum/sushiswap/aave-eth"
}
```

### Lending Reserve Record

```json
{
  "id": "reserve_456",
  "internal_id": "456",
  "type": "lending_reserve",
  "type_rank": 4,
  "name": "Dai Stablecoin",
  "description": "Dai Stablecoin on Aave V3",
  "blockchain": "ethereum",
  "smart_contract_addresses": [
    "0x6b175474e89094c44da98b954eedeac495271d0f",
    "0x018008bfb33d285247a21d44e50697654f754e63",
    "0x413adac9e2ef8683adf5ddaece8f19613d60d1bb",
    "0xcf8d0c70c850859266f5c338b38f9d663181c314"
  ],
  "token_tickers": ["DAI", "aEthDAI", "stableDebtEthDAI", "variableDebtEthDAI"],
  "token_names": [
    "Dai Stablecoin",
    "Aave Ethereum DAI",
    "Aave Ethereum Stable Debt DAI",
    "Aave Ethereum Variable Debt DAI"
  ],
  "supply_apr": 2.710405351754456,
  "stable_borrow_apr": 5.485054885904468,
  "variable_borrow_apr": 3.8804390872357444,
  "url_path": "/trading-view/ethereum/lending/aave_v3/dai"
}
```
