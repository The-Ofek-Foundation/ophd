import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/utils/screen_utils.dart';

class LaunchableIconButton extends StatelessWidget {
  final dynamic icon;
  final String url;
  final String tooltip;
  final double iconSize;
  final String? fileType;

  const LaunchableIconButton({
    super.key,
    required this.icon,
    required this.url,
    required this.tooltip,
    this.iconSize = 24,
    this.fileType,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(icon, size: iconSize);
    } else if (icon is SvgPicture) {
      iconWidget = SizedBox(
        width: iconSize,
        height: iconSize,
        child: icon,
      );
    } else {
      iconWidget = ClipRRect(
        borderRadius: BorderRadius.circular(iconSize / 2),
        child: Image(image: icon, width: iconSize, height: iconSize),
      );
    }

    return IconButton(
      icon: iconWidget,
      onPressed: () => fileType != null ? launchAssetInNewTab(url, fileType!) : launchURL(url),
      tooltip: AppLocalizations.of(context)!.label(tooltip),
    );
  }
}

class LaunchableSocialButton extends StatelessWidget {
  final SocialLink social;
  final double iconSize;

  const LaunchableSocialButton({
    super.key,
    required this.social,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return LaunchableIconButton(
      icon: social.icon,
      url: social.url,
      tooltip: social.label,
      iconSize: iconSize,
      fileType: social.fileType,
    );
  }
}
