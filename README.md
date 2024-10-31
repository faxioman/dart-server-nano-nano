# server_nano_nano

A super light http server written in dart.
This project is a clone of the great [server_nano](https://pub.dev/packages/server_nano) project but:
- no websocket support
- no performance mode
- some fixes

## 🚀 Getting Started

### Installation

To integrate `server_nano_nano` into your Dart project:

```shell
dart pub add server_nano_nano
```

### Basic Usage

Here's a basic example to get you started:

```dart
import 'package:server_nano_nano/server_nano_nano.dart';

void main() {
  final server = Server();

  // sync requests
  server.get('/', (req, res) {
    res.send('Hello World!');
  });

  // async requests
  server.get('/user/:id', (req, res) async {
    // Simulate a db query delay
    await Future.delayed(Duration(seconds: 2));
    res.send('Hello User ${req.params['id']}!');
  });

  server.listen(port: 3000);
}
```

# Why to use server_nano_nano? 🤔

- **Friendly API**: `server_nano_nano` provides an intuitive API that is easy to use. It is like express.js but in dart (and faster).
- **Middlewares**: `server_nano_nano` supports middlewares to help you manipulate request and response objects.
- **Static Files**: `server_nano_nano` supports serving static files out of the box.
- **Security**: `server_nano_nano` supports https and has a helmet middleware to mitigate common web vulnerabilities.
- **Cross-platform**: `server_nano_nano` is cross-platform and can run on ANY THING!
- **Open Source**: `server_nano_nano` is open source and free to use.
- **Minimal Footprint**: `server_nano_nano` has a minimal footprint for optimal efficiency. You can read the entire source code in a few minutes.

# 📘 API Reference:

## Server:

### HTTP:

`server_nano_nano` supports a variety of HTTP methods like GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD, CONNECT and TRACE. The syntax for each method is straightforward:

```dart
server.get('/path', handler);
server.post('/path', handler);
server.put('/path', handler);
server.delete('/path', handler);
// ... and so on for other methods.
```

Where `handler` is a function that takes in a `Request` and `Response` object.
Example:

```dart
 server.get('/user/:id', (req, res) {
    final id = req.params['id'];
    res.send('Hello User $id!');
  });
```

### Request:

The `ContextRequest` class provides a representation of the HTTP request. It provides several methods and properties to help extract request information:

- **header(name)**: Retrieves a list of headers for the given name.
- **accepts(type)**: Checks if the request accepts a specific MIME type.
- **isMultipart**: Checks if the request's content type is 'multipart/form-data'.
- **isJson**: Checks if the request's content type is 'application/json'.
- **isForm**: Checks if the request's content type is 'application/x-www-form-urlencoded'.
- **isFormData**: Checks if the request's content type is 'multipart/form-data'.
- **isFile**: Checks if the request's content type is 'application/octet-stream'.
- **isForwarded**: Checks if the request has been forwarded by a proxy or load balancer.
- **isMime(type, {bool loose = true})**: Checks if the request's content type matches a specific MIME type. The `loose` parameter allows for partial matching of MIME types.
- **contentType**: Retrieves the content type of the request.
- **hasContentType**: Checks if the request has a content type header.
- **input**: Gets the raw `HttpRequest` object.
- **query**: Retrieves the query parameters of the request as a map.
- **params**: Retrieves the route parameters of the request as a map.
- **cookies**: Retrieves a list of cookies sent with the request.
- **path**: Retrieves the path of the request.
- **uri**: Retrieves the full URI of the request.
- **session**: Retrieves the session associated with the request.
- **method**: Retrieves the HTTP method of the request.
- **certificate**: Retrieves the SSL certificate used in the request (if applicable).
- **param(name)**: Retrieves a specific parameter by name. First checks route parameters, then query parameters.
- **payload({Encoding encoder = utf8})**: Asynchronously retrieves the request's payload.

The `MultipartUpload` class represents a file or data segment from a 'multipart/form-data' request. It provides methods to convert the upload into a file or JSON representation.

- **name**: The name of the upload.
- **filename**: The filename of the upload.
- **contentType**: The content type of the upload.
- **data**: The data of the upload.
- **toFile({String path})**: Converts the upload into a file. If `path` is specified, the file will be written to that path. Otherwise, a temporary file will be created.
- **toJson()**: Converts the upload into a JSON representation.

### Response:

The `ContextResponse` class provides a variety of methods to help you construct your response. Here's a list of all the methods available:

- **getHeader(String name)**: Retrieves a header by its name.
- **setHeader(String name, Object value)**: Sets a header with a specific value.
- **addDisposeCallback(DisposeCallback disposer)**: Adds a callback that will be called when the response is disposed.
- **setContentType(String contentType)**: Sets the Content-Type header.
- **cache(String cacheType, [Map<String, String> options = const {}])**: Sets the Cache-Control header.
- **status(int code)**: Sets the HTTP status code of the response.
- **setCookie(String name, String val, [Map<String, dynamic> options = const {}])**: Sets a cookie with optional parameters.
- **deleteCookie(String name, [String path = '/'])**: Deletes a cookie by its name and optional path.
- **getCookie(String name)**: Retrieves a cookie by its name.
- **attachment(String filename)**: Sets the Content-Disposition header to "attachment" with a given filename.
- **mime(String path)**: Sets the Content-Type based on a file's extension.
- **send(Object string)**: Sends a plain text response.
- **sendJson(Object data)**: Sends a JSON response.
- **sendHtmlText(Object data)**: Sends an HTML text response.
- **sendFile(String path)**: Sends a file as a response.
- **close()**: Closes the response and calls any dispose callbacks.
- **redirect(String url, [int code = 302])**: Redirects the response to a specific URL with an optional status code.

Each method is chainable, allowing for a fluent interface when constructing responses. For example:

```dart
res.status(200).setContentType('text/plain').send('Hello, World!');
```

### Middlewares:

Middlewares allow you to manipulate request and response objects before they reach your route handlers. They are executed in the order they are added.

#### Helmet:

`Helmet` is a middleware that sets HTTP headers to protect against some well-known web vulnerabilities. Here's an example of how to use the Helmet middleware:

```dart
server.use(Helmet());
```

###### Headers set by Helmet:

- `X-XSS-Protection`: Helps in preventing cross-site scripting attacks.
- `X-Content-Type-Options`: Helps in preventing MIME-type confusion attacks.
- `X-Frame-Options`: Helps in preventing clickjacking attacks.
- `Referrer-Policy`: Controls the referrer policy of the app.
- `Content-Security-Policy`: Helps in preventing content injection attacks.

#### Cors:

`Cors` is a middleware that allows cross-origin resource sharing. Here's an example of how to use the Cors middleware:

```dart
server.use(Cors());
```

#### Creating Custom Middlewares:

Creating a custom middleware is straightforward. Simply extend the `Middleware` class and override the `handler` method.

```dart
class CustomMiddleware extends Middleware {
  @override
  Future<bool> handler(ContextRequest req, ContextResponse res) async{
    // Your custom logic here.

    // Return true to continue to the next middleware.
    // Return false to stop the middleware chain.
    return true;

  }
}
```

### Listen:

To start your server, call the `listen` method on your server instance:

```dart
server.listen(port: 3000);
```

#### SSL/TLS:

You can make your server serve over HTTPS by providing SSL/TLS certificate details:

```dart
server.listen(
  host: '0.0.0.0',
  port: 8080,
  certificateChain: 'path_to_certificate_chain.pem',
  privateKey: 'path_to_private_key.pem',
  password: 'optional_password_for_key',
);
```

#### Serving Static Files:

`server_nano_nano` supports serving static files out of the box. Simply call the `static` method on your server instance:

```dart
server.static('/path/to/static/files');
```

###### Options:

- `listing`: Allows directory listing. Default is `true`.
- `links`: Allows following links. Default is `true`.
- `jail`: Restricts access to the specified path. Default is `true`.

## 🤝 Contributing

If you'd like to contribute to the development of `server_nano_nano`, open a pull request.

## 📜 License

`server_nano_nano` is distributed under the [MIT License](#).
