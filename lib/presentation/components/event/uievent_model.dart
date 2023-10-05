import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiEventModel {
  final int id;
  String? title;
  UiOwnerModel? owner;
  List<BaseUiKitMedia> media;
  bool? favorite;
  bool isRecurrent;
  DateTime? date;
  DateTime? dateTo;
  TimeOfDay? time;
  TimeOfDay? timeTo;
  String? description;
  String? location;
  List<UiKitTag> tags;
  List<UiKitTag> baseTags;
  double? rating;
  bool archived;
  List<String> weekdays;
  List<UiDescriptionItemModel>? descriptionItems;

  UiEventModel({
    required this.id,
    this.title,
    this.favorite,
    this.owner,
    this.date,
    this.dateTo,
    this.media = const [],
    this.description,
    this.location,
    this.tags = const [],
    this.baseTags = const [],
    this.rating,
    this.time,
    this.timeTo,
    this.weekdays = const [],
    this.isRecurrent = false,
    this.archived = false,
  }) : descriptionItems = [
          if (formatDate(date, dateTo, time, timeTo, weekdays)  != null)
            UiDescriptionItemModel(
              title: 'Don’t miss it',
              description: formatDate(date, dateTo, time, timeTo, weekdays)!,
            ),
          if (location != null)
            UiDescriptionItemModel(
              title: 'Place',
              description: location,
            ),
        ];

  String? validateCreation(){
    if (title == null || title!.isEmpty) {
      return 'Title is required';
    } else if ( description==null || description!.isEmpty) {
      return 'Description is required';
    } else if (media.isEmpty) {
      return 'Photos are required';
    }

    return null;
  }
}
