import 'package:trip_roulette/app/models/budget_type_model.dart';

final List<BudgetType> budgetTypeList = [
  BudgetType(
    title: 'Strict budget',
    subtitle: 'The cheapest options',
    isSelected: false,
    minPrice: 0.0,
    maxPrice: 200.0,
  ),
  BudgetType(
    title: 'Middle range',
    subtitle: 'Moderate prices',
    isSelected: false,
    minPrice: 200.0,
    maxPrice: 1000.0,
  ),
  BudgetType(
    title: 'Unlimited',
    subtitle: 'The most expensive options',
    isSelected: false,
    minPrice: 1000.0,
    maxPrice: 100000.0,
  ),
];
