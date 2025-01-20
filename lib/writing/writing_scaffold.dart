import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/layout.dart';

class WritingScaffold extends StatelessWidget {
  WritingScaffold({super.key, this.title, this.body});

  final Widget? title;
  final Widget? body;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<NavigationDrawerDestination> destinations = [
    NavigationDrawerDestination(
      icon: Icon(Icons.person_outline),
      label: Text("About me"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.work_outline),
      label: Text("Projects"),
    ),
    NavigationDrawerDestination(
      icon: Icon(Icons.mail_outline),
      label: Text("Contact"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: switch (WindowSize.of(context)) {
        WindowSize.compact || WindowSize.medium => _buildNavigation(context),
        _ => null,
      },
      appBar: _buildAppBar(context),
      body: switch (WindowSize.of(context)) {
        WindowSize.compact || WindowSize.medium => body,
        _ => Row(
            children: [
              _buildNavigation(context),
              if (body != null)
                Expanded(
                  child: Column(
                    children: [
                      AppBar(
                        automaticallyImplyLeading:
                            WindowSize.of(context) == WindowSize.expanded,
                        title: title,
                      ),
                      Expanded(
                        child: body!,
                      ),
                    ],
                  ),
                ),
            ],
          )
      },
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    switch (WindowSize.of(context)) {
      case WindowSize.compact:
      case WindowSize.medium:
        return AppBar(
          title: title,
        );

      default:
        return null;
    }
  }

  Widget _buildNavigation(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (value) {},
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 24, 8, 8),
          child: _buildHomeLogo(context),
        ),
        ...destinations,
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
          child: Divider(),
        ),
      ],
    );
  }

  Widget _buildHomeLogo(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: _LogoInkWell(
        onTap: () {
          scaffoldKey.currentState?.closeDrawer();
          GoRouter.of(context).go("/writing");
        },
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorOffset: Offset(28, 4),
        applyXOffset: true,
        indicatorSize: Size(48, 48),
        child: Row(
          children: [
            Card.outlined(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: SvgPicture.asset(
                  "assets/logo/butterfly.svg",
                  semanticsLabel: "Moments Logo",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Moments",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoInkWell extends InkResponse {
  const _LogoInkWell({
    super.child,
    super.onTap,
    super.customBorder,
    required this.indicatorOffset,
    this.applyXOffset = false,
    required this.indicatorSize,
  }) : super(
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
        );

  /// The offset used to position Ink highlight.
  final Offset indicatorOffset;

  // Whether the horizontal offset from indicatorOffset should be used to position Ink highlight.
  // If true, Ink highlight uses the indicator horizontal offset. If false, Ink highlight is centered horizontally.
  final bool applyXOffset;

  /// The size of the Ink highlight.
  final Size indicatorSize;

  @override
  RectCallback? getRectCallback(RenderBox referenceBox) {
    final double boxWidth = referenceBox.size.width;
    double indicatorHorizontalCenter =
        applyXOffset ? indicatorOffset.dx : boxWidth / 2;

    return () {
      return Rect.fromLTWH(
        indicatorHorizontalCenter - (indicatorSize.width / 2),
        indicatorOffset.dy,
        indicatorSize.width,
        indicatorSize.height,
      );
    };
  }
}
