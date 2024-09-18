import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/services_options_enum.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/confirm_details_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class SelectServicesPage extends StatefulWidget {
  const SelectServicesPage({super.key});

  @override
  State<SelectServicesPage> createState() => _SelectServicesPageState();
}

class _SelectServicesPageState extends State<SelectServicesPage> {
  Map<String, bool> selectedValues = {};

  ///
  var options = ServiceOptionsEnum.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const AppErrorWarningIndicator(),
            SliverAppBar(
              stretch: true,
              onStretchTrigger: () async {},
              surfaceTintColor: Colors.transparent,
              stretchTriggerOffset: 300.0,
              expandedHeight: 90.0,
              flexibleSpace: AppBar(
                automaticallyImplyLeading: true,
                title: const Text('Verify'),
              ),
              leadingWidth: 80.0,
              leading: VerifiedBackButton(
                key: const Key('captured-details-page-back-btn'),
                onTap: () => Navigator.pop(context),
                isLight: true,
              ),
              actions: const [],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => UnconstrainedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                    constraints: appConstraints,
                    padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: primaryPadding.bottom),
                          child: Text(
                            'Please type a phone/id number and click send to verify. Ensure accuracy and trust in your data effortlessly. ',
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
                        ...options.map(
                          (name) {
                            String key = name.toJson();

                            return Padding(
                              padding: EdgeInsets.only(bottom: primaryPadding.bottom),
                              child: ListViewAsSwitch(
                                name: name.toString(),
                                value: name == ServiceOptionsEnum.identity_verification
                                    ? true
                                    : (selectedValues[key] ?? false),
                                color: name == ServiceOptionsEnum.identity_verification
                                    ? const Color.fromARGB(255, 183, 227, 206)
                                    : null,
                                didChange: (value) {
                                  setState(() {
                                    if (key == 'all') {
                                      for (var i = 0; i < options.length; i++) {
                                        var optName = options[i];
                                        selectedValues.addAll({optName.toJson(): value});
                                      }
                                    } else {
                                      selectedValues.addAll({key: value});

                                      if (value == false) {
                                        selectedValues.addAll({'all': value});
                                      }
                                    }
                                  });

                                  /// filter out false values
                                  List<String> selectedServicesOrJobs = selectedValues.entries
                                      .where((element) => element.value)
                                      .map((item) => item.key)
                                      .toList()

                                    /// and add the default value(s)
                                    ..add(ServiceOptionsEnum.identity_verification.toJson());

                                    

                                  ///
                                  context.read<StoreBloc>().add(
                                        StoreEvent.selectJobsOrService(
                                          selectedServicesOrJobs

                                              /// make it a unique list
                                              .toSet()
                                              .toList(),
                                        ),
                                      );
                                },
                              ),
                            );
                          },
                        ),

                        ///
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: BaseButton(
                            key: UniqueKey(),
                            onTap: () => navigate(context, page: ConfirmDetailsPage()),
                            label: 'Next',
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
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewAsSwitch extends StatelessWidget {
  final String name;
  final bool value;
  final Color? color;
  final Widget? leading;
  final Function(bool) didChange;
  const ListViewAsSwitch({
    super.key,
    required this.name,
    required this.value,
    this.color,
    this.leading,
    required this.didChange,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: leading,
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Switch.adaptive(
            value: value,
            onChanged: didChange,
            activeColor: color,
            activeTrackColor: Colors.black,
            thumbColor: color != null ? MaterialStateProperty.resolveWith<Color>((_) => color ?? primaryColor) : null,
          ),
        ),
      );
}
