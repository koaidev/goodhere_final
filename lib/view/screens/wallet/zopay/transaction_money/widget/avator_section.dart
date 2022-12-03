import 'package:flutter/material.dart';

import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';

class AvatarSection extends StatefulWidget {
  final String image;

  const AvatarSection({Key key, @required this.image}) : super(key: key);

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: Dimensions.RADIUS_SIZE_OVER_LARGE,
              height: Dimensions.RADIUS_SIZE_OVER_LARGE,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.RADIUS_SIZE_VERY_SMALL)),
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  image: Images.avatar,
                  placeholder: Images.avatar,
                  imageErrorBuilder: (context, url, error) => Image.asset(
                    Images.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
                duration: const Duration(seconds: 1),
                alignment: Alignment.centerLeft,
                width: 60.0,
                child: Image.asset(
                  Images.slide_right_icon,
                  height: 10,
                  width: 10,
                  color: ColorResources.getPrimaryTextColor(),
                )),
            // CircleAvatar(backgroundColor: Theme.of(context).secondaryHeaderColor,child: Text('R'),)
            SizedBox(
              width: Dimensions.RADIUS_SIZE_OVER_LARGE,
              height: Dimensions.RADIUS_SIZE_OVER_LARGE,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.RADIUS_SIZE_VERY_SMALL)),
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  image: widget.image,
                  placeholder: Images.avatar,
                  imageErrorBuilder: (context, url, error) => Image.asset(
                    Images.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 28.0 / 1.7,
        ),
      ],
    );
  }
}

void paint(Canvas canvas, Size size) {
  var paint = Paint();

  paint.color = Colors.lightBlue;
  paint.style = PaintingStyle.stroke;
  paint.strokeWidth = 3;

  var startPoint = Offset(0, size.height / 2);
  var controlPoint1 = Offset(size.width / 4, size.height / 3);
  var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
  var endPoint = Offset(size.width, size.height / 2);

  var path = Path();
  path.moveTo(startPoint.dx, startPoint.dy);
  path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
      controlPoint2.dy, endPoint.dx, endPoint.dy);

  canvas.drawPath(path, paint);
}