import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:hand_signature/signature.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/utils/widget_generator_options.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';
import 'package:verified/presentation/widgets/popups/default_popup.dart';

class PermitFormPage extends StatefulWidget {
  PermitFormPage({super.key});

  @override
  State<PermitFormPage> createState() => _PermitFormPageState();
}

class _PermitFormPageState extends State<PermitFormPage> {
  ///
  final _globalKeyPermitFormPageForm = GlobalKey<FormState>(debugLabel: 'permit-form-page-key');

  ///
  final keyboardType = TextInputType.number;

  ///
  late String? selectedPreferredCommunicationChannel = preferredCommunicationChannel.first;

  final List<String> preferredCommunicationChannel =
      List.unmodifiable(['In-App Notification', 'SMS', 'Email', 'Whatsapp']);

  ///
  ///
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  ///
  @override
  Widget build(BuildContext context) {
    ///
    var borderColor = ThemeData(brightness: Brightness.light).textTheme.displayLarge?.color ?? Colors.black87;

    ///
    return WillPopScope(
      onWillPop: () async {
        bool canCancel = await showDefaultPopUp(
          context,
          title: 'Are You Sure You Want to Cancel?',
          subtitle:
              "It looks like you're about to leave the account creation process. If you wish to cancel, press yes",
          confirmBtnText: 'Yes',
          declineBtnText: 'No',
          onConfirm: () => Navigator.pop(context, true),
          onDecline: () => Navigator.pop(context, false),
        );

        return canCancel;
      },
      child: Scaffold(
        body: Center(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppErrorWarningIndicator(),
              SliverAppBar(
                stretch: true,
                centerTitle: false,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                  title: const Text('Create an Account'),
                ),
                leadingWidth: 80.0,
                leading: const SizedBox.shrink(),
                actions: const [],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => UnconstrainedBox(
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                        constraints: appConstraints,
                        padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                              child: Text(
                                'Instantly confirm the legitimacy of personal information with our user-friendly app.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: neutralDarkGrey,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                              width: 40,
                            ),
                        
                            ///
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select preferred communication method',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: borderColor,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(width: 2, color: primaryColor),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: errorColor,
                                            ),
                                          )),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedPreferredCommunicationChannel,
                                          // hint: const Text('Select preferred communication method'),
                                          isExpanded: true,
                                          isDense: true,
                                          items: preferredCommunicationChannel
                                              .map((String value) => DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value),
                                                  ))
                                              .toList(),
                                          onChanged: (String? channel) => {
                                            if (mounted)
                                              {
                                                setState(() {
                                                  selectedPreferredCommunicationChannel = channel;
                                                })
                                              }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        
                            ///
                            Container(
                              color: Colors.white,
                              child: HandSignature(
                                control: control,
                                type: SignatureDrawType.shape,
                                // supportedDevices: {
                                //   PointerDeviceKind.stylus,
                                // },
                              ),
                            ),
                        
                            ///
                            CustomPaint(
                              painter: DebugSignaturePainterCP(
                                control: control,
                                cp: false,
                                cpStart: false,
                                cpEnd: false,
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Signature(
                                  color: color,
                                  key: _sign,
                                  onSign: () {
                                    final sign = _sign.currentState;
                                    debugPrint('${sign?.points.length} points in the signature');
                                  },
                                  backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                                  strokeWidth: strokeWidth,
                                ),
                              ),
                              color: Colors.black12,
                            ),
                        
                            ///
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: BaseButton(
                                key: UniqueKey(),
                                onTap: () => {
                                  /// Bloc event
                        
                                  /// then
                                  Navigator.of(context).pop()
                                },
                                label: 'Create an Account',
                                color: neutralGrey,
                                hasIcon: false,
                                bgColor: primaryColor,
                                buttonIcon: Icon(
                                  Icons.lock_outline,
                                  color: primaryColor,
                                ),
                                buttonSize: ButtonSize.large,
                                hasBorderLining: false,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

HandSignatureControl control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);

ValueNotifier<String?> svg = ValueNotifier<String?>(null);

ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8, Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
