
A package that simplifies the queries to the apis or web services, you focus on creating the model, this package takes care of the rest.


  - [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Initialization](#initialization)
  - [Combine with Dependency Injection](#combine-with-dependency-injection)
  - [Configure the model](#configure-the-model)
  - [Parameters and Response Data](#parameters-and-response-data)
  - [Examples](#examples)
  - [License](#license)
  - [Features and bugs](#features-and-bugs)


### Getting Started
First of all, welcome to the easy way to consume services.


### Installation

Add dependency

```yaml
dependencies:
  easy_http: 1.0.0
```

### Initialization

First, import dependeny:
```dart
import 'package:easy_http_request/easy_http_request.dart';
```

So if you only use a <strong>SINGLE API PATH</strong>, you can do this:

```dart
const String mainApiPath = 'MAIN_API';
EasyHttpSettings.initWithSingleApi(config: EasyHttpConfig(apiPath: 'https://jsonplaceholder.typicode.com', identifier: mainApiPath));
```

Or, if you need to use a <strong>COLLECTION API PATH</strong>, you can do this:

```dart
const String firstIdentifier = 'FirstApiPath';
const String secondIdentifier = 'SecondApiPath';

EasyHttpSettings.initWithManyApi(config: [
    EasyHttpConfig(apiPath: 'https://jsonplaceholder.typicode.com', identifier: firstIdentifier),
    EasyHttpConfig(apiPath: 'https://fakestoreapi.com', identifier: secondIdentifier)
]);
```

You can add the initialization in the main method (for example)

```dart
const String mainApiPath = 'MAIN_API';

void main() {
  // package init
  EasyHttpSettings.initWithSingleApi(config: EasyHttpConfig(apiPath: 'https://jsonplaceholder.typicode.com', identifier: mainApiPath));

  runApp(App());
}
```

The <strong>HttpConfigData</strong> has more properties like:

```dart
HttpConfigData({
    required this.identifier,
    required this.apiPath,
    this.headers = const {},
    this.timeOut = 30 * 1000,
    this.validStatus = 204, 
    this.followRedirect = false,
    this.includeLogger = true,
});

int validStatus;
// Valid status code for the request to be interpreted as complete
// or incomplete.
//
// Example:
//
// If your service returns a 200 Ok, a 201 Created and a 204 NotContent
// your [validStatusCode] is the highest number in this case 204
// By default 204 NotContent is the validStatus
```

Feel free to configure it to your need.


### Combine with Dependency Injection
So now you can:

1. Use Getx Dependency Injection:
```dart
class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EasyHttpRequestContract>(() => EasyHttpRequest());
  }
}
```

2. Or, you can also use Get It:
```dart
class DIManager {
  static void setup() {
    final getIt = GetIt.instance;
    getIt.registerSingleton<EasyHttpRequestContract>(EasyHttpRequest());
  }
}
```

3. Finally, you can use the old way:
```dart
final httpServices = EasyHttpRequest();
```


### Configure the model

The model needs to implement <strong>HttpDataParser</strong> so that when the methods are invoked, the type of data to send is valid.

This would be the common model that we always use:

```dart
class PostModel {
  PostModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int? userId;
  int? id;
  String? title;
  String? body;

  PostModel fromJson(Map<String, dynamic> json) => PostModel(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}
```

This is the simple change that we will make:

```dart
import 'package:easy_http_request/easy_http_request.dart';

class PostModel implements HttpDataParser<PostModel> {
  PostModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int? userId;
  int? id;
  String? title;
  String? body;

  @override
  PostModel fromJson(Map<String, dynamic> json) => PostModel(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}
```

We import the package, implement the <strong>HttpDataParser</strong> and type the model we are configuring as a type: 
```dart
class PostModel implements HttpDataParser<PostModel>{}
```

And, add the <strong>@override</strong> to the <strong>toJson</strong> and <strong>fromJson</strong> methods and that's it.


### Parameters and Response Data

1. Parameters to make a request:

```dart
String extraUri 
/*
If you need to add some information to your baseApi. 
Example: Your baseApi is www.domain.com and you need to make a query 
to ww.domain.com/posts in the extraUri just add posts and it will 
concatenate it to your baseApi
*/

T model
/*
The model itself that you will use in the request, if it is a getOne or getMany only send an instance of the model, example:
*/

model: PostModel()

/*
If it is an onPost, onPut, onPatch sends the model with the information 
that you will send to create or update. Example:
*/

PostModel fakerModel = PostModel(
    id: 1,
    userId: faker.randomGenerator.integer(4000, min: 100),
    title: faker.company.name(),
    body: faker.lorem.sentences(4).join(' '),
);

// then, send it
model: fakerModel

Map<String, dynamic> queryParams
/*
You can use it to send query parameters that would normally be included 
directly in the path of the route. Example:
*/

queryParams: {
  "id":1, 
  "lang":"en"
}

bool returnModel
/*
In the onPost, onPut, onPatch methods you have the option of being able 
to return the model in case your service returns the record that has just been created or updated.

By default it is false.
*/
```

2. Response values

The <strong>EasyHttpRequestResponse</strong> class has some properties that are used depending on the method used

```dart
EasyHttpRequestResponse({
    this.completeResponse,
    this.modelResponse,
    this.modelResponseAsList,
  });
```

* <strong>completeResponse</strong> => Reply directly from the http client. Contains statusCode, headers and more
* <strong>modelResponse</strong> => Returns the model if applicable for return. Example in the onGetOne returns the model. In the case of onPost, onPut and onPatch it will depend on what you need and that your service returns the model
* <strong>modelResponseAsList</strong> => Returns a collection of the model. Only value is returned in the onGetMany


### Examples

##### Http Request

There are two methods of making requests:

1. To use the single http client.

```dart
final response = await easyHttpInstance.requestWithSinglePATH<PostModel(
  model: PostModel(), 
  requestType: EasyHttpType.getSingle, 
  extraUri: '$_extraUri/$id'
);
```

2. To use one of the customer collection.

```dart
final response = await easyHttpInstance.requestWithManyPATH<PostModel>(
  model: PostModel(),
  identifier: firstIdentifier,
  requestType: EasyHttpType.getSingle,
  extraUri: 'posts/1',
);
```
To execute the different types of request you only have to EasyHttpType which will allow you to choose if the request is:

<strong>getSingle, getCollection, post, put, patch, delete.</strong>

Example:

```
- NOTE: Applies both for when using a single or a collection of http clients
```

```dart
// getSingle:
final response = await easyHttpInstance.requestWithSinglePATH<PostModel>(model: PostModel(), requestType: EasyHttpType.getSingle, extraUri: '$_extraUri/$id');

// getCollection
final response = await easyHttpInstance.requestWithSinglePATH<PostModel>(model: PostModel(), requestType: EasyHttpType.getCollection, extraUri: _extraUri);

// post
final response =
          await easyHttpInstance.requestWithSinglePATH<PostModel>(model: fakerModel, requestType: EasyHttpType.post, extraUri: _extraUri, returnModel: true);

// put
final response = await easyHttpInstance.requestWithSinglePATH<PostModel>(
          model: fakerModel, requestType: EasyHttpType.put, extraUri: '$_extraUri/${fakerModel.id}', returnModel: true);

// patch
final response = await easyHttpInstance.requestWithSinglePATH<PostModel>(
          model: fakerModel, requestType: EasyHttpType.patch, extraUri: '$_extraUri/${fakerModel.id}', returnModel: true);

// delete
final response = await easyHttpInstance.requestWithSinglePATH<PostModel>(model: PostModel(), requestType: EasyHttpType.delete, extraUri: '$_extraUri/$id');
```

In case that you use manyHttpPath just do this:

```dart
// getSingle:
final response = await easyHttpInstance.requestWithManyPATH<PostModel>(
          model: PostModel(),// model
          identifier: firstIdentifier, // include instance identifier
          requestType: EasyHttpType.getSingle, // request type
          extraUri: 'posts/1',
        );

```


##### Manage headers
Once the http clients is instantiated, you can modify their headers:

  * In the case that it is a single http client
```dart
// add headers
EasyHeadersManager.addHeadersSingleClient(newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});
// update header
EasyHeadersManager.updateHeadersSingleClient(key: 'jwt', value: 'poiuytrewq');
// remove header
EasyHeadersManager.removeHeadersSingleClient(key: 'jwt');
```

  * In the case that it is a collection of http clients, you only have to add the identifier field, which will help to identify which instance of the http clinet the header will be modified
```dart
// add headers
EasyHeadersManager.addHeadersManyClient(identifier: firstIdentifier, newHeaders: {'jwt': 'qwertyuiop', 'api_key': 'iuqhjnudh87asyd8a7ys7ds'});

// update header
EasyHeadersManager.updateHeadersManyClient(identifier: secondIdentifier, key: 'api_key', value: '174091u1j2e091j2');

// remove header
EasyHeadersManager.removeHeadersManyClient(identifier: secondIdentifier, key: 'jwt');
```

You can find a complete example [here](./example/with_get_it_dependency_injection/lib/main.dart)

### License

```LICENSE
MIT License

Copyright (c) 2021 Oscar Chavez Brito

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/ocb-dev-04/easy_http_request/issues).