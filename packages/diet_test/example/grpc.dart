class FakeHelloServiceClient implements HelloServiceClient {
  @override
  ResponseFuture<HelloResponse> hello(HelloRequest request, {CallOptions options}) {
    return ResponseFuture(FakeClientCall<dynamic, HelloResponse>(_hello(request)));
  }

  Future<HelloResponse> _hello(HelloRequest request) async {
    ...
  }
}

