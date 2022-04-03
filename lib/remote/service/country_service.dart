import 'package:cbnits/model/country_model.dart';
import 'package:cbnits/remote/api.dart';
import 'package:graphql/client.dart';

class CountryService {
  static CountryService? _instance;

  factory CountryService() => _instance ??= CountryService._();

  CountryService._();

  Future<List<CountryModel>> getAllCountries() async {
    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
       query getCountryList{
                        countries{
                          name
                          emoji
                          phone
                          code
                          currency
                          languages {
                            code
                            name
                           }
                        }
                    }
      ''',
      ),
    );
    var response = await Api().getCountryList(options);
    return response;
  }
}
