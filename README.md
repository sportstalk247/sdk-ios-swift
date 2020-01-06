# SportsTalk_iOS_SDK

The Sportstalk SDK is a helpful wrapper around the [Sportstalk API](https://apiref.sportstalk247.com/?version=latest#1b1b82a9-2b2f-4785-993b-baed6e7eba7b)

## Installation

Compile the sdk and drag drop the compiled framework file in the project.

## Usage

```python
import SportsTalk_iOS_SDK

let services = Services()
services.url = "https://www.sportstalk247.com/"
services.authToken = "YOUR_API_TOKEN"


Example 1:
let getUserDetail = UsersServices.GetUserDetails()
getUserDetail.userid = "6fcd90c495"

services.ams.usersServices(getUserDetail) { (response) in
      print(response)
}

Example 2:
let listUsers = UsersServices.ListUsers()
listUsers.limit = "20"

services.ams.usersServices(listUsers) { (response) in
     print(response)       
}
```

## Tests
To check the api's are working correctly run the tests already created for api's by following the below steps

```python
1. Open project in x-code
2. Select the test module from the activity scheme.
3. Run the tests
```


## Copyright & License
Copyright (c) 2019 Sportstalk247
