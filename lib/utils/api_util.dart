enum StatusCode {
  ok(code: 201),
  error(code: 400);

  final int code;

  const StatusCode({required this.code});
}

class ApiUtil {
  static const port = 4400;
  static const domain = '10.0.2.2';
  static const baseUrl = 'http://34.125.167.164/api';
}
