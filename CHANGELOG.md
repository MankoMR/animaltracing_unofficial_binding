## 0.0.1

- Initial version, created by Stagehand

## 0.1.0

- Setting up required basic features used internally in library
- Add topic `Eartags`
- Add service operation `getEarTagOrders` to `Eartags`

## 0.2.0

Public Changes:

- BREAKING CHANGE: `ServiceEndpointConfiguration` is now called `ConnectionConfiguration` and the 
  following members are replaced with the member Uri `endpoint`: `host`, `port` and `path`.
- `EarTagOrderData` implements `RequestData`
- Fix throwing `FormatExpection` when `extractList` extracts from an empty list.
- Fix inapropriate `XmlMissingException` in `extractPrimitiveValue` by moving support for XMlElement
  into `extractXmlElement`.
Internal Changes:

- Refactor how nullability is handled during parsing.
- Improve Documentation for usage and implementation of internal functions.
- Add Tests for `extractPrimitiveValue`, `nullabilityPass`, `extractList`. 
