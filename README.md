# sqlsqlsql
A small pet app that stores your pet info into local sqlite DB. The purpose of this app was to showcase my skills around cache, provider state managment and session handling using shared preferences.
This is offline first app means that user data is only stored on thier device and app cannot connect to the internet.

## Cache
To store & get user, pets data for storage
  - ### sqlite
    - provides user table and a pet table
    - user data helps to authenticate them later
    - pet are stored and feteched against currently logged in user
  - ### shared preferences
    - helps to maintain sessions
## Theme and language change
  - theme setting like system, dark, light provided for app globally
  - locale for Urdu (in 1.1)
## Provider
  - modifing app state from one place & handling important user & pet funtions.
## Screens


### This apps uses AI-Generated code
![1735932185246](https://github.com/user-attachments/assets/b43b8e52-25fc-4bf8-84e9-1de2ae44b9f3)
