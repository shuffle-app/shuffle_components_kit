import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventComponent extends StatelessWidget {
  final UiEventModel event;
  final bool isEligibleForEdit;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSharePressed;
  final ComplaintFormComponent? complaintFormComponent;

  const EventComponent({
    Key? key,
    required this.event,
    this.isEligibleForEdit = false,
    this.onEditPressed,
    this.onSharePressed,
    this.complaintFormComponent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentEventModel model = kIsWeb
        ? ComponentEventModel(
            version: '0',
            pageBuilderType: PageBuilderType.page,
            positionModel:
                PositionModel(bodyAlignment: Alignment.topLeft, version: '', horizontalMargin: 16, verticalMargin: 10))
        : ComponentEventModel.fromJson(config['event']);

    final theme = context.uiKitTheme;
    final titleAlignment = model.positionModel?.titleAlignment;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return ListView(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SpacingFoundation.verticalSpace8,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: titleAlignment.mainAxisAlignment,
          crossAxisAlignment: titleAlignment.crossAxisAlignment,
          children: [
            if (event.title != null) ...[
              SizedBox(
                width: 1.sw,
                child: Stack(
                  alignment: titleAlignment.crossAxisAlignment == CrossAxisAlignment.center
                      ? Alignment.center
                      : AlignmentDirectional.topStart,
                  children: [
                    SizedBox(
                      width: 1.sw - (56.w),
                      child: AutoSizeText(
                        event.title!,
                        minFontSize: 18.w,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        stepGranularity: 1.w,
                        style: theme?.boldTextTheme.title2,
                        textAlign: titleAlignment.textAlign,
                      ),
                    ),
                    if (isEligibleForEdit)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: ImageWidget(
                              iconData: ShuffleUiKitIcons.pencil,
                              color: Colors.white,
                              height: 20.h,
                              fit: BoxFit.fitHeight),
                          onPressed: () => onEditPressed?.call(),
                        ),
                      ),
                    if (onSharePressed != null)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: onSharePressed,
                          child: ImageWidget(
                            iconData: ShuffleUiKitIcons.share,
                            color: context.uiKitTheme?.colorScheme.darkNeutral800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SpacingFoundation.verticalSpace8,
            ],
            if (event.archived) ...[
              UiKitBadgeOutlined.text(
                text: S.of(context).Archived,
              ),
              SpacingFoundation.verticalSpace4,
            ],
            if (event.owner != null) event.owner!.buildUserTile(context)
          ],
        ),
        SpacingFoundation.verticalSpace16,
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: bodyAlignment.mainAxisAlignment,
        //   crossAxisAlignment: bodyAlignment.crossAxisAlignment,
        //   children: [
        Align(
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              UiKitPhotoSlider(
                media: event.media,
                onTap: null,
                width: 1.sw - horizontalMargin * 2,
                height: 156.h,
                actions: [
                  if (complaintFormComponent != null)
                    context.smallOutlinedButton(
                      blurred: true,
                      data: BaseUiKitButtonData(
                        iconInfo: BaseUiKitButtonIconData(
                          iconData: ShuffleUiKitIcons.alertcircle,
                          color: context.uiKitTheme?.colorScheme.darkNeutral800,
                        ),
                        onPressed: () {
                          showUiKitGeneralFullScreenDialog(
                            context,
                            GeneralDialogData(
                              topPadding: 0.3.sh,
                              useRootNavigator: false,
                              child: complaintFormComponent!,
                            ),
                          );
                        },
                      ),
                      color: Colors.white.withOpacity(0.01),
                      blurValue: 25,
                    ),
                ],
              ),
            ],
          ),
        ),
        SpacingFoundation.verticalSpace14,
        UiKitTagsWidget(
          rating: event.rating,
          baseTags: event.baseTags,
          uniqueTags: event.tags,
        ),
        SpacingFoundation.verticalSpace14,
        if (event.description != null) ...[
          RepaintBoundary(child: DescriptionWidget(description: event.description!)),
          SpacingFoundation.verticalSpace16
        ],
        SpacingFoundation.verticalSpace16,
        if (event.descriptionItems != null)
          ...event.descriptionItems!
              .map((e) => GestureDetector(
                  onTap: () {
                    if (e.descriptionUrl != null) {
                      launchUrlString(e.descriptionUrl!);
                    } else if (e.description.startsWith('http')) {
                      launchUrlString(e.description);
                    } else if (e.description.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                      launchUrlString('tel:${e.description}');
                    }
                  },
                  child: TitledAccentInfo(
                    title: e.title,
                    info: e.description,
                    showFullInfo: true,
                  )).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4))
              .toList(),
        SpacingFoundation.verticalSpace16,
        // ],
        // ),
      ],
      // ),
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
      horizontal: horizontalMargin,
    );
  }
}
