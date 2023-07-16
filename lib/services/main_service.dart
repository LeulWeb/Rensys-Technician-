// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/models/bundle_package.dart';
import 'package:technician_rensys/models/service.dart';
import 'package:technician_rensys/models/user_bank.dart';
import 'package:technician_rensys/providers/all_banks.dart';
import 'package:technician_rensys/providers/service_list.dart';
import '../models/job.dart';
import '../models/profile.dart';
import '../providers/bundle_package_provider.dart';
import '../providers/job_list.dart';
import '../providers/user_bank_provider.dart';
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
      // logger.d(result);
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

  //Getting List of subscription packages
  Future<bool> getPackage(BuildContext context) async {
    const String getPackageQuery = '''
    query MyQuery {
  subscription_plan(where: {is_active: {_eq: true}}) {
    name
    number_of_service
    plan_type
    price
    id
  }
}

    ''';

    try {
      QueryResult response = await client.query(QueryOptions(
          document: gql(getPackageQuery),
          fetchPolicy: FetchPolicy.networkOnly));

      if (response.hasException) {
        throw Exception(response.exception);
      }

      final List fromJson = response.data?["subscription_plan"];

      final List<BundlePackage> toModel =
          fromJson.map((e) => BundlePackage.fromJson(e)).toList();

      //Setting to the provider
      final bundleProvider =
          Provider.of<BundlePackageProvider>(context, listen: false);
      bundleProvider.setBundlePackage(toModel);

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  //*Accessing all banks
  Future<List<AllBanksModel>> getAllBanks(BuildContext context) async {
    const allBankQuery = '''
   query MyQuery {
  banks {
    name
    id
  }
}

''';

    try {
      QueryResult response = await client.query(
        QueryOptions(
          document: gql(allBankQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (response.hasException) {
        throw Exception(response.exception);
      }

      final List<dynamic> jsonAllBankList = response.data!["banks"];

      final List<AllBanksModel> _allBankList =
          jsonAllBankList.map((e) => AllBanksModel.fromMap(e)).toList();
      final allBankProvider =
          Provider.of<AllBanksProvider>(context, listen: false);
      allBankProvider.setAllBanks(_allBankList);
      // logger.d(allBankProvider.allBanks, "List of all banks");

      return _allBankList;
    } catch (e) {
      throw Exception(e);
    }
  }

  //* Accessing the bank account

  Future<List<UserBank>> getBankAccount(BuildContext context) async {
    const bankQuery = '''
 query MyQuery {
  technician {
    bank_accounts {
      account_number
      bank_id
      id
      bank {
        name
      }
    }
  }
}


''';

    try {
      QueryResult response = await client.query(
        QueryOptions(
          document: gql(bankQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (response.hasException) {
        throw Exception(response.exception);
      }

      final List<dynamic> jsonBankList = response.data!["bank_accounts"];
      // logger.d(jsonBankList, "Bank List");
      final List<UserBank> _userBankList =
          jsonBankList.map((e) => UserBank.fromMap(e)).toList();
      // logger.d(_userBankList);
      final userBankProvider =
          Provider.of<UserBankProvider>(context, listen: false);
      userBankProvider.setBankList(_userBankList);
      // logger.d(userBankProvider.userBankList);

      return _userBankList;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Technician Profile
  Future<QueryResult> getTechnician(BuildContext context) async {
    getBankAccount(context);

    const techQuery = '''
      query MyQuery {
  technician {
    id
    availability
    avator
    bios
    first_name
    is_verified
    last_name
    packages
    phone_number
  }
}


  ''';

    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(techQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }

      final Map json = result.data!["technician"][0];
      // logger.d(jsonList.first, "Technician");
      // logger.d(json, "Technician");
      // logger.d(Profile.fromMap(json), "Technician Modeld");
      final Profile profile = Profile.fromMap(json);
      // logger.d(profile);
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.setProfile(profile);
      // logger.d(profileProvider.profile, "Profile Provider");
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  //Buying package
  Future<bool> buyPackage(
      {required String subId,
      required String receiptNumber,
      required num amount}) async {
    const buyPackageQuery = '''
      mutation MyMutation(\$amount: Float!, \$receipt_number: String !, \$subscription_plan_id: uuid!) {
  insert_subscription_one(object: {amount: \$amount, receipt_number: \$receipt_number, subscription_plan_id: \$subscription_plan_id}) {
    id
  }
}
  ''';

    try {
      QueryResult response = await client.mutate(
        MutationOptions(
          document: gql(buyPackageQuery),
          variables: {
            "amount": amount,
            "receipt_number": receiptNumber,
            "subscription_plan_id": subId,
          },
        ),
      );

      if (response.hasException) {
        throw Exception(response.exception);
      }
      logger.d(response.data!["insert_subscription_one"]["id"],
          "Response from buying package");
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<QueryResult> updateProfile(Profile profile) async {
    const String updateProfileQuery = '''
        mutation MyMutation(\$phone_number: String!, \$last_name: String!, \$first_name: String!, \$bios: String!, \$id: uuid!) {
  update_technician_by_pk(pk_columns: {id: \$id}, _set: {phone_number: \$phone_number, last_name: \$last_name, first_name: \$first_name, bios: \$bios}) {
    id
  }
}
    ''';

    try {
      QueryResult result = await client.mutate(
          MutationOptions(document: gql(updateProfileQuery), variables: {
        "first_name": profile.firstName,
        "last_name": profile.lastName,
        "phone_number": profile.phoneNumber,
        "bios": profile.bio,
        "id": profile.id
      }));

      return result;
    } catch (err) {
      throw Exception(err);
    }
  }
}
