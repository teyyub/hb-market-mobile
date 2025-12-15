import 'package:hbmarket/modules/print_module/models/qaime_detail_dto.dart';
import 'package:hbmarket/modules/print_module/models/qaime_item.dart';

class QaimePrintDto {
  final QaimeDetailDto qaimeDetail;
  final List<QaimeItem> qaimeItems;

  QaimePrintDto({
    required this.qaimeDetail,
    required this.qaimeItems,
  });
}
