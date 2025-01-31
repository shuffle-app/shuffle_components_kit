import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

final AutoSizeGroup _group = AutoSizeGroup();

class PlaceComponent extends StatefulWidget {
  final UiPlaceModel place;
  final bool isEligibleForEdit;
  final VoidCallback? onEventCreate;
  final VoidCallback? onEditPressed;
  final VoidCallback? onArchivePressed;
  final Future<bool> Function()? onAddReactionTapped;
  final ValueNotifier<List<UiEventModel>?>? events;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<UiEventModel>? onEventTap;
  final VoidCallback? onSharePressed;
  final PagedLoaderCallback<VideoReactionUiModel> placeReactionLoaderCallback;
  final PagedLoaderCallback<VideoReactionUiModel> eventReactionLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> placeFeedbackLoaderCallback;
  final PagedLoaderCallback<FeedbackUiModel> eventFeedbackLoaderCallback;
  final ValueChanged<VideoReactionUiModel>? onReactionTap;
  final Future<EditReviewModel> Function(FeedbackUiModel)? onFeedbackTap;
  final Future<bool> Function()? onAddFeedbackTapped;
  final Future<bool> Function(int placeId) canLeaveFeedbackCallback;
  final Future<bool> Function(int eventId) canLeaveFeedbackForEventCallback;
  final bool canLeaveVideoReaction;
  final ValueChanged<int>? onLikedFeedback;
  final ValueChanged<int>? onDislikedFeedback;
  final bool showInviteList;
  final bool showOfferButton;
  final int? priceForOffer;
  final VoidCallback? onOfferButtonTap;
  final ValueNotifier<BookingUiModel?>? bookingNotifier;
  final VoidCallback? onSpendPointTap;
  final ValueNotifier<String?>? translateDescription;
  final ValueNotifier<bool>? showTranslateButton;
  final int? currentUserId;
  final Set<int>? likedReviews;

  const PlaceComponent({
    super.key,
    required this.place,
    required this.placeReactionLoaderCallback,
    required this.eventReactionLoaderCallback,
    required this.placeFeedbackLoaderCallback,
    required this.eventFeedbackLoaderCallback,
    required this.canLeaveFeedbackCallback,
    required this.canLeaveFeedbackForEventCallback,
    this.showInviteList = true,
    this.onFeedbackTap,
    this.onEditPressed,
    this.onReactionTap,
    this.onAddFeedbackTapped,
    this.complaintFormComponent,
    this.isEligibleForEdit = false,
    this.onEventCreate,
    this.onAddReactionTapped,
    this.onEventTap,
    this.onSharePressed,
    this.events,
    this.onLikedFeedback,
    this.onDislikedFeedback,
    this.canLeaveVideoReaction = false,
    this.showOfferButton = false,
    this.priceForOffer,
    this.onOfferButtonTap,
    this.bookingNotifier,
    this.onSpendPointTap,
    this.onArchivePressed,
    this.translateDescription,
    this.showTranslateButton,
    this.currentUserId,
    this.likedReviews,
  });

  @override
  State<PlaceComponent> createState() => _PlaceComponentState();
}

class _PlaceComponentState extends State<PlaceComponent> {
  final reactionsPagingController = PagingController<int, VideoReactionUiModel>(firstPageKey: 1);

  final feedbacksPagedController = PagingController<int, FeedbackUiModel>(firstPageKey: 1);

  // Set<int> likedReviews = {};

  final ScrollController listViewController = ScrollController();

  bool get _noFeedbacks => feedbacksPagedController.itemList?.isEmpty ?? true;

  bool get _noReactions => reactionsPagingController.itemList?.isEmpty ?? true;

