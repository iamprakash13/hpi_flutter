import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/feedback/v1test/feedback_service.pbgrpc.dart';

import 'feedback.dart';

@immutable
class FeedbackBloc {
  FeedbackBloc(Uri serverUrl)
      : assert(serverUrl != null),
        _client = FeedbackServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50064,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  final FeedbackServiceClient _client;

  Future<Feedback> sendFeedback(Feedback feedback) {
    assert(feedback != null);

    return _client
        .createFeedback(CreateFeedbackRequest()..feedback = feedback.toProto())
        .then((f) => Feedback.fromProto(f));
  }
}
