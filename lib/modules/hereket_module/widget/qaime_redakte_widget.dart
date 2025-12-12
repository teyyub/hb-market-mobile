import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/hereket_module/controller/qaime_bax_controller.dart';
import '../../common/widgets/custom_keyboard.dart';
import '../models/qaime_bax.dart';

class QaimeRedakteWidget extends StatefulWidget {
  final QaimeBaxDto requestDto;
  // final VoidCallback onSave;

  const QaimeRedakteWidget({
    super.key,
    required this.requestDto,
    // required this.onSave,
  });
  @override
  State<QaimeRedakteWidget> createState() => _QaimeRedakteWidgetState();
}

class _QaimeRedakteWidgetState extends State<QaimeRedakteWidget> {
  late QaimeBaxDto req;
  QaimeBaxDto? applyResponseDto;

  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController sellPriceCtrl = TextEditingController();
  final QaimeBaxController qaimeBaxCtrl = Get.find<QaimeBaxController>();

  final FocusNode amountFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode sellPriceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    req = widget.requestDto;
    debugPrint('reqF1->${req.toJson()}');
    // loadApply();
    // qaimeBaxCtrl.setActiveController(amountCtrl);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      amountFocus.requestFocus();
    });

    amountFocus.addListener(() {
      if (amountFocus.hasFocus) {
        qaimeBaxCtrl.setActiveController(amountCtrl);
      }
    });

    priceFocus.addListener(() {
      if (priceFocus.hasFocus) {
        qaimeBaxCtrl.setActiveController(priceCtrl);
      }
    });


    amountCtrl.text = req.miqdar.toString();
    priceCtrl.text = req.qiymet.toString();
    // sellPriceCtrl.text=req.sellPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.7;
    const double elementMaxWidth = 300;
    const double gap = 8;
    return SizedBox(
      height: height, // bounded height
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: amountCtrl,
                    focusNode: amountFocus,
                    keyboardType: TextInputType.none,
                    decoration: const InputDecoration(
                      labelText: "Miqdar",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceCtrl,
                    focusNode: priceFocus,
                    keyboardType: TextInputType.none,
                    decoration: const InputDecoration(
                      labelText: "Qiymet",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [

                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // final dtoSave = QaimeBaxDto(
                    //   id:req.id,
                    //   miqdar: int.tryParse(amountCtrl.text),
                    //   qiymet: double.tryParse(priceCtrl.text),
                    //   // sellPrice: double.parse(sellPriceCtrl.text),
                    //   // note: '', // or noteController.text if you have a note field
                    // );
                    // widget.onSave();
                    req.miqdar = int.tryParse(amountCtrl.text);
                    req.qiymet = double.tryParse(priceCtrl.text);
                    // Get.back(result: dtoSave);
                    Get.back(result: req);
                  },
                  child: const Text("Təsdiqlə"),
                ),
              ],
            ),
            // Second Input
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300, // keyboard genişliyi
                  maxHeight: 380, // keyboard hündürlüyü (istəyə uyğun)
                ),

                child: GetBuilder<QaimeBaxController>(
                  builder: (QaimeBaxController ctrl) {
                    if (ctrl.activeController == null) {
                      return const SizedBox.shrink(); // hələ klaviatura göstərmə
                    }
                    return CustomKeyboard(
                      controller: ctrl.activeController!,
                      onSubmit: (String value) {
                        print('Submitted: $value');
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
