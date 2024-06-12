# README

## Requirements

```shell
  ruby 3.3.1
```

## Specifications

- [ ] Authentication and Authorization
  - [X] Users should be able to register, log in, and log out
  - [ ] Two types of users: Librarian and Member
  - [ ] Only Librarian users should be able to add, edit, or delete books

- [ ] Book Management
  - [ ] Ability to add a new book with details like title, author, genre, ISBN, and total copies
  - [ ] Ability to edit and delete book details
  - [ ] Search functionality: Users should be able to search for a book by title, author, or genre

- [ ] Borrowing and Returning
  - [ ] Member users should be able to borrow a book if it's available. They can't borrow the same book multiple times
  - [ ] The system should track when a book was borrowed and when it's due (2 weeks from the borrowing date)
  - [ ] Librarian users can mark a book as returned

- [ ] Dashboard
  - [ ] Librarian: A dashboard showing:
    - [ ] total books
    - [ ] total borrowed books
    - [ ] books due today
    - [ ] list of members with overdue books
  - [ ] Member: A dashboard showing:
    - [ ] books they've borrowed with their due dates
    - [ ] any overdue books

- [ ] API Endpoints
  - [ ] Develop a RESTful API that allows CRUD operations for books and borrowings
  - [ ] Ensure proper status codes and responses for each endpoint
  - [ ] Testing should be done with RSPEC (Spec files should be included for all the requirements above)

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

## Default credentials

<strong>email</strong>: `admin@test.com`

<strong>password</strong>: `12345678`
