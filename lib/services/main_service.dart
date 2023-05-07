import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/models/service.dart';
import 'package:technician_rensys/providers/service_list.dart';
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
      customer_id
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
      final List<JobModel> modelList =
          mapList.map((e) => JobModel.fromMap(e)).toList();
      // logger.d(mapList);
      final myProvider = Provider.of<JobList>(context, listen: false);
      myProvider.setJobs(modelList);
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

  Future<QueryResult> getService(
      BuildContext context, String serviceStatus) async {
    const serviceQuery = '''
    query MyQuery(\$_eq: service_request_status) {
  service_request(where: {status: {_eq: \$_eq}}) {
    status
    customer_phone
    is_assigned_to_technician
    is_in_warranty_request
    technician_assigned_at
    problem_description
    customer_id
    id
    problem_class {
      name
    }
    created_at
    address {
      zone {
        name
      }
      woreda {
        name
      }
      kebele {
        name
      }
      region {
        name
      }
    }
  }
}


  ''';
    try {
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(serviceQuery),
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {
              "_eq": serviceStatus,
            }),
      );

      final List<dynamic> mapList = await result.data?["service_request"];

      // logger.d(mapList);

      final List<ServiceModel> modelList =
          mapList.map((e) => ServiceModel.fromMap(e)).toList();
      // set it to provider
      final myProvider = Provider.of<ServiceList>(context, listen: false);
      if (serviceStatus == "progress") {
        myProvider.setServices(modelList);
      }

      if (serviceStatus == "completed") {
        myProvider.setCompleted(modelList);
      }

      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Submitting Form In Work progress

  Future<QueryResult> reportWork({
    required String serviceId,
    required bool isCompleted,
    required String problemDescription,
    required String solutionDescription,
  }) async {
    const submitQuery = '''
      mutation MyMutation(\$is_service_completed: Boolean, \$problem_diagnosis: String , \$service_req_id: uuid, \$solution_provided: String) {
  insert_technician_report_one(object: {is_service_completed: \$is_service_completed, problem_diagnosis: \$problem_diagnosis, service_req_id: \$service_req_id, solution_provided: \$solution_provided}) {
    id
  }
}
    ''';

    try {
      QueryResult result = await client.mutate(
        MutationOptions(document: gql(submitQuery), variables: {
          "is_service_completed": isCompleted,
          "problem_diagnosis": problemDescription,
          "solution_provided": solutionDescription,
          "service_req_id": serviceId,
        }),
      );

      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
