import 'package:awesome_snackbar_content/src/assets_path.dart';
import 'package:awesome_snackbar_content/src/content_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class AwesomeSnackbarContent extends StatelessWidget {
  final String title;
  final String message;
  final Color? color;
  final ContentType contentType;
  final bool inMaterialBanner;
  final TextStyle? titleTextStyle;
  final TextStyle? messageTextStyle;

  const AwesomeSnackbarContent({
    Key? key,
    this.color,
    this.titleTextStyle,
    this.messageTextStyle,
    required this.title,
    required this.message,
    required this.contentType,
    this.inMaterialBanner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final size = MediaQuery.of(context).size;

    // screen dimensions
    bool isMobile = size.width <= 768;
    bool isTablet = size.width > 768 && size.width <= 992;

    /// for reflecting different color shades in the SnackBar
    final hsl = HSLColor.fromColor(color ?? contentType.color!);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    double horizontalPadding = 0.0;
    double leftSpace = size.width * 0.14;
    double rightSpace = size.width * 0.12;

    if (isMobile) {
      horizontalPadding = size.width * 0.01;
    } else if (isTablet) {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.2;
    } else {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.3;
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          /// Background container
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: color ?? contentType.color,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.fromLTRB(
              isRTL ? size.width * 0.03 : leftSpace, // Left padding
              0.0, // Top padding
              isRTL ? rightSpace : size.width * 0.04, // Right padding
              0.0, // Bottom padding
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Adjust dynamically based on content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),

                /// Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: titleTextStyle ??
                            TextStyle(
                              fontSize: (!isMobile
                                  ? size.height * 0.03
                                  : size.height * 0.025),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (inMaterialBanner) {
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
                          return;
                        }
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: size.height * 0.022,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),

                /// Message
                Text(
                  message,
                  style: messageTextStyle ??
                      TextStyle(
                        fontSize: size.height * 0.016,
                        color: Colors.white,
                      ),
                  maxLines: null, // Allow unlimited lines
                  overflow: TextOverflow.visible, // Show all content
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
              ],
            ),
          ),

          /// Splash SVG asset
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
              child: SvgPicture.asset(
                AssetsPath.bubbles,
                height: size.height * 0.06,
                width: size.width * 0.05,
                colorFilter:
                    _getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                package: 'awesome_snackbar_content',
              ),
            ),
          ),

          /// Bubble Icon
          Positioned(
            top: -size.height * 0.015,
            left: !isRTL
                ? leftSpace -
                    8 -
                    (isMobile ? size.width * 0.075 : size.width * 0.035)
                : null,
            right: isRTL
                ? rightSpace -
                    8 -
                    (isMobile ? size.width * 0.075 : size.width * 0.035)
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  AssetsPath.back,
                  height: size.height * 0.06,
                  colorFilter:
                      _getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                  package: 'awesome_snackbar_content',
                ),
                Positioned(
                  top: size.height * 0.015,
                  child: SvgPicture.asset(
                    assetSVG(contentType),
                    height: size.height * 0.022,
                    package: 'awesome_snackbar_content',
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reflecting proper icon based on the contentType
  String assetSVG(ContentType contentType) {
    switch (contentType) {
      case ContentType.failure:
        return AssetsPath.failure;
      case ContentType.success:
        return AssetsPath.success;
      case ContentType.warning:
        return AssetsPath.warning;
      case ContentType.help:
        return AssetsPath.help;
      default:
        return AssetsPath.failure;
    }
  }

  static ColorFilter? _getColorFilter(
          ui.Color? color, ui.BlendMode colorBlendMode) =>
      color == null ? null : ui.ColorFilter.mode(color, colorBlendMode);
}
