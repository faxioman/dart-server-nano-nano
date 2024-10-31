part of '../../server_nano_nano.dart';

/// Cors class is a middleware that adds CORS headers to the response.
///
/// Example:
/// ```dart
/// final app = Server();
///
/// app.use(Cors());
class Cors extends Middleware {
  final String origin;
  final String methods;
  final String headers;
  final String allowCredentials;

  Cors({
    this.origin = '*',
    this.methods = 'GET, POST, PUT, DELETE, OPTIONS',
    this.headers = 'Content-Type, Authorization, X-Requested-With',
    this.allowCredentials = 'true',
  });

  @override
  Future<bool> handler(ContextRequest req, ContextResponse res) async {
    res.setHeader('Access-Control-Allow-Origin', origin);
    res.setHeader('Access-Control-Allow-Methods', methods);
    res.setHeader('Access-Control-Allow-Headers', headers);
    res.setHeader('Access-Control-Allow-Credentials', allowCredentials);

    // Handle preflight requests
    if (req.method.toLowerCase() == 'options') {
      res.status(HttpStatus.noContent);

      await res.close();
      return false;
    }
    return true;
  }
}
