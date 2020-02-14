# Caffe

This is a proof of concept single-page application (SPA) developed to explore several technologies like Elixir, TypeScript, GraphQL and Docker; as well as some architectural patterns like Command Query Responsibility Segregation (CQRS) and Event Sourcing (ES)

[![Build Status](https://travis-ci.com/eeng/caffe.svg?branch=master)](https://travis-ci.com/eeng/caffe)

## The Domain

The business domain will consist of a café style restaurant.
Customers can browse the menu and then place orders for food and drinks. The chef prepares the meals and then the waitstaff serves them (drinks can be served immediately, though). In the end, the order must be paid with an optional tip.

## The Solution

Three subdomains were identified:

- **Ordering**: The order processing workflow is the core subdomain. It contains all the use cases necessary to fulfill the order: place order, mark food prepared, mark items prepared, pay order, etc. Each use case has its own authorization rules, e.g. customers should only be able to place orders (and view its own), only the chef (and the admin) would be able to mark food prepared, etc. This module was implemented with a [CQRS](https://martinfowler.com/bliki/CQRS.html)/[ES](https://martinfowler.com/eaaDev/EventSourcing.html) approach.

- **Menu**: Supporting subdomain that allows the admin to create, update and delete menu items. Implemented with a CRUD approach.

- **Accounts**: Supporting subdomain that deals with user accounts management and authentication. Only admins will be allowed to access this functionality.

Within each of these subdomains, an [use cases layer](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) (a.k.a. application service layer) contains all corresponding use cases using a [command processor](https://www.martinfowler.com/bliki/CommandOrientedInterface.html) pattern to handle common concerns like logging and authorization in a unified manner.

## The Stack

The application was split into a frontend and backend services, and GraphQL will facilitate the communication between the two. The following list shows all the key technologies used:

### Frontend

- It was developed in [TypeScript](https://www.typescriptlang.org/).
- [React](https://reactjs.org/) (with hooks) and [React Router](https://reacttraining.com/react-router/web/guides/quick-start) were used for the SPA implementation.
- [Apollo GraphQL](https://www.apollographql.com/docs/react/) allowed us to query the backend service.
- [Semantic UI React](https://react.semantic-ui.com/) simplified the UI design.

### Backend

- Programmed in [Elixir](https://elixir-lang.org/).
- [Phoenix](https://www.phoenixframework.org/) was used to host the GraphQL server and to aid in the persistence layer with [Ecto](https://hexdocs.pm/ecto/Ecto.html).
- With [Absinthe](http://absinthe-graphql.org/) we defined the GraphQL types and resolvers.
- [Commanded](https://github.com/commanded/commanded) for implementing the CQRS/ES pattern.
- [PostgreSQL](https://www.postgresql.org/) was the database used to persist the CRUD entities as well as the CQRS events and read models.

## The Demo

If you want to try the application the easiest way is with Docker. Make sure to have Docker Compose installed as well, clone this repo, head to the project folder and run:

```sh
make prod.start
```

Go grab a cup of coffee while Docker downloads and builds all the necessary images and, after a while, you should see the following messages in the log:

> Running frontend at ...

> Access CaffeWeb.Endpoint at ...

If that the case, you are good to go. Now, at this point the application is ready, but first, let's seed the database with some dummy data. In another terminal do:

```
make prod.seed
```

And now you are done. Head to http://localhost:4001 and you should see the login screen.
Sign in with email `admin@caffe.com` and password `secret`. In the [seeds.ex](backend/lib/caffe/support/seeds.ex) file you'll find other users credentials to enter with different roles.

## Contributing

I'm by no means an expert in any of the technologies used in this project, so feel free to share your thoughts, submit bug reports, pull requests, etc.

Some Makefile tasks are provided to start the application in development mode with all the necessary dependencies:

```
make dev.start
make dev.seed
```
