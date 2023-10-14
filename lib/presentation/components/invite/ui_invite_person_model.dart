import 'package:shuffle_components_kit/presentation/components/invite_to_favourite_places/ui_invite_to_favourite_places_model.dart';

class UiInvitePersonModel extends UiInviteToFavouritePlacesModel {
  final String name;
  final String description;
  final String? avatarLink;
  final int? rating;
  final bool? handshake;
  bool isSelected;

  UiInvitePersonModel({
    super.date,
    this.isSelected = false,
    required this.name,
     this.rating,
     this.handshake,
     this.avatarLink,
    required this.description,
  });
}
