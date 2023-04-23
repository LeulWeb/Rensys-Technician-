import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink("http://10.161.82.127/v1/graphql");
  // SharedPreferences? loginData;
  // String? accessToken;

  // void getToken() async {
  //   loginData = await SharedPreferences.getInstance();
  //   accessToken = loginData?.getString("accessToken");
  // }

  // static AuthLink authLink = AuthLink(
  //     getToken: () => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsiYWRtaW5zIiwib3BlcmF0b3IiLCJ0ZWNobmljaWFuIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6ImFkbWlucyIsIngtaGFzdXJhLXVzZXItaWQiOiIyNjE1NzVhMC00MWM4LTQ3ZjctYjBmNC03NTk1MDk4MGJhOWUifSwiaWF0IjoxNjgxMzkzMDYyfQ.XYY_18AJ--Lku-ty5DxOUlnNKHSIjxwqC0iT6vWr9f4",
  //     headerKey:"Authorization"
  //     );

  // static Link link = authLink.concat(httpLink);

  GraphQLClient clientToQuery() => GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      );
}
