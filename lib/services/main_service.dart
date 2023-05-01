import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/models/job.dart';

import '../providers/job_list.dart';
import 'graphql_client.dart';

class MainService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();
  final JobList _provider;
  MainService(this._provider);

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
        ),
      );
      final List<dynamic> mapList=  await result.data?["jobs"];

      //Set it to provider
      final List<JobModel> modelList =  mapList.map((e) => JobModel.fromMap(e)).toList();
      final myProvider =  Provider.of<JobList>(context, listen: false);
      myProvider.setJobs(modelList);
      return result;

    } catch (error) {
      throw Exception(error);
    }
  }
}
