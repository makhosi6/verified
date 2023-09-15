// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verify_sa/presentation/theme.dart';

class TransactionListItem extends StatelessWidget {
  final num n;
  final bool isThreeLine;
  const TransactionListItem(
      {super.key, required this.n, this.isThreeLine = false});

  @override
  Widget build(BuildContext context) {
    Widget x;

    if ((n as int).isEven) {
      x = _LeadingIcon(
        key: UniqueKey(),
        icon: Icons.credit_card_rounded,
        decoratorIcon: Icons.check,
        decoratorIconBgColor: primaryColor,
        bgColor: darkerPrimaryColor,
      );
    } else if ((n as int).isOdd) {
      x = _LeadingIcon(
        key: UniqueKey(),
        icon: Icons.south_america_outlined,
        withDecorator: false,
        decoratorIcon: Icons.check,
        bgColor: neutralYellow,
        decoratorIconBgColor: null,
      );
    } else {
      x = _LeadingIcon(
        key: UniqueKey(),
        icon: Icons.today_rounded,
        decoratorIcon: Icons.check,
        withDecorator: false,
        decoratorIconBgColor: primaryColor,
        bgColor: primaryColor,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        isThreeLine: isThreeLine,
        leading: x,
        title: Text(
          "R${Random().nextInt(300) + 100} top up successfully added",
          style: GoogleFonts.dmSans(
            fontSize: 16.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          "$n:00 AM",
          style: GoogleFonts.dmSans(
              fontSize: 12.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: neutralDarkGrey),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 0.5),
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            n.toInt().isEven ? "Promo" : "Info",
            style: GoogleFonts.dmSans(color: primaryColor),
          ),
        ),
      ),
    );
  }
}

enum BannerType { promotion, warning, notification, defualt }

class ConfidenceBanner extends StatelessWidget {
  final Color? bgColor;
  final Color? leadingBgColor;

  const ConfidenceBanner({
    Key? key,
    this.bgColor,
    this.leadingBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.white70, width: 2.5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 12.0,
            right: 12.0,
          ),
          isThreeLine: true,
          leading: Baseline(
            baselineType: TextBaseline.alphabetic,
            baseline: 65,
            child: Container(
              clipBehavior: Clip.none,
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 4.0),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_drop_up_outlined,
                  color: Colors.white70,
                  size: 48.0,
                ),
              ),
            ),
          ),
          title: Text(
            r"54%",
            style: GoogleFonts.ibmPlexSans(
              fontSize: 28.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
          subtitle: Text(
            "High confidence level. The data is backed by the DHA.",
            style: GoogleFonts.dmSans(
              fontSize: 14.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}

class ListItemBanner extends StatelessWidget {
  final BannerType? type;
  final Color? bgColor;
  final IconData? leadingIcon;
  final Color? leadingBgColor;

  const ListItemBanner({
    super.key,
    this.type = BannerType.defualt,
    this.bgColor,
    this.leadingIcon,
    this.leadingBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgColor ?? primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          top: 8.0,
          left: 12.0,
          right: 12.0,
        ),
        isThreeLine: true,
        leading: _LeadingIcon(
          icon: leadingIcon ?? Icons.discount,
          bgColor: leadingBgColor ?? primaryColor,
          discountIndictor: true,
        ),
        title: Text(
          r"$250 top up successfuly added",
          style: GoogleFonts.dmSans(
            fontSize: 16.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type == BannerType.defualt)
              Text(
                "8:00 AM",
                style: GoogleFonts.dmSans(
                  fontSize: 12.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  color: neutralDarkGrey,
                ),
              ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    "Top up now",
                    style: GoogleFonts.dmSans(
                        color: leadingBgColor ?? primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: leadingBgColor ?? primaryColor,
                      size: 14.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final IconData icon;
  final bool withDecorator;
  final Color? decoratorIconBgColor;
  final Color bgColor;
  final IconData? decoratorIcon;
  final bool discountIndictor;

  const _LeadingIcon({
    super.key,
    required this.icon,
    this.withDecorator = true,
    this.decoratorIcon,
    this.decoratorIconBgColor,
    required this.bgColor,
    this.discountIndictor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          clipBehavior: Clip.none,
          width: 68.0,
          height: 68.0,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Stack(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 38.0,
                ),
                if (withDecorator)
                  Positioned(
                    right: -0.0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: decoratorIconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        decoratorIcon,
                        color: Colors.white,
                        size: 12.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (discountIndictor == true)
          Positioned(
            top: -3.0,
            right: -3.0,
            child: Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(
                    color: const Color.fromRGBO(232, 245, 233, 1), width: 3.0),
                color: neutralYellow,
              ),
            ),
          ),
      ],
    );
  }
}
