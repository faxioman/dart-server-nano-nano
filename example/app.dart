import 'package:server_nano_nano/server_nano_nano.dart';

void main() {
  final server = Server();

  server.get('/', (req, res) {
    res.sendJson({'Hello': 'World!'});
  });

  server.get('/user/:id', (req, res) async {
    await Future.delayed(Duration(seconds: 2));
    res.send('Hello User ${req.params['id']}!');
  });

  server.listen(
    port: 3000,
  );
}
