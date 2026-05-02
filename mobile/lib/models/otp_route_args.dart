class OtpRouteArgs {
  const OtpRouteArgs({
    required this.phoneDigits,
    required this.requestId,
    this.serverMessage,
    this.channel,
  });

  final String phoneDigits;
  final String requestId;
  final String? serverMessage;
  /// Backend `channel`: `test` | `whatsapp` | … — used for QA-only autofill.
  final String? channel;
}
