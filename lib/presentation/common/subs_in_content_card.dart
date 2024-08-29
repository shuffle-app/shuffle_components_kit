import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/subs_or_upsale_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SubsInContentCard extends StatelessWidget {
  final Color? backgroundColor;
  final List<SubsUiModel>? subs;
  final List<UpsaleUiModel>? upsales;
  final ValueChanged<int>? onItemTap;
  final SubsUiModel? selectedSub;
  final UpsaleUiModel? selectedUpsale;

  const SubsInContentCard({
    super.key,
    this.subs,
    this.backgroundColor,
    this.onItemTap,
    this.selectedSub,
    this.upsales,
    this.selectedUpsale,
  });
  //TODO error

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor ?? theme?.colorScheme.surface1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (backgroundColor == null)
            Text(
              S.of(context).Subs,
              style: theme?.boldTextTheme.caption2Medium,
            ).paddingOnly(
              left: SpacingFoundation.horizontalSpacing16,
              bottom: SpacingFoundation.verticalSpacing4,
            ),
          SizedBox(
            height: 1.sw <= 380 ? 140.h : 105.h,
            child: ListView.separated(
              itemCount: subs != null ? subs!.length : upsales!.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace8,
              itemBuilder: (context, index) {
                if (subs != null) {
                  final sub = subs![index];

                  return SubsOrUpsaleItem(
                    limit: sub.bookingLimit,
                    titleOrPrice: sub.title,
                    photoLink: sub.photo?.link,
                    actualLimit: sub.actualbookingLimit,
                    description: sub.description,
                    selectedItem: selectedSub == sub,
                    onEdit: () => onItemTap?.call(sub.id),
                  ).paddingOnly(
                    left: sub == subs!.first ? SpacingFoundation.horizontalSpacing16 : 0,
                    right: sub == subs!.last ? SpacingFoundation.horizontalSpacing16 : 0,
                  );
                } else {
                  final upsale = upsales![index];

                  return SubsOrUpsaleItem(
                    limit: upsale.limit,
                    titleOrPrice: '${upsale.price} ${upsale.currency}',
                    photoLink: upsale.photo?.link,
                    actualLimit: upsale.actualLimit,
                    description: upsale.description,
                    isSubs: false,
                    selectedItem: selectedUpsale == upsale,
                    onEdit: () => onItemTap?.call(upsale.id),
                  ).paddingOnly(
                    left: upsale == upsales!.first ? SpacingFoundation.horizontalSpacing16 : 0,
                    right: upsale == upsales!.last ? SpacingFoundation.horizontalSpacing16 : 0,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
