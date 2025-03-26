# sqlsqlsql

  ![sqlite](https://github.com/user-attachments/assets/c4188bc4-0f67-4deb-af8e-a6c5e57151ba)

A small pet app that stores your pet info into local sqlite DB. The purpose of this app was to showcase my skills around cache, provider state management and session handling using shared preferences.
This is offline first app means that user data is only stored on their device and app cannot connect to the internet.

## Lifecycle for v1.0
  - ### Authentication
    First offline account is created by user. At account creation app asks user for their photo, email, name and password and all these fields should be valid. After that user have to login that account. if credentials match in DB then
    user is navigated to home screen and a session is created. A session doesn't expire on its own, it only do so when user logs out from app or clear app data.
  - ### Adding a Pet
    By clicking '+' button on bottom right of the home screen or top right of the allpets screen user can add a pet. App asks users for their pet photo, name, tagline, age and type. After pet is added it shows on home screen and allpets
    screen.
  - ### Pet modification
    From Single Petview user can edit , make a pet their favorite. To delete a pet user has to long press on ListTile and then a popups shows which tells user to either delete or edit specfic pet.

## Functions for v1.0
## Cache
To store & get user, pets data for storage
  - ### sqlite
    - provides user table and a pet table
    - user data helps to authenticate them later
    - pet are stored and fetched against currently logged in user
  - ### shared preferences
    - helps to maintain sessions
## Theme and language change
  - theme setting like system, dark, light provided for app globally
  - locale for Urdu (in 1.1)
## Provider
  - modifing app state from one place & handling important user & pet functions.
## Screens

![1](https://github.com/user-attachments/assets/9beb014e-e831-4773-bceb-eb38eeb9ba69)

![2](https://github.com/user-attachments/assets/1f49cb74-f9e8-469d-ad6c-008842f99a16)

![2-error](https://github.com/user-attachments/assets/1596e5a9-8d93-44da-a978-c51dea89d8a6)

![3](https://github.com/user-attachments/assets/81518f72-8c14-45e4-9bcf-418dd463f1c7)

![4](https://github.com/user-attachments/assets/3ef139ae-b187-43b6-a902-b85cbba9a8c0)

![5](https://github.com/user-attachments/assets/038797ee-b055-436e-970f-f1406e328e12)

![6](https://github.com/user-attachments/assets/94a3aff2-dade-4e08-a0c5-45166e16df7f)

![7](https://github.com/user-attachments/assets/2b68170b-f373-44e8-9697-6862c339af73)

![8](https://github.com/user-attachments/assets/2b0db932-21a4-4481-a26f-2f8c3d42e405)

![9](https://github.com/user-attachments/assets/45e9912e-2985-4e0d-9be3-bcbb8dfff960)

![10](https://github.com/user-attachments/assets/cbc69f17-d809-4d32-a4d1-14257b4165bd)

![11](https://github.com/user-attachments/assets/357c5f89-4240-4e37-b6f9-7daad8ac3f05)

![12](https://github.com/user-attachments/assets/950540d0-2b0e-4df7-adbd-b2fa5f3f739c)

![13](https://github.com/user-attachments/assets/bea1f871-0204-48fa-a6d3-e7324285dbe2)


### This app uses AI-Generated code
![1735932185246](https://github.com/user-attachments/assets/b43b8e52-25fc-4bf8-84e9-1de2ae44b9f3)
