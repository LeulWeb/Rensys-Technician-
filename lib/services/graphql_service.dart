import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'graphql_client.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();
  Logger logger = Logger();
  //Method for sign in the user
  Future<QueryResult> login({required String phone, required String password}) async {
    const loginMutation = '''
          mutation MyMutation(\$password: String!, \$phone: String! ) {
  login(inputs: {password: \$password, phone: \$phone}) {
    accestoken
  }
}
''';
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            fetchPolicy: FetchPolicy.networkOnly,
            document: gql(loginMutation),
            variables: {"phone": phone, "password": password}),
      );

      // if (result.hasException) {
      //   throw Exception(result.exception);
      // }

      return  result;
    } catch (error) {
      throw Exception(error);
    }
  }
}
