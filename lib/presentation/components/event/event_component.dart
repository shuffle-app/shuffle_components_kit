import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class EventComponent extends StatelessWidget {
  final UiEventModel event;

  const EventComponent({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentEventModel model =
        ComponentEventModel.fromJson(config['event']);

    final theme = context.uiKitTheme;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final titleAlignment = model.positionModel?.titleAlignment;

    return Column(
      children: [
        SpacingFoundation.verticalSpace4,
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: titleAlignment.mainAxisAlignment,
            crossAxisAlignment: titleAlignment.crossAxisAlignment,
            children: [
              if (event.title != null) ...[
                Text(
                  event.title!,
                  style: theme?.boldTextTheme.title2,
                ),
                SpacingFoundation.verticalSpace4,
              ],
              if (event.owner != null) event.owner!.buildUserTile(context)
            ]),
        SpacingFoundation.verticalSpace4,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: bodyAlignment.mainAxisAlignment,
          crossAxisAlignment: bodyAlignment.crossAxisAlignment,
          children: [
            UiKitMediaSliderWithTags(
              rating: event.rating,
              media: event.media ?? [],
              description: event.description ?? '',
              baseTags: event.baseTags ?? [],
              uniqueTags: event.tags ?? [],
            ),

            // if (event.media != null) ...[
            //   UiKitPhotoSlider(
            //     media: event.media!,
            //     width: size.width,
            //     height: 256,
            //   ),
            //   SpacingFoundation.verticalSpace12
            // ],
            // UiKitTagsWidget(
            //   rating: null,
            //   baseTags: event.baseTags ?? [],
            //   uniqueTags: event.tags ?? [],
            // ),
            // SpacingFoundation.verticalSpace12,
            // if (event.description != null) ...[
            //   Text(
            //     event.description!,
            //     style: theme?.boldTextTheme.caption1Bold
            //         .copyWith(color: Colors.white),
            //   ),
            //   SpacingFoundation.verticalSpace16
            // ],
            if (event.descriptionItems != null)
              ...event.descriptionItems!
                  .map((e) => TitledAccentInfo(
                        title: e.title,
                        info: e.description,
                      ).paddingSymmetric(
                          vertical: SpacingFoundation.verticalSpacing4))
                  .toList()
            // SpacingFoundation.verticalSpace16,
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(
        vertical: model.positionModel?.verticalMargin ?? 0,
        horizontal: model.positionModel?.horizontalMargin ?? 0);
  }
}
