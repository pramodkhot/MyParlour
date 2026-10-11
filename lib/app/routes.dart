/// Route paths used across the app. Screens opened from More live under
/// `/more/...` so the More tab stays highlighted.
abstract final class Routes {
  static const welcome = '/';

  static const dashboard = '/dashboard';
  static const appointments = '/appointments';
  static const billing = '/billing';
  static const more = '/more';

  /// New appointment, optionally for a customer and/or on a date.
  static String newAppointment({String? customerId, DateTime? date}) {
    final query = <String, String>{
      'customerId': ?customerId,
      if (date != null)
        'date':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}',
    };
    return Uri(
      path: '/appointments/new',
      queryParameters: query.isEmpty ? null : query,
    ).toString();
  }

  static String appointment(String id) => '/appointments/$id';
  static String rescheduleAppointment(String id) => '/appointments/$id/edit';

  static const customers = '/more/customers';
  static const newCustomer = '/more/customers/new';
  static String customer(String id) => '/more/customers/$id';
  static String editCustomer(String id) => '/more/customers/$id/edit';

  static const staff = '/more/staff';
  static const newStaff = '/more/staff/new';
  static String staffMember(String id) => '/more/staff/$id';
  static String editStaff(String id) => '/more/staff/$id/edit';

  static const services = '/more/services';
  static const newService = '/more/services/new';
  static String editService(String id) => '/more/services/$id/edit';

  static const inventory = '/more/inventory';
  static const expenses = '/more/expenses';
  static const reports = '/more/reports';
  static const settings = '/more/settings';
}
