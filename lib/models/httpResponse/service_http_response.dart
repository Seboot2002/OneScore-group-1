class ServiceHttpResponse {
  int? status;
  dynamic? body;

  ServiceHttpResponse({this.status, this.body});

  Map<String, dynamic> toJson() {
    return {'status': status, 'body': body};
  }

  factory ServiceHttpResponse.fromMap(Map<String, dynamic> map) {
    return ServiceHttpResponse(status: map['status'], body: map['body']);
  }

  @override
  String toString() {
    return 'ServiceHttpResponse{status: $status, body: $body}';
  }
}
