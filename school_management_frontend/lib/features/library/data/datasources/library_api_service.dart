import '../../../../core/network/dio_client.dart';

class LibraryApiService {
  final DioClient dioClient;

  LibraryApiService(this.dioClient);

  Future<Map<String, dynamic>> getAllBooks({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    final response = await dioClient.get(
      '/library/books',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBookById(String id) async {
    final response = await dioClient.get('/library/books/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> searchBooks(String query) async {
    final response = await dioClient.get(
      '/library/books/search',
      queryParameters: {'q': query},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStudentIssuedBooks(String studentId) async {
    final response = await dioClient.get('/students/$studentId/library/issued');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> issueBook(Map<String, dynamic> data) async {
    final response = await dioClient.post(
      '/library/issue',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> returnBook(String issueId) async {
    final response = await dioClient.post(
      '/library/return/$issueId',
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getOverdueBooks() async {
    final response = await dioClient.get('/library/overdue');
    return response.data as Map<String, dynamic>;
  }

  Future<void> addBook(Map<String, dynamic> data) async {
    await dioClient.post(
      '/library/books',
      data: data,
    );
  }
}