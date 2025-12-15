
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/hereket_module/models/apply_dto.dart';
import 'package:hbmarket/modules/hereket_module/models/update_apply.dart';
import '../../common/widgets/custom_keyboard.dart';
import '../controller/apply_controller.dart';

class ApplyWidget extends StatefulWidget {


  final ApplyDto applyRequestDto;
  final VoidCallback onNullSave;

  const ApplyWidget({
    super.key,
    required this.applyRequestDto,
    required this.onNullSave,
  });
  @override
  State<ApplyWidget> createState() => _ApplyWidgetState();
}

class _ApplyWidgetState extends State<ApplyWidget> {
  late ApplyDto req;
  ApplyDto? applyResponseDto;

  final TextEditingController input1Ctrl = TextEditingController();
  final TextEditingController input2Ctrl = TextEditingController();
  final ApplyController applyCtrl = Get.find<ApplyController>();

  final FocusNode input1Focus = FocusNode();
  final FocusNode input2Focus = FocusNode();


  @override
  void initState() {
    super.initState();
    req = widget.applyRequestDto;
    debugPrint('req11111->${req}');
    loadApply();
    applyCtrl.activeController = input1Ctrl;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      input1Focus.requestFocus();
    });


    input1Focus.addListener(() {
      if (input1Focus.hasFocus) {
          applyCtrl.setActiveController(input1Ctrl);
      }
    });

    input2Focus.addListener(() {
      if (input2Focus.hasFocus) {
        applyCtrl.setActiveController(input2Ctrl);
      }
    });
    input2Ctrl.text = req!.amount.toString();
  }


// async metod
  Future<void> loadApply() async {
    try {
      // API request
      final response = await applyCtrl.fetchApplyDto(
        req.dPlanId,
        req.nov,
        req.price,
        req.amount,
        req.note,
      );

       debugPrint('response123->$response');
      setState(() {
        applyResponseDto = response;
        input1Ctrl.text = response?.amount?.toString() ?? 'Yoxdur';
        // input2Ctrl.text = response?.price?.toString() ?? '';
      });

    } catch (e) {
      // error handling
      print("API request error: $e");
    }
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
                controller: input1Ctrl,
                focusNode: input1Focus,
                 keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  labelText: "Cari",
                  border: OutlineInputBorder(),
                ),
              ),)
            ],),

            const SizedBox(height: 12),
            Row(children: [
              Expanded(child:
              TextField(
                controller: input2Ctrl,
                focusNode: input2Focus,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  labelText: "Yeni",
                  border: OutlineInputBorder(),
                ),
              ),),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  print("Input 1: ${input1Ctrl.text}");
                  print("Input 2: ${input2Ctrl.text}");
                  print("Input 2: ${applyResponseDto}");
                  if (applyResponseDto?.id==null) {
                    debugPrint('widget--$widget');
                      widget.onNullSave();
                  } else{
                    debugPrint('applyRes->${applyResponseDto}');
                  final UpdateApplyDto dto = UpdateApplyDto(id:applyResponseDto!.id!,
                  nov:applyResponseDto!.nov!,
                  price: double.tryParse(input2Ctrl.text)!);
                  applyCtrl.updateDplan(dto);
                  }
                  Get.back();
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
                 child: GetBuilder<ApplyController>(
                   builder: (ApplyController ctrl) {
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





