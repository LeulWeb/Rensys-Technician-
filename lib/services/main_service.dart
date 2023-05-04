import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../models/job.dart';
import '../providers/job_list.dart';
import 'graphql_client.dart';

class MainService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();


var logger = Logger();


  MainService();

  Future<QueryResult> getJob(BuildContext context) async {
    const jobQuery = '''
      query getJobList {
  jobs {
    proximity
    status
    created_at
    about
    service_request {
      address {
        kebele {
          name
        }
        woreda {
          name
        }
        zone {
          name
        }
        region {
          name
        }
      }
      status
      problem_description
      is_in_warranty_request
      id
      customer_phone
      selling_phone
      technician_assigned_at
      problem_class {
        name
      }
      created_at
    }
    id
  }
}

  ''';

    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(jobQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      final List<dynamic> mapList = await result.data?["jobs"];
      // Set it to provider
      final List<JobModel> modelList = mapList.map((e) => JobModel.fromMap(e)).toList();
      final myProvider = Provider.of<JobList>(context, listen: false);
      myProvider.setJobs(modelList);
      // print(result);
      // logger.d(modelList);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  //claiming a job
  Future<QueryResult> claimJob(String serviceId) async {
    const claimQuery = '''
      mutation MyMutation(\$service_req_id: String!) {
      cliam_job(service_req_id: \$service_req_id) {
    success
  }
}
  ''';
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(claimQuery),
            variables: {"service_req_id": serviceId}),
      );
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }
}
