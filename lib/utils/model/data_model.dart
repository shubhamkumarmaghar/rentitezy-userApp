import 'package:equatable/equatable.dart';

class DataModel extends Equatable {
  final String name;
  final String value;
  final Function? onTap;

  const DataModel({required this.value, required this.name, this.onTap});

  @override
  List<Object> get props => [name, value, if (onTap != null) onTap!];
}
