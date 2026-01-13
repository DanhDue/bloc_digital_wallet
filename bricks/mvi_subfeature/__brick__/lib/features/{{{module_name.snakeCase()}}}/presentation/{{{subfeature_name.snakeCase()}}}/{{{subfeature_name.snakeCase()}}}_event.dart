// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import '../../../../core/architecture/architecture.dart';

/// Message types for ShowMessage event
enum MessageType { success, error, info }

/// Events for {{subfeature_name.pascalCase()}} subfeature (OUTPUT: ViewModel → View)
sealed class {{subfeature_name.pascalCase()}}Event extends BaseEvent {
  const {{subfeature_name.pascalCase()}}Event();
}

/// Show message (Toast/Snackbar)
class ShowMessage extends {{subfeature_name.pascalCase()}}Event {
  final String message;
  final MessageType type;

  const ShowMessage(this.message, {this.type = MessageType.info});
  const ShowMessage.success(this.message) : type = MessageType.success;
  const ShowMessage.error(this.message) : type = MessageType.error;
}
