// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final String id;
  final String name;
  // TODO: Add your entity properties here

  const WalletEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
