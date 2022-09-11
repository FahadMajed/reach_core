import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class ReachScaffold extends StatelessWidget {
  final String? title;
  final AppBar? customAppBar;

  ///takes a list of possible asyncs calls
  final List<RxBool>? loadingController;
  final CrossAxisAlignment alignment;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final BottomButton? button;
  final List<Widget> body;
  final bool isScrollable;
  final String h4;
  final String h5;
  final String h6;
  final bool hasDivider;
  final Widget? beforeBody;
  final GlobalKey<FormState>? formKey;
  final bool withWhiteContainer;
  final List<Widget> innerChildren;
  final String imageFile;

  final bool withAppBar;
  final bool withSafeArea;
  final bool resizeToAvoidBottomInset;
  final MainAxisAlignment mainAxisAlignment;

  ReachScaffold({
    Key? key,
    this.title,
    this.customAppBar,
    this.loadingController,
    this.imageFile = "",
    this.alignment = CrossAxisAlignment.start,
    this.outerPadding = padding8,
    this.innerPadding = padding8,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.button,
    required this.body,
    this.isScrollable = false,
    this.h4 = "",
    this.h5 = "",
    this.h6 = "",
    this.hasDivider = true,
    this.withWhiteContainer = true,
    this.formKey,
    this.beforeBody,
    this.innerChildren = const [],
    this.withAppBar = true,
    this.withSafeArea = false,
    this.resizeToAvoidBottomInset = false,
  }) : super(key: key);

  final bodyFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    try {
      final observable = false.obs;
      if (loadingController != null) observable.value = true;
      return observable.value
          ? Obx(
              () => buildScaffold(context),
            )
          : buildScaffold(context);
    } catch (e) {
      return const Scaffold();
    }
  }

  ModalProgressHUD buildScaffold(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loadingController != null ? getLoadingState() : false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(bodyFocusNode),
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: withAppBar
              ? (customAppBar ??
                  AppBar(
                    title: Text(
                      title?.tr ?? "reach".tr,
                    ),
                  ))
              : null,
          body: Form(
            key: formKey,
            child: withSafeArea && button == null
                ? SafeArea(child: buildBody())
                : buildBody(),
          ),
          bottomNavigationBar:
              resizeToAvoidBottomInset == false ? button : null,
        ),
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        if (imageFile.isNotEmpty)
          Positioned.fill(
            child: Image.asset(
              "assets/images/$imageFile",
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomLeft,
            ),
          ),
        isScrollable
            ? LayoutSingleChild(
                [
                  if (beforeBody != null) beforeBody!,
                  container(),
                  expandedContainer,
                  if (resizeToAvoidBottomInset && button != null) button!
                ],
              )
            : Column(
                mainAxisAlignment: mainAxisAlignment,
                children: [if (beforeBody != null) beforeBody!, container()],
              ),
      ],
    );
  }

  Widget container() {
    if (withWhiteContainer) {
      return WhiteContainer(
        body: [
          if (h6.isNotEmpty)
            Heading(
              h4: h4,
              h5: h5,
              h6: h6,
              hasDivider: hasDivider,
            ),
          ...body,
          if (innerChildren.isNotEmpty) DarkBlueContainer(innerChildren),
        ],
        alignment: alignment,
        outerPadding: outerPadding,
        innerPadding: innerPadding,
      );
    } else {
      return Padding(
        padding: outerPadding,
        child: Container(
          height: 88.h,
          padding: innerPadding,
          child: isScrollable
              ? SingleChildScrollView(
                  child: column(),
                )
              : column(),
        ),
      );
    }
  }

  Column column() {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (h6.isNotEmpty)
          Heading(
            h4: h4,
            h5: h5,
            h6: h6,
            hasDivider: hasDivider,
          ),
        ...body,
        if (innerChildren.isNotEmpty) DarkBlueContainer(innerChildren),
      ],
    );
  }

  bool getLoadingState() {
    for (final loadingState in loadingController ?? []) {
      if (loadingState.value == true) return true;
    }
    return false;
  }
}
