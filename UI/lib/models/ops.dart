class Ops {
  final int ops;
  Ops({
    required this.ops
  });


  factory Ops.fromJson(Map<String, dynamic> json) => _$OpsFromJson(json);
  Map<String, dynamic> toJson() => _$OpsToJson(this);
}


Ops _$OpsFromJson(Map<String, dynamic> json) {
  return Ops(
    ops: json['ops'] as int,
  );
}

Map<String, dynamic> _$OpsToJson(Ops instance) => <String, dynamic>{
      'option': instance.ops,
};