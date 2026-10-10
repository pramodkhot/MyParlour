/// Route paths used across the app. Screens opened from More live under
/// `/more/...` so the More tab stays highlighted.
abstract final class Routes {
  static const dashboard = '/dashboard';
  static const appointments = '/appointments';
  static const billing = '/billing';
  static const more = '/more';

  static const customers = '/more/customers';
  static const staff = '/more/staff';
  static const services = '/more/services';
  static const inventory = '/more/inventory';
  static const expenses = '/more/expenses';
  static const reports = '/more/reports';
  static const settings = '/more/settings';
}
