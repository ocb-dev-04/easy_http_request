
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

Then:

```dart
EasyHttpRequest.init(config: HttpConfigData(baseApi: 'https://jsonplaceholder.typicode.com'));
```

You can add the initialization in the main method (for example)

```dart
void main() async {
  EasyHttpRequest.init(config: HttpConfigData(baseApi: 'https://jsonplaceholder.typicode.com'));
  runApp(const App());
}
```

The <strong>HttpConfigData</strong> has more properties like:

```dart
HttpConfigData({
    required this.baseApi,
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
import 'package:easy_http_request/core/parser/http_parser.dart';

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

* completeResponse => Reply directly from the http client. Contains statusCode, headers and more
* modelResponse => Returns the model if applicable for return. Example in the onGetOne returns the model. In the case of onPost, onPut and onPatch it will depend on what you need and that your service returns the model
* modelResponseAsList => Returns a collection of the model. Only value is returned in the onGetMany


### Examples

Get <strong>SINGLE</strong> model from API using onGetOne method:
```dart
final response = await easyHttp.onGetOne<PostModel>(extraUri: 'posts/$id', model: PostModel());
```

Get <strong>COLLECTION</strong> from API using onGetMany method:
```dart
final response = await easyHttp.onGetMany<PostModel>(extraUri: 'posts', model: PostModel());
```

Send <strong>POST</strong> to API using onPost method:
```dart
final fakerModel = PostModel(
      id: 1,
      userId: faker.randomGenerator.integer(4000, min: 100),
      title: faker.company.name(),
      body: faker.lorem.sentences(4).join(' '),
    );
final response = await easyHttp.onPost<PostModel>(extraUri: 'posts', model: fakerModel);
```

Send <strong>PUT</strong> to API using onPut method:
```dart
final fakerModel = PostModel(
      id: 1,
      userId: faker.randomGenerator.integer(4000, min: 100),
      title: faker.company.name(),
      body: faker.lorem.sentences(4).join(' '),
    );
final response = await easyHttp.onPut<PostModel>(extraUri: 'posts/$id', model: fakerModel);
```

Send <strong>PATCH</strong> to API using onPatch method:
```dart
final fakerModel = PostModel(
      id: 1,
      userId: faker.randomGenerator.integer(4000, min: 100),
      title: faker.company.name(),
      body: faker.lorem.sentences(4).join(' '),
    );
final response = await easyHttp.onPatch<PostModel>(extraUri: 'posts/$id', model: fakerModel);
```

Send <strong>DELETE</strong> to API using onDelete method:
```dart
// onDelete not need send model
final response = await easyHttp.onDelete(extraUri: 'posts/$id');
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