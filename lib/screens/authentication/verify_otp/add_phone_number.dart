import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/common_widgets/common_button.dart';
import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/common_widgets/custom_search.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:country_codes/country_codes.dart';
import 'package:country_picker_pro/country_picker_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPhoneNumber extends StatefulWidget {
  const AddPhoneNumber({super.key, required this.onSubmit});

  final Future<bool> Function(String dialCode, String phoneNumber) onSubmit;

  @override
  State<AddPhoneNumber> createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends BaseStatefulWidgetState<AddPhoneNumber> {
  late CountryDetails? countryCode;
  Country? currentCountry;

  TextEditingController phoneNumberController = TextEditingController();

  getCurrentCountryDetails() {
    try {
      setState(() {
        countryCode = CountryCodes.detailsForLocale(
          Locale.fromSubtags(countryCode: "BD"),
        );

        currentCountry = CountryProvider().findByCode(countryCode?.alpha2Code);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    shouldHaveSafeArea = false;
    resizeToAvoidBottomInset = false;
    getCurrentCountryDetails();
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF000000), Color(0xFF0A0E24), Color(0xFF0C1028)],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor('#B2B8F6').withValues(alpha: 0.2),
                ),
                color: HexColor('#111827').withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              goBack();
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.grey.shade300,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    heightBox(8),
                    TextWidget(
                      text: "Add Phone Number",
                      color: HexColor('#BA87FC'),
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      textAlign: TextAlign.center,
                    ),
                    heightBox(12),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Container(height: 0.8, color: HexColor('#313535')),
                    ),
                    heightBox(20),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: TextWidget(
                        text: "Enter your phone number to continue",
                        color: HexColor('#94A3B8'),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    heightBox(16),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: "Phone Number",
                            color: HexColor('#D1D5DB'),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            textAlign: TextAlign.center,
                          ),
                          heightBox(8),
                          CustomSearch(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            autoFocus: true,
                            controller: phoneNumberController,
                            height: 45,
                            verticalContentPadding: 17,
                            hint: "Phone Number",
                            prefix: Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                top: 4,
                              ),
                              child: InkWell(
                                // onTap: () async {
                                //   Country? countryCode2 = await selectCountry(
                                //     currentCountry?.countryCode ?? "",
                                //     context,
                                //     HexColor('#111827'),
                                //   );
                                //   setState(() {
                                //     currentCountry = countryCode2;
                                //   });
                                // },
                                child: Container(
                                  width: 48,
                                  // height: 75,
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      // borderRadius: BorderRadius.only(
                                      //   topLeft: Radius.circular(8),
                                      //   bottomLeft: Radius.circular(8),
                                      // ),
                                      ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 0.0,
                                      left: 10.0,
                                    ),
                                    child: Row(
                                      children: [
                                        TextWidget(
                                          text: currentCountry?.flagEmojiText ??
                                              "",
                                          fontSize: 20.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.center,
                                        ),
                                        // SizedBox(width: 3),
                                        // Image.asset(
                                        //   PNGImages.dropDownImage,
                                        //   width: 10,
                                        //   height: 6,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            textInputType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    heightBox(24),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: CommonButton(
                        borderRadius: 6,
                        fontSize: 14,
                        text: "Add Phone Number",
                        height: 44,
                        showLoading: isLoading,
                        onTap: () async {
                          if (currentCountry?.callingCode == null) {
                            showError(
                              message: "Please select valid country code",
                            );
                            return;
                          }

                          if (phoneNumberController.text.isEmpty) {
                            showError(
                              message: "Please enter valid phone number",
                            );
                            return;
                          }

                          if (phoneNumberController.text.length < 10) {
                            showError(
                              message: "Please enter valid phone number",
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final result = await widget.onSubmit(
                              (countryCode?.dialCode ?? "").replaceFirst(
                                "+",
                                "",
                              ),
                              phoneNumberController.text,
                            );
                            if (result) {
                              Navigator.pop(context, result);
                            }
                          } catch (e) {}

                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ),
                    heightBox(16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
