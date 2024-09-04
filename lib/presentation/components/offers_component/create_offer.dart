import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/offers_component/offer_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreateOffer extends StatefulWidget {
  final OfferUiModel? offerUiModel;
  final ValueChanged<OfferUiModel>? onCreateOffer;
  final int? offerPrice;

  const CreateOffer({
    super.key,
    this.offerUiModel,
    this.onCreateOffer,
    this.offerPrice,
  });

  @override
  State<CreateOffer> createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  late OfferUiModel _offerUiModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime? _isLaunchedDate;
  late final List<DateTime?>? _selectedDates;
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _pointController = TextEditingController();
  late bool _isLaunched;
  late bool _notifyTheAudience;
  late int? _selectedIconIndex;
  final List<String> _iconList = [
    GraphicsFoundation.instance.svg.cocktail3d.path,
    GraphicsFoundation.instance.svg.mango.path,
    GraphicsFoundation.instance.svg.discount.path,
    GraphicsFoundation.instance.svg.lifebuoy3d.path,
    GraphicsFoundation.instance.svg.aubergine.path,
  ];

  @override
  void initState() {
    _offerUiModel = widget.offerUiModel ?? OfferUiModel(id: -1);
    _titleController.text = widget.offerUiModel?.title ?? '';
    _pointController.text = widget.offerUiModel?.pointPrice.toString() ?? '';
    _selectedDates = widget.offerUiModel?.selectedDates ?? [null];
    _isLaunchedDate = widget.offerUiModel?.isLaunchedDate;
    _notifyTheAudience = widget.offerUiModel?.notifyTheAudience ?? false;
    _isLaunched = widget.offerUiModel?.isLaunched ?? true;
    _selectedIconIndex = _iconList.indexWhere((element) => element == (widget.offerUiModel?.iconPath ?? 0));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateOffer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _offerUiModel = widget.offerUiModel ?? OfferUiModel(id: -1);
    _titleController.text = widget.offerUiModel?.title ?? '';
    _pointController.text = widget.offerUiModel?.pointPrice.toString() ?? '';
    _selectedDates?.clear();
    _selectedDates = widget.offerUiModel?.selectedDates ?? [null];
    _isLaunchedDate = widget.offerUiModel?.isLaunchedDate;
    _notifyTheAudience = widget.offerUiModel?.notifyTheAudience ?? false;
    _isLaunched = widget.offerUiModel?.isLaunched ?? true;
    _selectedIconIndex = _iconList.indexWhere((element) => element == (widget.offerUiModel?.iconPath ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlurredAppBarPage(
          title: S.of(context).Offer,
          centerTitle: true,
          autoImplyLeading: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          children: [
            if (widget.offerUiModel != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).Launched,
                      style: theme?.regularTextTheme.labelLarge,
                    ),
                  ),
                  UiKitGradientSwitch(
                    onChanged: (value) {
                      setState(() {
                        _isLaunched = !_isLaunched;
                        _isLaunched != widget.offerUiModel?.isLaunched
                            ? _isLaunchedDate = DateTime.now().toLocal()
                            : _isLaunchedDate = widget.offerUiModel?.isLaunchedDate ?? DateTime.now();
                      });
                    },
                    switchedOn: _isLaunched,
                  ),
                ],
              ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              label: S.of(context).Title,
              maxSymbols: 45,
              controller: _titleController,
              onChanged: (value) {
                setState(() {
                  _formKey.currentState?.validate();
                });
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return S.of(context).PleaseEnterValidTitle;
                }
                if (value != null && value.isNotEmpty) {
                  final newValue = value.replaceAll(' ', '');

                  if (newValue == '') {
                    return S.of(context).PleaseEnterValidTitle;
                  }
                }
                return null;
              },
            ),
            SpacingFoundation.verticalSpace16,
            UiKitInputFieldNoFill(
              label: S.of(context).Points,
              controller: _pointController,
              keyboardType: TextInputType.number,
              inputFormatters: [PriceWithSpacesFormatter(allowDecimal: false)],
            ),
            SpacingFoundation.verticalSpace16,
            Row(
              children: [
                Flexible(
                  child: Text(
                    S.of(context).PersonalizeYourOffer,
                    style: theme?.regularTextTheme.labelSmall,
                  ),
                ),
                SpacingFoundation.horizontalSpace12,
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => showUiKitPopover(
                      context,
                      customMinHeight: 30.h,
                      showButton: false,
                      title: Text(
                        S.of(context).ByDefaultYourOfferWillDisplay,
                        style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: ImageWidget(
                      iconData: ShuffleUiKitIcons.info,
                      width: 20.w,
                      color: theme?.colorScheme.darkNeutral900,
                    ),
                  ),
                ),
              ],
            ),
            SpacingFoundation.verticalSpace4,
            SizedBox(
              height: 45.h,
              child: ListView.separated(
                itemCount: _iconList.length,
                separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace16,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (index != _selectedIconIndex) {
                          _selectedIconIndex = index;
                        } else {
                          _selectedIconIndex = null;
                        }
                      });
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: _selectedIconIndex == index ? GradientFoundation.gradientBorder : null,
                        borderRadius: BorderRadiusFoundation.all24r,
                      ),
                      child: ImageWidget(
                        height: 45.h,
                        fit: BoxFit.fitHeight,
                        link: _iconList[index],
                      ).paddingAll(EdgeInsetsFoundation.all2),
                    ),
                  );
                },
              ),
            ),
            SpacingFoundation.verticalSpace16,
            Text(
              S.of(context).SelectPeriodOfValid,
              style: theme?.regularTextTheme.labelSmall,
            ),
            SpacingFoundation.verticalSpace2,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _selectedDates != null && _selectedDates.first != null
                    ? Expanded(
                        child: Text(
                          '${formatDateWithCustomPattern('dd.MM.yyyy', (_selectedDates.first)!.toLocal())} ${_selectedDates.last != null ? '- ${formatDateWithCustomPattern('dd.MM.yyyy', (_selectedDates.last)!.toLocal())}' : ''} ',
                          style: theme?.boldTextTheme.body,
                        ),
                      )
                    : Expanded(
                        child: Text(
                          S.of(context).PleaseAddDatePeriod,
                          style: theme?.boldTextTheme.body.copyWith(color: ColorsFoundation.error),
                        ),
                      ),
                SpacingFoundation.horizontalSpace12,
                context.outlinedButton(
                  padding: EdgeInsets.all(EdgeInsetsFoundation.all12),
                  data: BaseUiKitButtonData(
                    iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.calendar),
                    onPressed: () async {
                      await showUiKitCalendarFromToDialog(
                        context,
                        (from, to) {
                          setState(() {
                            _selectedDates?.clear();
                            _selectedDates?.add(from);
                            from != to ? _selectedDates?.add(to) : _selectedDates?.add(null);
                          });
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            if (widget.offerUiModel == null) ...[
              SpacingFoundation.verticalSpace24,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).NotifyTheAudience,
                      style: theme?.regularTextTheme.labelSmall,
                    ),
                  ),
                  UiKitGradientSwitch(
                    onChanged: (value) {
                      setState(() {
                        _notifyTheAudience = !_notifyTheAudience;
                      });
                    },
                    switchedOn: _notifyTheAudience,
                  ),
                ],
              ),
              SpacingFoundation.verticalSpace2,
              Text(
                S.of(context).TheOfferWillBeAddedToPersonal,
                style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
              ),
              SpacingFoundation.verticalSpace16,
              UiKitInputFieldNoFill(
                label: S.of(context).Points,
                controller: _pointController,
                keyboardType: TextInputType.number,
                inputFormatters: [PriceWithSpacesFormatter(allowDecimal: false)],
              ),
            ],
            SpacingFoundation.verticalSpace16,
            Text(
              S.of(context).YourOfferWillShown1Time,
              style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
            ),
            if (widget.offerUiModel == null)
              Center(
                child: Text(
                  S.of(context).OfferPrice(widget.offerPrice ?? 0),
                  style: theme?.boldTextTheme.body,
                ),
              ).paddingOnly(top: SpacingFoundation.verticalSpacing16),
            SizedBox(height: SpacingFoundation.verticalSpacing32),
            SafeArea(
              top: false,
              child: context.gradientButton(
                data: BaseUiKitButtonData(
                  text: widget.offerUiModel == null ? S.of(context).SaveAndPay : S.of(context).Save,
                  fit: ButtonFit.fitWidth,
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate() &&
                        _selectedDates != null &&
                        _selectedDates.isNotEmpty) {
                      _offerUiModel = _offerUiModel.copyWith(
                        title: _titleController.text,
                        iconPath: _iconList[
                            (_selectedIconIndex == -1 || _selectedIconIndex == null) ? 0 : _selectedIconIndex!],
                        isLaunched: _isLaunched,
                        notifyTheAudience: _notifyTheAudience,
                        pointPrice:
                            _pointController.text.isEmpty ? 0 : int.parse(_pointController.text.replaceAll(' ', '')),
                        selectedDates: _selectedDates,
                        isLaunchedDate: _isLaunchedDate ?? DateTime.now(),
                      );

                      widget.onCreateOffer?.call(_offerUiModel);
                    }
                  },
                ),
              ),
            ),
            SpacingFoundation.verticalSpace24,
          ],
        ),
      ),
    );
  }
}
