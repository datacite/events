# DataCite Events Service

[![Coverage Status](https://coveralls.io/repos/github/datacite/events/badge.svg?branch=main)](https://coveralls.io/github/datacite/events?branch=main)

This is the code repository for the DataCite Events REST API.

### Process Flow Diagram

![Event Service Process Flow Diagram](images/events_service_process_flow.jpg)

### Dependencies

Local application development is dependent on [Docker](https://www.docker.com/). Ensure that is installed locally.

Local application development is dependent on [DataCite LocalStack Repository](https://github.com/datacite/datacite_localstack). Ensure that this is cloned locally.

Local application development is dependent on [Lupo](https://github.com/datacite/lupo). Ensure this is cloned locally.

### How to run the application

#### Step 1

Start the DataCite Localstack Container.
`docker compose up --build`

#### Step 2

Start the Lupo Container.
`docker compose -f ./docker-compose.localstack.yml up --build`

#### Step 3

Start the Events Service Container.
`docker compose up --build`

### Where is the Events Service API available?

The API is available locally at http://localhost:8700

### Where is the database?

Currently the database and it's schema is managed by the Lupo application.
The Events Service simply communicates with this database.
The Events services does not own any part of the database and is not responsible for mutating the schema.
For local and testing purposes we use the [activerecord-nulldb-adapter](https://github.com/nulldb/nulldb) Ruby Gem.

### Adding new Shoryuken workers

1. Add workers to the app/workers directory
2. Ensure you set the shoryuken_options e.g. `shoryuken_options queue: -> { "#{ENV['RAILS_ENV']}\_events" }, auto_delete: true`
3. Queues use environment prefixes. The prefix is set with the environment variable RAILS_ENV locally.

### Starting the Shoryuken workers

1. Workers are spun up by default on app start.
2. The environment variable DISABLE_QUEUE_WORKER is used in development to switch the worker on or off when you start the container.
3. The DISABLE_QUEUE_WORKER is set to false by defalt in the docker-compose.yml i.e. DISABLE_QUEUE_WORKER=false
4. If you you want to disable the queue workers from starting up you can set DISABLE_QUEUE_WORKER to true i.e. DISABLE_QUEUE_WORKER=true
