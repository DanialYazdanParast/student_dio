import 'package:dio/dio.dart';

class StudentData {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final int score;
  final String createdAt;
  final String updatedAt;

  StudentData(this.id, this.firstName, this.lastName, this.course, this.score,
      this.createdAt, this.updatedAt);

  StudentData.fromJson(dynamic json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        course = json['course'],
        score = json['score'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];
}

class HttpClient {
  static Dio dio =
      Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'));
}

Future<List<StudentData>> getStudent() async {
  final response = await HttpClient.dio.get('experts/student');

  final List<StudentData> student = [];
  if (response.data is List<dynamic>) {
    (response.data as List<dynamic>).forEach((element) {
      student.add(StudentData.fromJson(element));
    });
  }
  return student;
}

Future<StudentData> saveStudent(
    String firstName, String lastName, String course, int score) async {
  final response = await HttpClient.dio.post('experts/student', data: {
    "first_name": firstName,
    "last_name": lastName,
    "course": course,
    "score": score
  });

  if (response.statusCode == 200) {
    return StudentData.fromJson(response.data);
  } else {
    throw Exception();
  }
}
