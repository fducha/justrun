import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Exercise extends Equatable {
  final String title;
  final Color color;

  Exercise({
    @required this.title,
    @required this.color,
  });

  @override
  List<Object> get props => [title, color];

  @override
  String toString() => title;
}