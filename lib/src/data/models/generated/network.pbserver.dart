//  Generated code. Do not modify.
//  source: network.proto
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: require_trailing_commas
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_constructors_over_static_methods
// ignore_for_file: sort_unnamed_constructors_first
// ignore_for_file: sort_constructors_first
// ignore_for_file: prefer_final_locals
// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'network.pb.dart' as $2;
import 'network.pbjson.dart';

export 'network.pb.dart';

abstract class NetworkServiceBase extends $pb.GeneratedService {
  $async.Future<$2.GetNetworkInfoResponse> getNetworkInfo(
      $pb.ServerContext ctx, $2.GetNetworkInfoRequest request);
  $async.Future<$2.GetNodeInfoResponse> getNodeInfo(
      $pb.ServerContext ctx, $2.GetNodeInfoRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'GetNetworkInfo':
        return $2.GetNetworkInfoRequest();
      case 'GetNodeInfo':
        return $2.GetNodeInfoRequest();
      default:
        throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'GetNetworkInfo':
        return this.getNetworkInfo(ctx, request as $2.GetNetworkInfoRequest);
      case 'GetNodeInfo':
        return this.getNodeInfo(ctx, request as $2.GetNodeInfoRequest);
      default:
        throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => NetworkServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => NetworkServiceBase$messageJson;
}
