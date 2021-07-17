import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pahir/Model/ResourceSearchNew.dart';
import 'package:pahir/data/api/repository/ResourceRepo.dart';
import 'package:http/http.dart' as http;

part 'resource_view_event.dart';
part 'resource_view_state.dart';

class ResourceViewBloc extends Bloc<ResourceViewEvent, ResourceViewState> {
  ResourceViewBloc() : super(ResourceViewInitial());

  @override
  Stream<ResourceViewState> mapEventToState(
    ResourceViewEvent event,
  ) async* {
    if (event is FetchResourceDetails) {
      yield ResourceLoading();
      ResourceRepo resourceRepo=ResourceRepo();
      http.Response? response = await resourceRepo.fetchResourceData1(event.resourceId,event.resourceType);

      if (response!.statusCode==200) {
        ResourceResults resourceDetail = ResourceResults.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        yield ResourceFetched(resourceDetail);
      }else{
        yield ResourceFetchingFailed();
      }
    } else if (event is UpdateResourceDetails) {
      // yield ResourceLoading();
      ResourceRepo resourceRepo=ResourceRepo();
      http.Response? response = await resourceRepo.updateResourceData1( addResourceModel: event.resourcemodel);
      if (response!.statusCode==200) {
        ResourceResults resourceDetail = ResourceResults.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        yield ResourceFetched(resourceDetail);
      }else{
        yield ResourceFetchingFailed();
      }
    }
  }
}
