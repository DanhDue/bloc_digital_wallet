// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

/// Entity for Profile in Settings module
class ProfileEntity extends Equatable {
  final String id;
  final String name;
  // TODO: Add your entity properties

  const ProfileEntity({
    required this.id,
    required this.name,
    // TODO: Add your constructor parameters
  });

  @override
  List<Object?> get props => [
    id,
    name,
    // TODO: Add your properties to props
  ];

  /// Create a copy with some properties changed
  ProfileEntity copyWith({
    String? id,
    String? name,
    // TODO: Add your copyWith parameters
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      // TODO: Add your copyWith properties
    );
  }
}
