import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class FeedbackReaderComponent extends StatelessWidget {
  const FeedbackReaderComponent({
    super.key,
    required this.reviews,
    this.helpfulCount,
    this.onHelpfulTap,
  });

  final List<FeedbackUiModel> reviews;
  final ValueChanged<int>? onHelpfulTap;
  final ValueNotifier<int>? helpfulCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    const divider = Divider(
      height: 2,
      thickness: 3,
      color: ColorsFoundation.surface2,
    );
    return UiKitCardWrapper(
      padding: EdgeInsets.zero,
      color: theme?.colorScheme.surface,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final e = reviews[index];
          return helpfulCount != null
              ? ValueListenableBuilder(
                  valueListenable: helpfulCount!,
                  builder: (context, value, child) => UiKitFeedbackCard(
                    text: e.feedbackText,
                    media: e.media,
                    onLike: () => onHelpfulTap?.call(e.id),
                    title: e.feedbackAuthorName,
                    avatarUrl: e.feedbackAuthorPhoto,
                    helpfulCount: value,
                    datePosted: e.feedbackDateTime,
                    maxLines: 100,
                    rating: e.feedbackRating,
                    customBackgroundColor: theme?.colorScheme.surface,
                    userTileType: e.feedbackAuthorType,
                    showTranslateButton: e.showTranslateButton,
                    translateText: e.translateText,
                    onEdit: e.onEdit,
                    canEdit: e.canEdit,
                  ),
                )
              : UiKitFeedbackCard(
                  text: e.feedbackText,
                  media: e.media,
                  onLike: () => onHelpfulTap?.call(e.id),
                  title: e.feedbackAuthorName,
                  avatarUrl: e.feedbackAuthorPhoto,
                  helpfulCount: e.helpfulCount,
                  datePosted: e.feedbackDateTime,
                  maxLines: 100,
                  rating: e.feedbackRating,
                  customBackgroundColor: theme?.colorScheme.surface,
                  userTileType: e.feedbackAuthorType,
                  showTranslateButton: e.showTranslateButton,
                  translateText: e.translateText,
                  onEdit: e.onEdit,
                  canEdit: e.canEdit,
                );
        },
        separatorBuilder: (BuildContext context, int index) =>
            divider.paddingSymmetric(vertical: EdgeInsetsFoundation.vertical16),
        itemCount: reviews.length,
      ),
    ).paddingOnly(top: EdgeInsetsFoundation.vertical16, bottom: EdgeInsetsFoundation.vertical24);
  }
}
