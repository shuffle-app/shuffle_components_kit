import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BottomBookingBar extends StatelessWidget {
  final BookingElementModel model;
  final VoidCallback? onShowRoute;
  final VoidCallback? onBook;
  final VoidCallback? onMagnify;

  const BottomBookingBar(
      {Key? key,
      required this.model,
      this.onShowRoute,
      this.onBook,
      this.onMagnify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment:
              (model.positionModel?.bodyAlignment).crossAxisAlignment,
          mainAxisAlignment:
              (model.positionModel?.bodyAlignment).mainAxisAlignment,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (model.showRoute ?? true)
              context.button(
                text: '',
                onPressed: onShowRoute,
                onlyIcon: true,
                outlined: true,
                icon: ImageWidget(
                  svgAsset: Assets.images.svg.route,
                  color: Colors.white,
                ),
              ),
            SpacingFoundation.horizontalSpace12,
            Expanded(
              child: context.button(
                text: 'Book it',
                onPressed: onBook,
                gradient: true,
              ),
            ),
            SpacingFoundation.horizontalSpace12,
            if (model.showMagnify ?? true)
              context.button(
                text: '',
                onPressed: onMagnify,
                onlyIcon: true,
                outlined: true,
                icon: ImageWidget(
                  svgAsset: Assets.images.svg.searchPeople,
                  color: Colors.white,
                ),
              ),
          ],
        ).paddingSymmetric(
            vertical: model.positionModel?.verticalMargin ?? 0.0,
            horizontal: model.positionModel?.horizontalMargin ?? 0.0));
  }
}
