# Shopping List - SMB mini project 1
Mobile application created for SMB school subject.

Main module of the application is a shopping list.
Attributes of products are: name, quantity and price.

Products are stored in local SQLite database.

Using UserDefaults, application provides ability to:
- Change bisibility of prica and quantity
- Change displayed currency

# SMB mini project 3
SQLite database removed.
Added Firebase realtime database and user authentication.
Products have now new attribute userOwnerId that indicates who created the product. If null, the product is public.
