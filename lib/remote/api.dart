import 'package:cbnits/model/country_model.dart';
import 'package:cbnits/model/language_model.dart';
import 'package:cbnits/remote/custom_exception/app_exception.dart';
import 'package:graphql/client.dart';

class Api {
  static String baseURL = "https://countries.trevorblades.com/graphql";

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static GraphQLClient getGithubGraphQLClient() {
    final Link _link = HttpLink(baseURL);
    return GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  Future<List<CountryModel>> getCountryList(QueryOptions options) async {
    final GraphQLClient _client = getGithubGraphQLClient();

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw AppException(result.exception!);
    }

    final List<dynamic> repositories =
        result.data!['countries'] as List<dynamic>;
    List<CountryModel> countryList = [];
    if (repositories.isNotEmpty) {
      for (var result in repositories) {
        countryList.add(CountryModel.fromJson(result));
      }
    }
    return countryList;
  }

  Future<List<LanguageModel>> getLanguageList(QueryOptions options) async {
    final GraphQLClient _client = getGithubGraphQLClient();
    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw AppException(result.exception!);
    }
    final List<dynamic> repositories =
        result.data!['languages'] as List<dynamic>;
    List<LanguageModel> languageList = [];
    if (repositories.isNotEmpty) {
      for (var result in repositories) {
        languageList.add(LanguageModel.fromJson(result));
      }
    }
    return languageList;
  }
}
