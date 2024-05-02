import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:ophd/models/social_link.dart';
import 'package:ophd/utils/screen_utils.dart';

class LaunchableIconButton extends StatelessWidget {
  final dynamic icon;
  final String url;
  final String tooltip;
  final double iconSize;
  final bool isFile;

  const LaunchableIconButton({
    Key? key,
    required this.icon,
    required this.url,
    required this.tooltip,
    this.iconSize = 24,
    this.isFile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon is IconData
          ? Icon(icon, size: iconSize)
          : ClipRRect(
              borderRadius: BorderRadius.circular(iconSize / 2),
              child: Image(image: icon, width: iconSize, height: iconSize)),
      onPressed: () => isFile ? OpenAppFile.open(url) : launchURL(url),
      tooltip: AppLocalizations.of(context)!.label(tooltip),
    );
  }
}

class LaunchableSocialButton extends StatelessWidget {
  final SocialLink social;
  final double iconSize;

  const LaunchableSocialButton({
    Key? key,
    required this.social,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LaunchableIconButton(
      icon: social.icon,
      url: social.url,
      tooltip: social.label,
      iconSize: iconSize,
      isFile: social.isFile,
    );
  }
}
