// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$RestApiService extends RestApiService {
  _$RestApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = RestApiService;

  @override
  Future<Response<dynamic>> getPosts(int id, String headerVal) {
    final $url = 'posts/$id';
    final $headers = {'Authorization': headerVal, 'abc': 'cba'};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<TokenModel1>> logUserIn(Map<String, String> body) {
    final $url = '/login';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<TokenModel1, TokenModel1>($request);
  }

  @override
  Future<Response<TokenModel1>> registerUser(Map<String, String> body) {
    final $url = '/register';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<TokenModel1, TokenModel1>($request);
  }

  @override
  Future<Response<List<PostModel>>> loadPosts(String token) {
    final $url = '/post';
    final $headers = {'x-auth-token': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<PostModel>, PostModel>($request);
  }

  @override
  Future<Response<PostModel>> loadPost(String id, String token) {
    final $url = '/post/$id';
    final $headers = {'x-auth-token': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<PostModel, PostModel>($request);
  }

  @override
  Future<Response<List<UsersProfileModel>>> loadUsersProfile(String token) {
    final $url = '/users';
    final $headers = {'x-auth-token': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<UsersProfileModel>, UsersProfileModel>($request);
  }

  @override
  Future<Response<UsersProfileModel>> loadSelectedUserProfile(
      String token, String id) {
    final $url = '/users/$id';
    final $headers = {'x-auth-token': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<UsersProfileModel, UsersProfileModel>($request);
  }

  @override
  Future<Response<UsersProfileModel>> loadMyProfile(String token) {
    final $url = '/users/me';
    final $headers = {'x-auth-token': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<UsersProfileModel, UsersProfileModel>($request);
  }

  @override
  Future<Response<UsersCreateProfileResponseModel>> createProfile(
      String token, Map<String, String> body) {
    final $url = '/users';
    final $headers = {'x-auth-token': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<UsersCreateProfileResponseModel,
        UsersCreateProfileResponseModel>($request);
  }

  @override
  Future<Response<CreatePostResponseModel>> createPost(
      String token, Map<String, String> body) {
    final $url = '/post';
    final $headers = {'x-auth-token': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client
        .send<CreatePostResponseModel, CreatePostResponseModel>($request);
  }

  @override
  Future<Response<List<PostCommentResponse>>> createComment(
      String token, String postId, Map<String, String> body) {
    final $url = '/post/comment/$postId';
    final $headers = {'x-auth-token': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client
        .send<List<PostCommentResponse>, PostCommentResponse>($request);
  }
}
