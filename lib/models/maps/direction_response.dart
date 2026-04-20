class DirectionsResponse {
  final String status;
  final List<dynamic> routes;

  DirectionsResponse({required this.status, required this.routes});

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) {
    return DirectionsResponse(status: json['status'], routes: json['routes']);
  }
}
