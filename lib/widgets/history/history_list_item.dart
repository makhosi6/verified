import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/theme.dart';

class TransactionListItem extends StatelessWidget {
  final num n;
  const TransactionListItem({super.key, required this.n});

  @override
  Widget build(BuildContext context) {
    Widget x;

    if (n == 1) {
      x = _LeadingIcon(
        key: UniqueKey(),
        icon: Icons.credit_card_rounded,
        decoratorIcon: Icons.check,
        decoratorIconBgColor: primaryColor,
        bgColor: darkerPrimaryColor,
      );
    } else if (n == 2) {
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
        isThreeLine: true,
        leading: x,
        title: Text(
          r"$250 top up successfuly added",
          style: GoogleFonts.dmSans(
            fontSize: 16.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          "8:00 AM",
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
            n > 2 ? "Promo" : "Info",
            style: GoogleFonts.dmSans(color: primaryColor),
          ),
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

  const _LeadingIcon({
    super.key,
    required this.icon,
    this.withDecorator = true,
    this.decoratorIcon,
    this.decoratorIconBgColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
