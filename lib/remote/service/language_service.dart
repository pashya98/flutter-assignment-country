import 'package:cbnits/model/language_model.dart';
import 'package:cbnits/remote/api.dart';
import 'package:graphql/client.dart';

class LanguageService {
  static LanguageService? _instance;

  factory LanguageService() => _instance ??= LanguageService._();

  LanguageService._();

  Future<List<LanguageModel>> getAllLanguages() async {
    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
       query getLanguageList(){
                         languages {
                            code
                            name
                            native
                           }
                    }
      ''',
      ),
    );
    var response = await Api().getLanguageList(options);
    return response;
  }
}
