
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/hereket_module/controller/f1_controller.dart';
import '../../common/widgets/custom_keyboard.dart';
import '../controller/apply_controller.dart';
import '../models/f1_dto.dart';
import '../models/hereket_dplan.dart';

class F1Widget extends StatefulWidget {


  final F1Dto f1RequestDto;
  // final VoidCallback onSave;

  const F1Widget({
    super.key,
    required this.f1RequestDto,
    // required this.onSave,
  });
  @override
  State<F1Widget> createState() => _F1WidgetState();
}

class _F1WidgetState extends State<F1Widget> {
  late F1Dto req;
  F1Dto? applyResponseDto;

  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController sellPriceCtrl = TextEditingController();
  final F1Controller f1Ctrl = Get.find<F1Controller>();

  final FocusNode amountFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode sellPriceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    req = widget.f1RequestDto;
    debugPrint('reqF1->${req}');
    // loadApply();
    f1Ctrl.setActiveController(amountCtrl);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      amountFocus.requestFocus();
    });

    amountFocus.addListener(() {
      if (amountFocus.hasFocus) {
          f1Ctrl.setActiveController(amountCtrl);
      }
    });

    priceFocus.addListener(() {
      if (priceFocus.hasFocus) {
        f1Ctrl.setActiveController(priceCtrl);
      }
    });

    sellPriceFocus.addListener(() {
      if (sellPriceFocus.hasFocus) {
        f1Ctrl.setActiveController(sellPriceCtrl);
      }
    });

    amountCtrl.text = req.amount.toString();
    priceCtrl.text = req.price.toString();
    sellPriceCtrl.text=req.sellPrice.toString();
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.8;

    return SizedBox(
      height: height, // bounded height
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(child:
              TextField(
                controller: amountCtrl,
                focusNode: amountFocus,
                decoration: const InputDecoration(
                  labelText: "Miqdar",
                  border: OutlineInputBorder(),
                ),
              ),)
            ],),

            const SizedBox(height: 12),
            Row(children: [
               Expanded(child:
               TextField(
                controller: priceCtrl,
                focusNode: priceFocus,
                decoration: const InputDecoration(
                  labelText: "Qiymet",
                  border: OutlineInputBorder(),
                ),
              ),)
            ],),

            const SizedBox(height: 12),
            Row(children: [
              Expanded(child:
              TextField(
                controller: sellPriceCtrl,
                focusNode: sellPriceFocus,
                decoration: const InputDecoration(
                  labelText: "Satis",
                  border: OutlineInputBorder(),
                ),
              ),),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final dtoSave = HereketDPlan(
                    amount: int.tryParse(amountCtrl.text),
                    price: double.tryParse(priceCtrl.text),
                    sellPrice: double.parse(sellPriceCtrl.text),
                    note: '', // or noteController.text if you have a note field
                  );
                  // widget.onSave();
                  Get.back(result: dtoSave);
                },
                child: const Text("Təsdiqlə"),
              ),
            ],
            ),
            // Second Input

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               Expanded(
                    flex: 3,
                 child: GetBuilder<F1Controller>(
                   builder: (F1Controller ctrl) {
                     return CustomKeyboard(
                       controller: ctrl.activeController!,
                       onSubmit: (String value) {
                         print('Submitted: $value');
                       },
                     );
                   },
                 ),
               )
              ],
            )


          ],
        ),
      ),
    );
  }

}





