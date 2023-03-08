import 'package:country_picker/country_picker.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_selector/repositories/location_repository.dart';
import 'package:number_selector/style.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  String _countryCode = '';
  String _phoneCode = '';

  final int maxLength = 14;
  bool isFull = false;
  TextEditingController controller = TextEditingController();
  LocationRepository repository = LocationRepository();

  void _loadCountryInfo() async {
    var countryCode = await repository.getCountryCode();
    var countryName = await repository.getCountryName();
    var phoneCode = await repository.getNumberCode(countryName);
    setState(() {
      _countryCode = countryCode;
      _phoneCode = phoneCode;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCountryInfo();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
            decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(isFull && _countryCode.isNotEmpty ? 1 : 0.4),
                borderRadius: BorderRadius.circular(16)),
            child: NumberDialog(
              countryCode: _countryCode,
              phoneCode: _phoneCode,
              isFull: isFull,
              number: controller.text,
            )),
        body: Stack(
          children: [
            Container(
                color: bgColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(16)),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 48,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        showCountryPicker(
                                          countryListTheme:
                                              CountryListThemeData(
                                                  flagSize: 25,
                                                  titleStyle: primaryInterStyle,
                                                  numberStyle: codeInterStyle,
                                                  searchTextStyle:
                                                      codeInterStyle,
                                                  textStyle: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  inputDecoration:
                                                      InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            14),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: containerColor,
                                                    prefixIcon: const Icon(
                                                        Icons.search),
                                                    prefixIconColor:
                                                        primaryColor,
                                                    iconColor: primaryColor,
                                                    hintText: 'Search',
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(25.0),
                                                  ),
                                                  backgroundColor: bgColor),
                                          context: context,
                                          showPhoneCode: true,
                                          onSelect: (Country country) {
                                            setState(() {
                                              _phoneCode = country.phoneCode;
                                              _countryCode =
                                                  country.countryCode;
                                            });
                                          },
                                        );
                                      },
                                      child: CodeSelector(
                                          countryCode: _countryCode,
                                          phoneCode: _phoneCode)),
                                ]),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(16)),
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextField(
                              inputFormatters: [
                                TextInputMask(mask: '(999) 999-9999'),
                                LengthLimitingTextInputFormatter(maxLength)
                              ],
                              style: codeInterStyle,
                              controller: controller,
                              keyboardType: TextInputType.phone,
                              autofocus: true,
                              onChanged: ((value) {
                                setState(() {
                                  isFull = value.length >= maxLength;
                                });
                              }),
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                  hintText: '(123) 123-1234',
                                  hintStyle: secondaryInterStyle),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 20),
              child: SizedBox(
                height: 40,
                child: Text("Get Started", style: primaryInterStyle),
              ),
            ),
          ],
        ));
  }
}

class NumberDialog extends StatelessWidget {
  final String phoneCode;
  final String countryCode;
  final bool isFull;
  final String number;

  const NumberDialog(
      {super.key,
      required this.countryCode,
      required this.phoneCode,
      required this.isFull,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_forward,
        color: primaryColor,
      ),
      onPressed: isFull && countryCode.isNotEmpty
          ? () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Phone number"),
                      content:
                          Text("Your phone number is: +$phoneCode $number"),
                    );
                  });
            }
          : null,
    );
  }
}

class CodeSelector extends StatelessWidget {
  final String countryCode;
  final String phoneCode;
  const CodeSelector(
      {super.key, required this.countryCode, required this.phoneCode});

  @override
  Widget build(BuildContext context) {
    String countryCodeToEmoji(String countryCode) {
      final int firstLetter =
          countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
      final int secondLetter =
          countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
      return String.fromCharCode(firstLetter) +
          String.fromCharCode(secondLetter);
    }

    return Row(
      children: [
        countryCode.isNotEmpty
            ? Text(
                countryCodeToEmoji(countryCode),
                style: const TextStyle(
                  fontSize: 20,
                ),
              )
            : const Icon(
                Icons.flag,
                size: 20,
              ),
        Text(
          ('+$phoneCode'),
          style: codeInterStyle,
        )
      ],
    );
  }
}
