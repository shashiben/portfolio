import 'package:http/http.dart' as http;

class HTTPService {
  Future<bool> sendMail(
      String from, String text, String subject, Function openMail) async {
    try {
      Map<String, dynamic> body = {
        "from": from,
        "to": "",
        "text": text,
        "subject": subject
      };
      http.Response res = await http.post(
          Uri.parse("https://node-mailer-portfolio.herokuapp.com/api/sendMail"),
          body: body);
      if (res.statusCode == 200) {
        return true;
      } else {
        await openMail();
      }
    } catch (e) {
      openMail();
      return false;
    }
    return false;
  }
}
