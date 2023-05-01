import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink("http://10.161.82.127/v1/graphql");
  static SharedPreferences? loginData;
  static String? accessToken='';

  //getting the bearer
  static getAccessToken() async {
    loginData = await SharedPreferences.getInstance();
    accessToken = loginData?.getString('accessToken');
    // print(accessToken);
  }

  static AuthLink authLink = AuthLink(
    getToken: () async{
      getAccessToken();
      if (accessToken != null) {
        return "Bearer $accessToken";
      }
      return null;
    },
    headerKey: "Authorization",
  );

  static Link link = accessToken !=null?  authLink.concat(httpLink) : httpLink;

  GraphQLClient clientToQuery() => GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      );
}
