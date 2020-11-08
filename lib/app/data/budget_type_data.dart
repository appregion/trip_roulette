import 'package:trip_roulette/app/models/budget_type_model.dart';

final List<BudgetType> budgetTypeList = [
  BudgetType(
    title: 'Poor guy',
    subtitle: 'I barely have enough money for a beer',
    isSelected: false,
    minPrice: 0.0,
    maxPrice: 200.0,
  ),
  BudgetType(
    title: 'Middle class',
    subtitle: 'Have money but not too much',
    isSelected: false,
    minPrice: 200.0,
    maxPrice: 1000.0,
  ),
  BudgetType(
    title: 'Rich as F*ck',
    subtitle: 'I can buy Ritz Group',
    isSelected: false,
    minPrice: 1000.0,
    maxPrice: 100000.0,
  ),
];
