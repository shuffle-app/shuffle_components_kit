import 'package:json_annotation/json_annotation.dart';

enum ContentItemType {
  @JsonValue('card')
  card,
  @JsonValue('horizontal_list')
  horizontalList,
  @JsonValue('vertical_list')
  verticalList,
  @JsonValue('input')
  input,
  @JsonValue('separator')
  separator,
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('bubbles')
  bubbles,
  @JsonValue('button')
  button,
  @JsonValue('single_select')
  singleSelect,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('toggles')
  toggles,
  @JsonValue('progress_bars')
  progressBars,
  @JsonValue('onboarding_card')
  onboardingCard,
}
