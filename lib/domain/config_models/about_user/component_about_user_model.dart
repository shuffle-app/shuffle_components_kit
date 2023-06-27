import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

part 'component_about_user_model.g.dart';

@JsonSerializable()
class ComponentAboutUserModel extends UiBaseModel {

  @JsonKey(name: 'content')
  final ContentBaseModel content;

  ComponentAboutUserModel( {
    required super.version,
    required this.content,
    required super.pageBuilderType,
    super.positionModel,
  });

  factory ComponentAboutUserModel.fromJson(Map<String, dynamic> json) => _$ComponentAboutUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentAboutUserModelToJson(this);
}
