export 'src/internal/exceptions/http_exception.dart';
export 'src/internal/exceptions/soap_exception.dart';
export 'src/internal/exceptions/string_decoding_exception.dart';
export 'src/internal/exceptions/xml_missing_element_exception.dart';

/// Holds information to connect a service endpoint
class ConnectionConfiguration {
  /// Address of the Endpoint to connect to that implements
  /// the Api of Animaltracing.
  ///
  ///Example: ```Uri.http('localhost:4040', 'Livestock/AnimalTracing/3')```
  final Uri endpoint;

  /// Gets and sets the connection timeout.
  ///
  /// When connecting to a new host exceeds this timeout, a [SocketException]
  /// is thrown. The timeout applies only to connections initiated after the
  /// timeout is set.
  ///
  /// When this is `null`, the OS default timeout is used. The default is
  /// `null`.
  ///
  /// See [HttpClient.connectionTimeout] for more details.
  final Duration? connectionTimeout;

  /// Create [ConnectionConfiguration].
  ///
  ///
  /// See documentation of the members for additional infos.
  ConnectionConfiguration({required this.endpoint, this.connectionTimeout});
}
