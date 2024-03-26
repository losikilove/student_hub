enum StatusCode {
  ok(code: 201),
  error(code: 400);

  final int code;

  const StatusCode({required this.code});
}

class ApiUtil {
  static const port = 4400;
  static const url = 'http://localhost:$port';
}
