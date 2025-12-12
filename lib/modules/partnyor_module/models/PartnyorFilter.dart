class PartnyorFilter {
  final String? name;
  final double? minAmount;
  final double? maxAmount;
  final int? tip;
  final String? aktiv;

  PartnyorFilter({
    this.name,
    this.minAmount,
    this.maxAmount,
    this.tip,
    this.aktiv,
  });

  /// QueryString formatına çevirən method
  Map<String, String> toQueryParams() {
    final params = <String, String>{};

    if (name != null && name!.isNotEmpty) params['name'] = name!;
    if (minAmount != null) params['minBorc'] = minAmount.toString();
    if (maxAmount != null) params['maxBorc'] = maxAmount.toString();
    if (tip != null) params['tip'] = tip.toString();
    if (aktiv != null) params['aktiv'] = aktiv.toString();

    return params;
  }
}
