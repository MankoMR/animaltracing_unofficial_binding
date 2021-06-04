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
- BREAKING CHANGE: Change Organization of files and how they are exported: Structure of
  generated Documentation is improved and additional Service Operations can be implemented without
  having lots of import statements and folders with lots of file.  
- `EarTagOrderData` implements `RequestData`
- Fix throwing `FormatExpection` when `extractList` extracts from an empty list.
- Fix inapropriate `XmlMissingException` in `extractPrimitiveValue` by moving support for XMlElement
  into `extractXmlElement`.
- Fix that `SoapException` and `HTTPException` didn't implement `Exception`.

Internal Changes:

- Introduced lots of additional lints that help, making the code more standardized.
- Refactor how nullability is handled during parsing.
- Improve Documentation for usage and implementation of internal functions.
- Add Tests for `extractPrimitiveValue`, `nullabilityPass`, `extractList`. 
