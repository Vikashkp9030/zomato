import '../../../../core/network/dio_client.dart';

class PayrollApiService {
  final DioClient dioClient;

  PayrollApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllPayroll({
    int page = 1,
    int limit = 10,
    String? month,
  }) async {
    final response = await dioClient.get(
      '/payroll',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (month != null) 'month': month,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPayrollById(String id) async {
    final response = await dioClient.get('/payroll/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getEmployeePayroll(String employeeId, String month) async {
    final response = await dioClient.get(
      '/employees/$employeeId/payroll',
      queryParameters: {'month': month},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPayslip(String payrollId) async {
    final response = await dioClient.get('/payroll/$payrollId/payslip');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPayroll(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/payroll',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> processPayroll(String month, Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/payroll/process',
      data: {...data, 'month': month},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPayrollSummary(String month) async {
    final response = await dioClient.get(
      '/payroll/summary',
      queryParameters: {'month': month},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deletePayroll(String id) async {
    await dioClient.delete('/payroll/$id');
  }
}