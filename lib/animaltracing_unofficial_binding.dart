export 'src/internal/exceptions/http_exception.dart';
export 'src/internal/exceptions/soap_exception.dart';
export 'src/internal/exceptions/string_decoding_exception.dart';
export 'src/internal/exceptions/xml_missing_element_exception.dart';

/// Holds information to connect a service endpoint
class ServiceEndpointConfiguration {
  /// Name of the host.
  ///
  /// Could be ipAddress or domain name.
  final String host;

  /// The port number on which the service is available.
  final int port;

  /// Path of the webadress.
  ///
  /// Example: Livestock/AnimalTracing/3
  ///
  /// There should be no '/' at the beginning.
  final String path;

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
  final Duration? timeOutDuration;

  /// Create [ServiceEndpointConfiguration].
  ///
  /// [path] should not start with '/' at the beginning.
  ///
  /// See documentation of the members for additional infos.
  ServiceEndpointConfiguration(
      this.host, this.port, this.path, this.timeOutDuration);
}
