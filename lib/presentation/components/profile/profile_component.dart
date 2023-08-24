import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_profile_model.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ProfileComponent extends StatelessWidget {
  final UiProfileModel profile;
  final List<HangoutRecommendation>? recommendedUsers;
  final VoidCallback? onFulfillDream;

  const ProfileComponent({
    Key? key,
    required this.profile,
    this.recommendedUsers,
    this.onFulfillDream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model =
        ComponentProfileModel.fromJson(config['profile']);
    final titleAlignment = model.positionModel?.titleAlignment;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return Column(children: [
      Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: titleAlignment.mainAxisAlignment,
              crossAxisAlignment: titleAlignment.crossAxisAlignment,
              children: [profile.cardWidget])
          .paddingSymmetric(horizontal: horizontalMargin),
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: bodyAlignment.mainAxisAlignment,
        crossAxisAlignment: bodyAlignment.crossAxisAlignment,
        children: [
          // SpacingFoundation.verticalSpace24,
          // ProfileAttitudeTabs(
          //   onTappedTab: (index) {},
          //   tabs: const [
          //     ProfileAttitudeTab(title: 'LOVED'),
          //     ProfileAttitudeTab(title: 'HATED'),
          //   ],
          // ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          SpacingFoundation.verticalSpace24,
          Text(
            'Find someone to hang out with',
            style: context.uiKitTheme?.boldTextTheme.title1,
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          SpacingFoundation.verticalSpace24,
          UiKitHorizontalScroll3D(
              itemBuilder: (BuildContext context, int index) =>
                  UiKitFindSomeoneCard(
                      avatarUrl: recommendedUsers?[index].userAvatar ??
                          GraphicsFoundation.instance.png.mockUserAvatar.path,
                      userNickName: recommendedUsers?[index].userNickname ?? '',
                      userName: recommendedUsers?[index].userName ?? '',
                      userPoints:
                          recommendedUsers?[index].userPointsBalance ?? 0,
                      sameInterests:
                          recommendedUsers?[index].commonInterests ?? 0,
                      onMessage: () {
                        SnackBarUtils.show(
                            message: 'in development', context: context);
                      }),
              itemCount: recommendedUsers?.length ?? 0),
          SpacingFoundation.verticalSpace24,
          context
              .gradientButton(
                  data: BaseUiKitButtonData(
                      text: 'fulfill the dream'.toUpperCase(),
                      onPressed: () => onFulfillDream?.call()))
              .paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace24,
          kBottomNavigationBarHeight.heightBox,
          // const UnderDevelopment(),
          // ProfileStoriesList(
          //   stories: List.generate(
          //     5,
          //     (index) => const ProfileStory(
          //       image: 'assets/images/png/profile_story_1.png',
          //     ),
          //   ),
          // ),
          // SpacingFoundation.verticalSpace24,
        ],
      )
    ]).paddingSymmetric(
        vertical: (model.positionModel?.verticalMargin ?? 0).toDouble());
  }
}