  bool? canLeaveFeedback;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      canLeaveFeedback = await widget.canLeaveFeedbackCallback.call(widget.place.id);
      reactionsPagingController.addPageRequestListener(_reactionsListener);
      feedbacksPagedController.addPageRequestListener(_feedbacksListener);
      reactionsPagingController.notifyPageRequestListeners(1);
      feedbacksPagedController.notifyPageRequestListeners(1);
      setState(() {});
    });
  }

  void _reactionsListener(int page) async {
    final data = await widget.placeReactionLoaderCallback(page, widget.place.id);
    if (data.any((e) => reactionsPagingController.itemList?.any((el) => el.id == e.id) ?? false)) return;
    if (data.isEmpty) {
      reactionsPagingController.appendLastPage(data);
      return;
    }
    if (data.last.empty) {
      data.removeLast();
      reactionsPagingController.appendLastPage(data);
    } else {
      if (data.length < 10) {
        reactionsPagingController.appendLastPage(data);
      } else {
        reactionsPagingController.appendPage(data, page + 1);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _updateFeedbackList(int feedbackId, int addValue) {
    final updatedFeedbackIndex = feedbacksPagedController.itemList?.indexWhere((element) => element.id == feedbackId);
    if (updatedFeedbackIndex != null && updatedFeedbackIndex >= 0) {
      final updatedFeedback = feedbacksPagedController.itemList?.removeAt(updatedFeedbackIndex);
      if (updatedFeedback != null) {
        feedbacksPagedController.itemList?.insert(
          updatedFeedbackIndex,
          updatedFeedback.copyWith(
              helpfulCount: (updatedFeedback.helpfulCount ?? 0) + addValue, helpfulForUser: addValue > 0),
        );
      }
    }
    setState(() {});
  }

  void _feedbacksListener(int page) async {
    final data = await widget.placeFeedbackLoaderCallback(page, widget.place.id);
    if (data.any((e) => feedbacksPagedController.itemList?.any((el) => el.id == e.id) ?? false)) return;
    widget.likedReviews?.addAll(data.where((e) => e.helpfulForUser ?? false).map((e) => e.id));
    if (data.isEmpty) {
      feedbacksPagedController.appendLastPage(data);
      return;
    }
    if (data.last.empty) {
      data.removeLast();
      feedbacksPagedController.appendLastPage(data);
    } else {
      if (data.length < 10) {
        feedbacksPagedController.appendLastPage(data);
      } else {
        feedbacksPagedController.appendPage(data, page + 1);
      }
    }
    setState(() {});
  }

  Future<void> _handleAddReactionTap() async {
    final addedReaction = await widget.onAddReactionTapped?.call();
    if (addedReaction == true) {
      setState(() {
        reactionsPagingController.refresh();
      });
    }
  }

  @override
  void dispose() {
    reactionsPagingController.dispose();
    feedbacksPagedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = kIsWeb
        ? ComponentPlaceModel(
            version: '',
            pageBuilderType: PageBuilderType.page,
            positionModel: PositionModel(
              version: '',
              horizontalMargin: 16,
              verticalMargin: 10,
              bodyAlignment: Alignment.centerLeft,
            ),
          )
        : ComponentPlaceModel.fromJson(config['place']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;

    final isSmallScreen = MediaQuery.sizeOf(context).width <= 375;

    return ListView(
      addAutomaticKeepAlives: false,
      cacheExtent: 0.0,
      physics: const BouncingScrollPhysics(),
      controller: listViewController,
      children: [
        SpacingFoundation.verticalSpace16,
        TitleWithAvatar(
          title: widget.place.title,
          avatarUrl: widget.place.logo,
          horizontalMargin: horizontalMargin,
          trailing: widget.isEligibleForEdit
              ? IconButton(
                  icon: ImageWidget(
                    link: GraphicsFoundation.instance.svg.pencil.path,
                    height: 20.h,
                    color: theme?.colorScheme.inversePrimary,
                    fit: BoxFit.fitHeight,
                  ),
                  onPressed: () => widget.onEditPressed?.call(),
                )
              : GestureDetector(
                  onTap: widget.onSharePressed,
                  child: Icon(
                    ShuffleUiKitIcons.share,
                    color: colorScheme?.darkNeutral800,
                  ),
                ),
        ),
        if (widget.place.archived) ...[
          SpacingFoundation.verticalSpace8,
          InkWell(
              borderRadius: BorderRadiusFoundation.all24,
              onTap: () => widget.onArchivePressed?.call(),
              child: UiKitBadgeOutlined.text(
                text: S.of(context).Archived,
              )),
        ],
        SpacingFoundation.verticalSpace16,
        UiKitMediaSliderWithTags(
          listViewController: listViewController,
          rating: widget.place.rating,
          media: widget.place.media,
          description: widget.place.description,
          translateDescription: widget.translateDescription,
          baseTags: widget.place.baseTags,
          showTranslateButton: widget.showTranslateButton,
          uniqueTags: widget.place.tags,
          horizontalMargin: horizontalMargin,
          branches: widget.place.branches,
          onImageTap: (index) {
            final media = widget.place.media[index];
            final heroTag = '${media.link}--$index';
            if (media.link.isEmpty) return;

            context.push(
              PhotoDialog(
                images: widget.place.media.map((e) => e.link).toList(),
                initialIndex: index,
                tag: heroTag,
              ),
              nativeTransition: false,
              transitionDuration: const Duration(milliseconds: 500),
            );
          },
          actions: [
            if (widget.complaintFormComponent != null)
              context.smallOutlinedButton(
                blurred: true,
                data: BaseUiKitButtonData(
                  backgroundColor: Colors.white.withOpacity(0.01),
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
                        child: widget.complaintFormComponent!,
                      ),
                    );
                  },
                ),
                blurValue: 25,
              ),
          ],
        ),
        if (widget.showOfferButton)
          UiKitCardWrapper(
            color: theme?.colorScheme.surface1,
            padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
            borderRadius: BorderRadiusFoundation.all24r,
            child: Column(
              children: [
                Text(
                  S.of(context).CreateAUSP(widget.priceForOffer ?? 5),
                  style: boldTextTheme?.caption1Medium,
                ),
                SpacingFoundation.verticalSpace4,
                SizedBox(
                  width: double.infinity,
                  child: context.smallOutlinedButton(
                    gradient: GradientFoundation.defaultLinearGradient,
                    data: BaseUiKitButtonData(
                      text: S.of(context).Offer.toUpperCase(),
                      onPressed: widget.onOfferButtonTap,
                    ),
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(
            horizontal: horizontalMargin,
            vertical: SpacingFoundation.verticalSpacing24,
          ),
        if (widget.bookingNotifier != null)
          ListenableBuilder(
            listenable: widget.bookingNotifier!,
            builder: (context, child) => AnimatedSize(
              duration: const Duration(milliseconds: 250),
              child: (widget.bookingNotifier?.value?.subsUiModel != null &&
                      widget.bookingNotifier!.value!.showSubsInContentCard &&
                      widget.bookingNotifier!.value!.subsUiModel!.isNotEmpty)
                  ? SizedBox(
                      width: 1.sw,
                      child: SubsInContentCard(
                        subs: widget.bookingNotifier!.value!.subsUiModel!,
                        onItemTap: (id) {
                          final sub =
                              widget.bookingNotifier!.value!.subsUiModel!.firstWhere((element) => element.id == id);
                          subInformationDialog(context, sub);
                        },
                      ),
                    ).paddingOnly(
                      top: SpacingFoundation.verticalSpacing12,
                      bottom: SpacingFoundation.verticalSpacing24,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        if (widget.isEligibleForEdit && widget.events!.value != null)
          ValueListenableBuilder(
            valueListenable: widget.events!,
            builder: (context, _, __) => AnimatedSize(
              duration: Duration(milliseconds: 250),
              child: UiKitCardWrapper(
                width: 1.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          S.of(context).UpcomingEvent,
                          style: boldTextTheme?.subHeadline,
                        ),
                        SpacingFoundation.horizontalSpace16,
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => showUiKitPopover(
                              context,
                              customMinHeight: 30.h,
                              showButton: false,
                              title: Text(
                                S.current.HintNumberEventsForPro,
                                style: theme?.regularTextTheme.body.copyWith(
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            child: ImageWidget(
                              iconData: ShuffleUiKitIcons.info,
                              width: 16.w,
                              color: theme?.colorScheme.darkNeutral900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.events!.value != null && widget.events!.value!.isNotEmpty) ...[
                      SpacingFoundation.verticalSpace8,
                      for (UiEventModel event in widget.events!.value!)
                        if (event.moderationStatus != null)
                          InkWell(
                            onTap: () => widget.onEventTap?.call(event),
                            borderRadius: BorderRadiusFoundation.all24,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusFoundation.all24,
                                  gradient: LinearGradient(colors: [
                                    theme!.colorScheme.inversePrimary.withOpacity(0.3),
                                    Colors.transparent
                                  ])),
                              child: Center(
                                child: Text(
                                  event.reviewStatus!,
                                  style: boldTextTheme?.caption1Bold.copyWith(color: Colors.white),
                                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing8),
                              ),
                            ),
                          ).paddingOnly(bottom: SpacingFoundation.verticalSpacing16)
                        else
                          ListTile(
                            isThreeLine: false,
                            contentPadding: EdgeInsets.zero,
                            leading: BorderedUserCircleAvatar(
                              imageUrl: event.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
                              size: 40.w,
                            ),
                            title: Text(
                              event.title ?? '',
                              style: boldTextTheme?.caption1Bold,
                            ),
                            subtitle: event.scheduleString != null
                                ? Text(
                                    event.scheduleString!,
                                    style: boldTextTheme?.caption1Medium.copyWith(
                                      color: colorScheme?.darkNeutral500,
                                    ),
                                  )
                                : null,
                            // event.date != null
                            //     ? Text(
                            //         DateFormat('MMMM d').format(event.date!),
                            //         style: theme?.boldTextTheme.caption1Medium.copyWith(
                            //           color: theme.colorScheme.darkNeutral500,
                            //         ),
                            //       )
                            //     : const SizedBox.shrink(),
                            trailing: context
                                .smallButton(
                                  data: BaseUiKitButtonData(
                                    onPressed: () {
                                      if (widget.onEventTap != null) {
                                        widget.onEventTap?.call(event);
                                      } else {
                                        buildComponent(
                                          context,
                                          ComponentEventModel.fromJson(config['event']),
                                          ComponentBuilder(
                                            child: EventComponent(
                                              event: event,
                                              canLeaveVideoReaction: widget.canLeaveVideoReaction,
                                              canLeaveFeedback: widget.canLeaveFeedbackForEventCallback,
                                              feedbackLoaderCallback: widget.eventFeedbackLoaderCallback,
                                              reactionsLoaderCallback: widget.eventReactionLoaderCallback,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    iconInfo: BaseUiKitButtonIconData(
                                      iconData: CupertinoIcons.right_chevron,
                                      color: colorScheme?.inversePrimary,
                                      size: 20.w,
                                    ),
                                  ),
                                )
                                .paddingOnly(top: SpacingFoundation.verticalSpacing4),
                          )
                    ],
                    SpacingFoundation.verticalSpace16,
                    context.gradientButton(
                      data: BaseUiKitButtonData(
                        text: S.of(context).CreateEvent,
                        onPressed: widget.onEventCreate,
                        fit: ButtonFit.fitWidth,
                      ),
                    )
                  ],
                ).paddingSymmetric(
                  horizontal: SpacingFoundation.horizontalSpacing16,
                  vertical: SpacingFoundation.verticalSpacing8,
                ),
              ).paddingSymmetric(
                horizontal: horizontalMargin,
                vertical: EdgeInsetsFoundation.vertical24,
              ),
            ),
          )
        else if (widget.events != null)
          ValueListenableBuilder(
            valueListenable: widget.events!,
            builder: (context, _, __) {
              log('place test tut  ${widget.events!.value != null && widget.events!.value!.isNotEmpty}');

              return AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: () {
                    final List<UiEventModel> tempSorted = List.from(widget.events?.value ?? []);
                    if (tempSorted.isNotEmpty) {
                      tempSorted.sort((a, b) =>
                          (a.startDayForEvent ?? DateTime.now()).compareTo(b.startDayForEvent ?? DateTime.now()));
                    }

                    final closestEvent = tempSorted.firstOrNull;

                    final Duration daysToEvent =
                        (closestEvent?.startDayForEvent ?? DateTime.now()).difference(DateTime.now());

                    return [
                      Expanded(
                        child: UpcomingEventPlaceActionCard(
                          value: closestEvent == null
                              ? 'none'
                              : S.current.WithInDays(daysToEvent.inDays > 0 ? daysToEvent.inDays : 0),
                          group: _group,
                          rasterIconAsset: GraphicsFoundation.instance.png.events,
                          action: closestEvent == null
                              ? null
                              : () {
                                  if (widget.onEventTap != null) {
                                    widget.onEventTap?.call(closestEvent);
                                  }
                                  // else {
                                  //   buildComponent(context, ComponentEventModel.fromJson(config['event']),
                                  //       ComponentBuilder(child: EventComponent(event: closestEvent!,
                                  //   feedbackLoaderCallback: widget.eventFeedbackLoaderCallback,
                                  //   reactionsLoaderCallback: widget.eventReactionLoaderCallback,
                                  // ),
                                  // ),);
                                  // }
                                },
                        ),
                      ),
                      SpacingFoundation.horizontalSpace8,
                      Expanded(
                        child: PointBalancePlaceActionCard(
                          value: widget.place.userPoints?.toString() ?? '0',
                          group: _group,
                          rasterIconAsset: GraphicsFoundation.instance.png.money,
                          buttonTitle: S.of(context).SpendIt,
                          action: widget.onSpendPointTap,
                          //     () {
                          //   log('balance was pressed');
                          // },
                        ),
                      ),
                    ];
                  }(),
                ),
              );
            },
          ).paddingSymmetric(horizontal: horizontalMargin, vertical: EdgeInsetsFoundation.vertical24),
        if (!_noReactions || widget.canLeaveVideoReaction)
          ValueListenableBuilder(
            valueListenable: reactionsPagingController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                color: colorScheme?.surface1,
                title: _noReactions
                    ? Text(S.of(context).NoReactionsMessage, style: boldTextTheme?.body)
                    : RichText(
                        text: TextSpan(
                        children: [
                          TextSpan(text: '${S.of(context).ReactionsBy} ', style: boldTextTheme?.body),
                          WidgetSpan(
                            child: Transform.translate(offset: const Offset(0, 4), child: const MemberPlate()),
                          ),
                        ],
                      )),
                contentHeight: 0.205.sh,
                content: UiKitHorizontalScrollableList<VideoReactionUiModel>(
                  spacing: SpacingFoundation.horizontalSpacing8,
                  shimmerLoadingChild: UiKitReactionPreview(
                    customHeight: 0.205.sh,
                    imagePath: GraphicsFoundation.instance.png.place.path,
                  ).paddingOnly(
                    left: EdgeInsetsFoundation.horizontal16,
                  ),
                  noItemsFoundIndicator:
                      UiKitReactionPreview.empty(customHeight: 0.205.sh, onTap: _handleAddReactionTap)
                          .paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                  itemBuilder: (context, reaction, index) {
                    if (index == 0 && widget.canLeaveVideoReaction) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          UiKitReactionPreview.empty(customHeight: 0.205.sh, onTap: _handleAddReactionTap)
                              .paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                          UiKitReactionPreview(
                            customHeight: 0.205.sh,
                            imagePath: reaction.previewImageUrl ?? '',
                            viewed: reaction.isViewed,
                            onTap: () => widget.onReactionTap?.call(reaction),
                          ).paddingOnly(left: EdgeInsetsFoundation.horizontal8),
                        ],
                      );
                    }

                    return UiKitReactionPreview(
                      customHeight: 0.205.sh,
                      imagePath: reaction.previewImageUrl ?? '',
                      viewed: false,
                      onTap: () => widget.onReactionTap?.call(reaction),
                    ).paddingOnly(left: index == 0 ? EdgeInsetsFoundation.all16 : 0);
                  },
                  pagingController: reactionsPagingController,
                ),
              );
            },
          ).paddingOnly(bottom: EdgeInsetsFoundation.vertical24),
        if (!_noFeedbacks || (canLeaveFeedback ?? false))
          ValueListenableBuilder(
            valueListenable: feedbacksPagedController,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                title: Text(
                  _noFeedbacks ? S.current.NoReviewsMessage : S.current.ReviewsByCritics,
                  style: boldTextTheme?.body,
                ),
                color: colorScheme?.surface1,
                contentHeight: _noFeedbacks ? 0 : (isSmallScreen ? 166.8.h : 0.28.sh),
                action: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: canLeaveFeedback ?? false
                      ? context
                          .smallOutlinedButton(
                            blurred: false,
                            data: BaseUiKitButtonData(
                              iconInfo: BaseUiKitButtonIconData(
                                iconData: ShuffleUiKitIcons.plus,
                              ),
                              onPressed: () {
                                widget.onAddFeedbackTapped?.call().then((addedFeedback) {
                                  if (addedFeedback) {
                                    setState(() {
                                      canLeaveFeedback = false;
                                      feedbacksPagedController.refresh();
                                      feedbacksPagedController.notifyPageRequestListeners(1);
                                    });
                                  }
                                });
                              },
                            ),
                          )
                          .paddingOnly(right: SpacingFoundation.horizontalSpacing16)
                      : null,
                ),
                content: _noFeedbacks
                    ? null
                    : UiKitHorizontalScrollableList<FeedbackUiModel>(
                        leftPadding: horizontalMargin,
                        spacing: SpacingFoundation.horizontalSpacing8,
                        shimmerLoadingChild: SizedBox(width: 0.95.sw, child: UiKitFeedbackCard()),
                        noItemsFoundIndicator: SizedBox(
                          width: 1.sw,
                          child: Center(
                            child: Text(
                              S.current.NoFeedbacksYet,
                              style: boldTextTheme?.subHeadline,
                            ).paddingAll(EdgeInsetsFoundation.all16),
                          ),
                        ),
                        itemBuilder: (context, feedback, index) {
                          return SizedBox(
                            width: 0.95.sw,
                            child: UiKitFeedbackCard(
                              title: feedback.feedbackAuthorName,
                              avatarUrl: feedback.feedbackAuthorPhoto,
                              userTileType: feedback.feedbackAuthorType,
                              datePosted: feedback.feedbackDateTime,
                              companyAnswered: false,
                              rating: feedback.feedbackRating,
                              text: feedback.feedbackText,
                              media: feedback.media,
                              helpfulCount: feedback.helpfulCount == 0 ? null : feedback.helpfulCount,
                              onPressed: () async {
                                if (widget.onFeedbackTap != null) {
                                  await widget.onFeedbackTap?.call(feedback).then(
                                    (model) {
                                      if (model.isEdited) {
                                        feedbacksPagedController.refresh();
                                        feedbacksPagedController.notifyPageRequestListeners(1);
                                      }
                                      final feedbackId = feedback.id;

                                      if ((model.countToUpdate ?? 0) > 0) {
                                        widget.likedReviews?.add(feedbackId);
                                        widget.onLikedFeedback?.call(feedbackId);
                                        _updateFeedbackList(feedbackId, 1);
                                      } else if ((model.countToUpdate ?? 0) < 0) {
                                        widget.likedReviews?.remove(feedbackId);
                                        widget.onDislikedFeedback?.call(feedbackId);
                                        _updateFeedbackList(feedbackId, -1);
                                      }

                                      setState(() {});
                                    },
                                  );
                                } else {
                                  feedback.onTap?.call();
                                }
                              },
                              onLike: widget.currentUserId == feedback.feedbackAuthorId
                                  ? null
                                  : () {
                                      final feedbackId = feedback.id;
                                      if (widget.likedReviews != null && widget.likedReviews!.contains(feedbackId)) {
                                        widget.likedReviews?.remove(feedbackId);
                                        widget.onDislikedFeedback?.call(feedbackId);
                                        _updateFeedbackList(feedbackId, -1);
                                      } else {
                                        widget.likedReviews?.add(feedbackId);
                                        widget.onLikedFeedback?.call(feedbackId);
                                        _updateFeedbackList(feedbackId, 1);
                                      }
                                      setState(() {});
                                    },
                            ).paddingOnly(left: index == 0 ? horizontalMargin : 0),
                          );
                        },
                        pagingController: feedbacksPagedController,
                      ),
              );
            },
          ).paddingOnly(bottom: EdgeInsetsFoundation.vertical24),
        Wrap(
          runSpacing: SpacingFoundation.verticalSpacing8,
          spacing: SpacingFoundation.horizontalSpacing8,
          children: widget.place.descriptionItems!
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    final url = e.descriptionUrl ?? e.description;

                    if (url.startsWith('http')) {
                      launchUrlString(url);
                    } else if (url.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                      log('launching $url', name: 'PlaceComponent');
                      launchUrlString('tel:${url}');
                    } else if (url == 'times' && widget.place.schedule != null) {
                      showTimeInfoDialog(context, widget.place.schedule!.getReadableScheduleString());
                    } else if (widget.place.location != null && widget.place.location!.isNotEmpty) {
                      showAddressInfoDialog(context, widget.place.location);
                    }
                  },
                  child: UiKitTitledDescriptionGridWidget(
                    title: e.title,
                    description: e.description,
                    spacing: (SpacingFoundation.horizontalSpacing4 + horizontalMargin) / 2,
                  ),
                ),
              )
              .toList(),
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace8,
        (kBottomNavigationBarHeight * 1.5).heightBox,
      ],
    ).paddingSymmetric(vertical: verticalMargin);
  }
}

class EditReviewModel {
  final bool isEdited;
  final int? countToUpdate;

  EditReviewModel({
    required this.isEdited,
    this.countToUpdate,
  });

  EditReviewModel copyWith({
    bool? isEdited,
    int? countToUpdate,
  }) {
    return EditReviewModel(
      isEdited: isEdited ?? this.isEdited,
      countToUpdate: countToUpdate ?? this.countToUpdate,
    );
  }
}
