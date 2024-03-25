// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/helpers/currency.dart';

import 'package:verified/presentation/theme.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionHistory data;
  final bool isThreeLine;
  const TransactionListItem({super.key, required this.data, this.isThreeLine = false});

  @override
  Widget build(BuildContext context) {
    Widget leading;
    final type = data.type, subtype = data.subtype;
    final isType2 = ((data.details?.query?.length) ?? 0) > 10;

    if (type == 'credit' || subtype == 'credit') {
      leading = topUpLeadingIcon;
    } else if (type == 'promo' || subtype == 'promo') {
      leading = freeCreditIcon;
    } else if (type == 'refund' || subtype == 'refund') {
      leading = refundIcon;
    } else if ((type == 'debit' || subtype == 'debit') || (type == 'spend' || subtype == 'spend')) {
      leading = spendLeadingIcon;
    } else {
      leading = leadingIcon;
    }

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          isThreeLine: isThreeLine,
          leading: leading,
          title: Text(
            '${data.description}',
            style: GoogleFonts.dmSans(
              fontSize: 16.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          subtitle: Wrap(
            alignment: WrapAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 12.0,
                ),
                child: Text(
                  formatCurrency(data.amount ?? 0, 'ZAR'),
                  style: GoogleFonts.dmSans(
                    fontSize: 12.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: neutralDarkGrey,
                  ),
                ),
              ),
              (data.details?.query != null)
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 12.0,
                      ),
                      child: Text(
                        data.details?.query ?? '',
                        style: GoogleFonts.dmSans(
                          fontSize: 12.0,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: neutralDarkGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const SizedBox.shrink(),
              Text(
                DateFormat.jm().format(
                    DateTime.fromMillisecondsSinceEpoch(((data.timestamp ?? data.createdAt ?? 0) as int) * 1000)),
                style: GoogleFonts.dmSans(
                  fontSize: 12.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  color: neutralDarkGrey,
                ),
              ),
            ],
          ),
          // trailing: (type == 'promo' || type == 'topup') || (subtype == 'promo' || subtype == 'topup')
          trailing: (type == 'promo') || (subtype == 'promo')
              ? Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 0.5),
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    (type == 'promo' || subtype == 'promo')
                        ? 'Promo'
                        : 'Info', // ((type == 'topup' || subtype == 'topup') ? 'Refund' : 'Info'),
                    style: GoogleFonts.dmSans(color: primaryColor),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

var freeCreditIcon = _LeadingIcon(
  key: UniqueKey(),
  discountIndictor: true,
  icon: Icons.card_giftcard,
  decoratorIcon: Icons.add,
  withDecorator: false,
  decoratorIconBgColor: primaryColor,
  bgColor: darkerPrimaryColor,
);

// var spendIcon2 = _LeadingIcon(
//   key: UniqueKey(),
//   discountIndictor: false,
//   icon: Icons.credit_card,
//   decoratorIcon: Icons.remove,
//   decoratorIconBgColor: neutralYellow,
//   bgColor: darkerPrimaryColor,
// );

var refundIcon = _LeadingIcon(
  key: UniqueKey(),
  discountIndictor: false,
  icon: Icons.credit_card_rounded,
  decoratorIcon: Icons.add,
  withDecorator: true,
  decoratorIconBgColor: primaryColor,
  bgColor: darkerPrimaryColor,
);
var topUpLeadingIcon = _LeadingIcon(
  key: UniqueKey(),
  icon: Icons.add_card_rounded,
  decoratorIcon: Icons.check,
  decoratorIconBgColor: primaryColor,
  bgColor: darkerPrimaryColor,
);

var spendLeadingIcon = _LeadingIcon(
  key: UniqueKey(),
  discountIndictor: false,
  icon: Icons.confirmation_num_rounded,
  decoratorIcon: Icons.remove,
  decoratorIconBgColor: neutralYellow,
  bgColor: primaryColor,
);

var leadingIcon = _LeadingIcon(
  key: UniqueKey(),
  icon: Icons.add_card_rounded,
  decoratorIcon: Icons.minimize,
  withDecorator: false,
  decoratorIconBgColor: neutralYellow,
  bgColor: neutralYellow,
);

enum BannerType { promotion, warning, notification, defualt, learn_more }

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
            r'100%',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 28.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
          subtitle: Text(
            'High confidence level. The data is backed by the DHA.',
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
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final String buttonText;

  const ListItemBanner({
    super.key,
    this.type = BannerType.defualt,
    required this.title,
    required this.subtitle,
    this.buttonText = 'Top up now',
    this.bgColor,
    this.leadingIcon,
    this.leadingBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 12.0,
          right: 12.0,
        ),
        // isThreeLine: true,
        leading: _LeadingIcon(
          icon: leadingIcon ?? Icons.discount_outlined,
          bgColor: leadingBgColor ?? primaryColor,
          discountIndictor: true,
        ),
        title: Text(
          title,
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
                subtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 12.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  color: neutralDarkGrey,
                ),
              ),
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    buttonText,
                    style: GoogleFonts.dmSans(color: leadingBgColor ?? primaryColor),
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
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: decoratorIconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        decoratorIcon,
                        color: Colors.white,
                        size: 14.0,
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
                border: Border.all(color: const Color.fromRGBO(232, 245, 233, 1), width: 3.0),
                color: neutralYellow,
              ),
            ),
          ),
      ],
    );
  }
}
