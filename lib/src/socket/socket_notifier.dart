part of server_nano;

class _SocketNotifier {
  List<MessageSocket>? _onMessages = <MessageSocket>[];
  Map<String, MessageSocket>? _onEvents = <String, MessageSocket>{};
  List<CloseSocket>? _onCloses = <CloseSocket>[];
  List<CloseSocket>? _onErrors = <CloseSocket>[];

  void addMessages(MessageSocket socket) {
    _onMessages!.add((socket));
  }

  void addEvents(String event, MessageSocket socket) {
    _onEvents![event] = socket;
  }

  void addCloses(CloseSocket socket) {
    _onCloses!.add(socket);
  }

  void addErrors(CloseSocket socket) {
    _onErrors!.add((socket));
  }

  void notifyData(dynamic data) {
    for (var item in _onMessages!) {
      item(data);
    }
    _tryOn(data);
  }

  void notifyClose(Close err, GetSocket newWs) {
    logger('Socket ${newWs.hashCode} is been disposed');

    for (var item in _onCloses!) {
      item(err);
    }
  }

  void notifyError(Close err) {
    // rooms.removeWhere((key, value) => value.contains(_ws));
    for (var item in _onErrors!) {
      item(err);
    }
  }

  void _tryOn(dynamic message) {
    try {
      Map<String, dynamic> msg = jsonDecode(message);
      final event = msg['type'];
      final data = msg['data'];
      if (_onEvents!.containsKey(event)) {
        _onEvents![event]!(data);
      }
    } catch (err) {
      return;
    }
  }

  void dispose() {
    _onMessages = null;
    _onEvents = null;
    _onCloses = null;
    _onErrors = null;
  }
}

typedef OpenSocket = void Function(GetSocket socket);

typedef CloseSocket = void Function(Close);

typedef MessageSocket = void Function(dynamic val);

class Close {
  final GetSocket socket;
  final String message;
  final int reason;

  Close(this.socket, this.message, this.reason);
}
