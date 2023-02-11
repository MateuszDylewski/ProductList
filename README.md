# SMB mini project 1 - end result in branch SQLite
Mobile application created for SMB school subject.

Main module of the application is a shopping list.
Attributes of products are: name, quantity and price.

Products are stored in local SQLite database.

Using UserDefaults, application provides ability to:
- Change bisibility of prica and quantity
- Change displayed currency

# SMB mini project 3 - end result in branch Firebase
SQLite database removed.

Added Firebase realtime database and user authentication.
![Simulator Screen Shot - iPhone 14 Pro - 2023-02-11 at 01 41 38](https://user-images.githubusercontent.com/49963924/218227772-b7f0255b-c507-4158-a7b3-d73fe2a973e4.png)

Product has now a type. It's either public or private.


# SMB mini project 4 - end result in branch MapModule
Added new module called Map.

Map stores information about favourite shops and shows thei location.

Shops are added based on user's current location.

Module require notification and location permissions.

Each time user enters or exits shop's location (+/- range) a notification is sent.
