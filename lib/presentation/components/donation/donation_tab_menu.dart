// ignore_for_file: prefer-single-widget-per-file

part of 'donation_component.dart';

class _DonationTabMenu extends StatefulWidget {
  const _DonationTabMenu({
    required this.onNextButtonTap,
    required this.topDayUsers,
    required this.topMonthUsers,
    required this.topYearUsers,
  });

  final VoidCallback? onNextButtonTap;

  final List<UiDonationUserModel> topDayUsers;
  final List<UiDonationUserModel> topMonthUsers;
  final List<UiDonationUserModel> topYearUsers;

  @override
  State<_DonationTabMenu> createState() => _DonationTabMenuState();
}

class _DonationTabMenuState extends State<_DonationTabMenu> {
  final PageController _pageController = PageController();
  Duration pageDuration = const Duration(milliseconds: 300);

  void _jumpToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: pageDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = AutoSizeGroup();

    return Column(
      children: [
        UiKitCustomTabBar(
          tabs: [
            UiKitCustomTab(
              title: 'DAY',
              height: 24.h,
              group: group,
            ),
            UiKitCustomTab(
              title: 'MONTH',
              height: 24.h,
              group: group,
            ),
            UiKitCustomTab(
              title: 'YEAR',
              height: 24.h,
              group: group,
            ),
          ],
          onTappedTab: (page) => _jumpToPage(page),
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        SpacingFoundation.verticalSpace16,
        ConstrainedBox(
          constraints: BoxConstraints.expand(height: 550.h),
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              _UserListView(users: widget.topDayUsers),
              _UserListView(users: widget.topMonthUsers),
              _UserListView(users: widget.topYearUsers),
            ],
          ),
        ),
        SpacingFoundation.verticalSpace16,
        ConstrainedBox(
          constraints: BoxConstraints.expand(height: 40.h),
          child: OrdinaryButtonWithIcon(
            onPressed: () => widget.onNextButtonTap?.call(),
            icon: const Icon(CupertinoIcons.chevron_down),
            text: 'NEXT 7 PEOPLE',
          ),
        ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      ],
    );
  }
}

class _UserListView extends StatelessWidget {
  const _UserListView({required this.users});

  final List<UiDonationUserModel> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: users.length,
      itemBuilder: (_, index) {
        final user = users[index];

        return UiKitDonationCard(
          number: user.position,
          title: user.nikcname,
          subtitle: '${user.name} ${user.surname}',
          points: index < 3 ? '${user.sum}00' : null,
          sum: user.sum.toString(),
          isStarEnabled: user.isStarEnabled,
        );
      },
      separatorBuilder: (_, __) => SpacingFoundation.verticalSpace24,
    );
  }
}
