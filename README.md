# NateChallenge

This repository contains my coding challenge for Nate.tech

## Index
- [Application Overview](#application-overview)
- [Technical Informations](#technical-informations)
- [Frameworks](#cocoapods-frameworks)
- [Features Details](#features-details)
	- [RESTful API](#restful-api)
	- [Pagination](#pagination)
	- [Codable](#codable)
	- [Image Caching](#image-caching)
	- [Search Bar](#search-bar)

### Application Overview

The presented project is a simple App, able to receive a list of products with fixed properties, display them individually in an UITableView, and allowing the user to tap on the showed cells to display details on the choosen product.

#### Technical Informations
- iOS Version 13+
- Xcode 12.0.1
- CocoaPods

iOS 13+ was chosen as it is the most recent version adopted by the most users.

#### CocoaPods Frameworks
This project includes two external frameworks:

- CocoaLumberjack, a logging framework used to...Log stuff.
- SwiftLint, a framework used to enforce Swift style and conventions

No other framework were used to ensure that the App is built using only native components.


### Features Details
#### RESTful API
Requests are done via the provided RESTful API. The API is running in the provided Docker image for the purpose of this challenge, that will not be shared in this repository.

The only used endpoint is ```/products/offset```, that allows to request a set number of products ```take```, with an offset ```skip``` useful for [pagination](#Pagination).

The API Root URL used is ```http://localhost:3000```, and was defined directly in the API class.

#### Pagination
The UITableView used support pagination to avoid dealing with obese responses. The ```/products/offset``` endpoint of the API is used to request a set number of products, using the following JSON Body:
```json
{
	"skip": 0,
	"take": 20
}
```

The next batch of products (set by the value of ```take```) is requested everytime the UITableView will display the first cell from the previous batch. If the latest received batch count value is not equal to the value of ```take```, it stops requesting for new products.

#### Codable
The provided RESTful API will send data in the JSON format, and ask for the request body to also be formatted in JSON.

```JSONEncoder``` is used to create the request body as JSON from a custom object ```PageOffsetItem```.

```swift
class PageOffsetItem: Codable {

    let skip: Int
    let take: Int

    init(skip: Int, take: Int) {
        self.skip = skip
        self.take = take
    }
}
```
```JSONDecoder``` is used to create ```ProductList``` objects from the Data received via the API call.

```swift
class ProductList: Decodable {
    var posts: [Product]
}
```
```swift
class Product: Decodable {

    let id: String
    let createdAt: String
    let updatedAt: String
    let title: String
    let images: [String]
    let url: String
    let merchant: String
}
```

#### Image Caching
When receiving product, each resulting object possess an array of urls that can be used to fetch images for this product.

To avoid requesting the same image several time, ```NSCache``` was used. Each time an image has to be loaded, it will first try to retrieve in from the cache via a key (the string representing the url), then if it doesn't exist, download it and save the new value in the cache.

#### Search bar
A ```UISearchBar``` is present on top of the ```UITableView``` to allow the user to search for specific terms.

Currently, the search function will show all item containing the given string either somewhere in the title, or merchant name.

