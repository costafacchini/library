# README

## Requirements

```shell
  ruby 3.3.1
```

## Specifications

- [X] Authentication and Authorization
  - [X] Users should be able to register, log in, and log out
  - [X] Two types of users: Librarian and Member
  - [X] Only Librarian users should be able to add, edit, or delete books

- [X] Book Management
  - [X] Ability to add a new book with details like title, author, genre, ISBN, and total copies
  - [X] Ability to edit and delete book details
  - [X] Search functionality: Users should be able to search for a book by title, author, or genre

- [X] Borrowing and Returning
  - [X] Member users should be able to borrow a book if it's available. They can't borrow the same book multiple times
  - [X] The system should track when a book was borrowed and when it's due (2 weeks from the borrowing date)
  - [X] Librarian users can mark a book as returned

- [X] Dashboard
  - [X] Librarian: A dashboard showing:
    - [X] total books
    - [X] total borrowed books
    - [X] books due today (list)
    - [X] list of members with overdue books
  - [X] Member: A dashboard showing:
    - [X] books they've borrowed with their due dates
    - [X] any overdue books

- [ ] API Endpoints
  - [X] Develop a RESTful API that allows CRUD operations for books and borrowings
  - [X] Ensure proper status codes and responses for each endpoint
  - [X] Testing should be done with RSPEC (Spec files should be included for all the requirements above)

- [ ] Frontend (optional)
  - [ ] While the main focus is on Ruby on Rails, you can choose to integrate the backend with a frontend framework of your choice (React, Vue, etc.). The frontend should be responsive and user-friendly

## Setup Ruby (only if you have not installed)

This project uses [asdf](https://asdf-vm.com/guide/getting-started.html). \
Follow the installation [instructions](https://asdf-vm.com/guide/getting-started.html#_3-install-asdf)

After installation you need to follow these steps:

```bash
# Add ruby plugin on asdf
$ asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git

# Install ruby plugin
$ asdf install ruby 3.3.1
```

## Setup Project

```bash
# run setup script to initialize database and install dependencies
$ bin/setup

# run project
$ bin/rails s

# initialize the database with the seed data
$ bin/rails db:setup
```

## Tests

```bash
# run all specs and generate coverage files
$ bin/rspec

# run all specs without coverage files (run in this mode when you want to run faster and don't need to look at the coverage)
$ NO_COVERAGE=true bin/rspec
```

## Decisions

Considering that librarians work an 8-hour day without breaks, our authentication token for all types of users is valid for 8 hours.

After this time the user will need to authenticate again.

We will use the versioned API in case a modification occurs in the future that breaks the interface.

The dates for both borrow creation and return are being received by parameter because of the timezone issue. In my opinion, the backend should always work using dates in UTC, leaving the responsibility for the timezone with the presentation layer.

## Default credentials

<strong>email</strong>: `admin@test.com`

<strong>password</strong>: `12345678`

## API

First we need to know the URL the project is running at. The default is `http://localhost:3000/`

### Endpoint 1: /login
In the Header of the login response, there is the authorization field with the data to use our API

#### Params:
- `user` (required): user data to log in.
  - `email` (required): user mail.
  - `password` (required): password.

#### Exemplo de Requisição:
```json
POST /login

{
	"user": {
      "email": "admin@test.com",
      "password": "12345678"
	}
}
```

### Endpoint 2: /logout
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

#### Exemplo de Requisição:
```json
DELETE /logout
```

### Endpoint 3: /signup

#### Params:
- `user` (required): user data to create an user.
  - `name` (required): user name.
  - `email` (required): user mail.
  - `password` (required): password.

#### Exemplo de Requisição:
```json
POST /signup

{
	"user": {
      "name": "John Doe",
      "email": "john@doe.com",
      "password": "12345678"
	}
}
```

### Endpoint 4: /v1/users/:id
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows Librarians to promote Members to be Librarians.

#### Params:
- `user` (required): user data.
  - `role` (required): user role (librarian | member).

#### Exemplo de Requisição:
```json
PATCH /v1/users/:id

{
	"user": {
      "role": "librarian"
	}
}
```

### Endpoint 5: /v1/books
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows you to list all books in the library.

#### QueryParams:
- `expression` (optional): used to filter books.

#### Exemplo de Requisição:
```json
GET /v1/books?expression=development
```

### Endpoint 6: /v1/books/:id
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows you to show a specific book.

#### Exemplo de Requisição:
```json
GET /v1/books/:id
```

### Endpoint 7: /v1/books (librarians only)
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows you to create a new book.

#### Params:
- `book` (required): book data to create a book.
  - `title` (required): book title.
  - `author` (required): book author.
  - `genre` (required): book genre.
  - `isbn` (optional): book isbn.
  - `total_copies` (optional): total os copies.

#### Exemplo de Requisição:
```json
POST /v1/books

{
	"book": {
      "title": "IT",
      "author": "Stephen King",
      "genre": "Terror, Horror"
	}
}
```

### Endpoint 8: /v1/books/:id (librarians only)
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows you to update a specific book.

#### Params:
- `book` (required): book data to create a book.
  - `title` (required): book title.
  - `author` (required): book author.
  - `genre` (required): book genre.
  - `isbn` (optional): book isbn.
  - `total_copies` (optional): total os copies.

#### Exemplo de Requisição:
```json
PATCH /v1/books/:id

{
	"book": {
      "title": "IT",
      "author": "Stephen King",
      "genre": "Terror, Horror"
	}
}
```

### Endpoint 9: /v1/books/:id (librarians only)
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows you to destroy a specific book.

#### Exemplo de Requisição:
```json
DELETE /v1/books/:id
```




### Endpoint 10: /v1/borrows
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows you to create a new borrow.

#### Params:
- `borrow` (required): borrow data to create a borrow.
  - `book_id` (required): book to be borrowed.
  - `borrowed_at` (required): borrow date (UTC). `format: YYYY-MM-DD`

#### Exemplo de Requisição:
```json
POST /v1/borrow

{
	"borrow": {
      "book_id": 1,
      "borrowed_at": "2024-06-13",
	}
}
```

### Endpoint 11: /v1/borrows/:id
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

This endpoint allows you to return a book.

#### Params:
- `borrow` (required): book data to create a book.
  - `returned_at` (required): returned date (UTC). `format: YYYY-MM-DD`

#### Exemplo de Requisição:
```json
PATCH /v1/borrows/:id

{
	"borrow": {
      "returned_at": "2024-06-13"
	}
}
```

### Endpoint 12: /v1/dashboard
It is necessary to add the Authorization field in the header with the credentials you copied on the login endpoint.

#### Exemplo de Requisição:
```json
GET /v1/dashboard
```
