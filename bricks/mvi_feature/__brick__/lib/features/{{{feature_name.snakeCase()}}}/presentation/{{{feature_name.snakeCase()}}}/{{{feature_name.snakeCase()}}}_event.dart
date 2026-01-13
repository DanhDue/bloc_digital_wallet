// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Message types for ShowMessage event
enum MessageType { success, error, info }

/// Events for {{feature_name.pascalCase()}} feature (OUTPUT: ViewModel → View)
sealed class {{feature_name.pascalCase()}}Event extends BaseEvent {
  const {{feature_name.pascalCase()}}Event();
}

/// Show message (Toast/Snackbar)
class ShowMessage extends {{feature_name.pascalCase()}}Event {
  final String message;
  final MessageType type;

  const ShowMessage(this.message, {this.type = MessageType.info});
  const ShowMessage.success(this.message) : type = MessageType.success;
  const ShowMessage.error(this.message) : type = MessageType.error;
}
