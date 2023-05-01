
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/job_list.dart';
import 'graphql_client.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();
  

  //Method for sign in the user
  Future<QueryResult> login(
      {required String phone, required String password }) async {
    const loginMutation = '''
          mutation MyMutation(\$password: String!, \$phone: String! ) {
  login(inputs: {password: \$password, phone: \$phone}) {
    accestoken
    id
  }
}
''';

    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(loginMutation),
            variables: {"phone": phone, "password": password}),
      );

      // if (result.hasException) {
      //   print(result.exception!.graphqlErrors);
      //   throw Exception(result.exception);
      // }

      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  // List of jobs available jobs
  
}
