import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink("http://10.161.82.127/v1/graphql");
  static SharedPreferences? loginData;
  static String? accessToken;

  //getting the bearer
  static getAccessToken() async {
    loginData = await SharedPreferences.getInstance();
    accessToken = loginData?.getString('accessToken');
    // print("this is ---------------- access token");
    // print(accessToken);
  }

  static AuthLink authLink = AuthLink(
    getToken: () {
      getAccessToken();
      if (accessToken != null) {
        return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsiYWRtaW5zIiwib3BlcmF0b3IiLCJ0ZWNobmljaWFuIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InRlY2huaWNpYW4iLCJ4LWhhc3VyYS11c2VyLWlkIjoiNWNhZmNkYWUtMWQzZi00OTRlLThlNDMtZDQ1Zjg0MDhmOGMyIn0sImlhdCI6MTY4Mjc2MDkyNn0.7-osLo9BUsHfkwhRJtIayz_sTsyb6Gb-oV-3HHcJjO4";
      }
      return null;
    },
    headerKey: "Authorization",
  );

  static Link link =  authLink.concat(httpLink);

  GraphQLClient clientToQuery() => GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      );
}
