import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_flutter/helper/utility.dart';

Widget customTitleText(String? title,
    {BuildContext? context, TextStyle? style}) {
  return Text(
    title ?? '',
    style: style ??
        const TextStyle(
          color: Colors.black87,
          fontFamily: 'HelveticaNeue',
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
  );
}

double fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget customIcon(
  BuildContext context, {
  required IconData icon,
  bool isEnable = false,
  double size = 18,
  bool isTwitterIcon = true,
  bool isFontAwesomeSolid = false,
  Color? iconColor,
  double paddingIcon = 10,
}) {
  iconColor = iconColor ?? Theme.of(context).textTheme.caption!.color;
  return Padding(
    padding: EdgeInsets.only(bottom: isTwitterIcon ? paddingIcon : 0),
    child: Icon(
      icon,
      size: size,
      color: isEnable ? Theme.of(context).primaryColor : iconColor,
    ),
  );
}

Widget customInkWell({
  Widget? child,
  BuildContext? context,
  Function(bool, int)? function1,
  Function? function2,
  bool isEnable = false,
  int no = 0,
  Color color = Colors.transparent,
  Color? splashColor,
  BorderRadius? radius,
}) {
  splashColor = splashColor ?? Theme.of(context!).primaryColorLight;
  radius = radius ?? BorderRadius.circular(0);

  return Material(
    color: color,
    child: InkWell(
      borderRadius: radius,
      onTap: () {
        if (function1 != null) {
          function1(isEnable, no);
        } else if (function2 != null) {
          function2();
        }
      },
      splashColor: splashColor,
      child: child,
    ),
  );
}

Widget customText(String? msg,
    {TextStyle? style,
    TextAlign textAlign = TextAlign.justify,
    overflow = TextOverflow.visible,
    BuildContext? context,
    bool softwrap = true}) {
  if (msg == null) {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  } else {
    if (context != null && style != null) {
      final fullWidth = MediaQuery.of(context).size.width;
      style = style.copyWith(
          fontSize: style.fontSize! - (fullWidth <= 375 ? 2 : 0));
    }
    return Text(
      msg,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softwrap,
    );
  }
}

Widget loader() {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    ),
  );
}

Widget customNetworkImage(String path, {BoxFit fit = BoxFit.contain}) {
  return Image(image: NetworkImage(path), fit: fit);
}

Widget customImage(
  BuildContext context,
  String path, {
  double height = 50,
  bool isBorder = false,
}) {
  return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: Colors.grey.shade100, width: isBorder ? 2 : 0),
      ),
      child: CircleAvatar(
        maxRadius: height / 2,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage: NetworkImage(path),
      ));
}

void openImagePicker(BuildContext context, Function onImageSelected) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                'Pick an image',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'Use camera',
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      onPressed: () {
                        _getImage(ImageSource.camera, onImageSelected);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'Open galaxy',
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      onPressed: () {
                        _getImage(ImageSource.gallery, onImageSelected);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

void _getImage(ImageSource source, Function onImageSelected) async {
  ImagePicker imagePicker = ImagePicker();
  try {
    XFile? file = await imagePicker.pickImage(source: source, imageQuality: 50);
    onImageSelected(file);
  } catch (e) {
    Utility.cprint(e.toString());
  }
}

Widget customListTile(BuildContext context,
    {Widget? title,
    Widget? subtitle,
    Widget? leading,
    Widget? trailing,
    Function? onTap}) {
  return customInkWell(
      context: context,
      function2: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: leading,
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: title ?? Container()),
                        trailing ?? Container(),
                      ],
                    ),
                    subtitle!
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )));
}
