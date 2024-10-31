part of '../../server_nano_nano.dart';

typedef HttpHandler = void Function(ContextRequest req, ContextResponse res);

class Handler {
  final HttpHandler? httpHandler;
  final Method method;

  Handler({
    required this.method,
    this.httpHandler,
  });

  Future<void> handle(
    HttpRequest req, {
    required MatchResult match,
    required List<Middleware> middlewares
  }) async {
    final localMethod = method;

    var request = ContextRequest(req, localMethod, match.parameters);
    final response = ContextResponse(req.response);

    for (final middleware in middlewares) {
      final result = await middleware.handler(request, response);
      if (!result) {
        logger('Request blocked by middleware');
        return;
      }
    }
    httpHandler?.call(request, response);
  }
}
