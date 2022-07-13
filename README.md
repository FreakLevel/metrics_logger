# Metrics Logger [![CodeFactor](https://www.codefactor.io/repository/github/freaklevel/metrics_logger/badge)](https://www.codefactor.io/repository/github/freaklevel/metrics_logger)

# Content
1. [Heroku](#heroku)
1. [Dependencies](#dependencies)
1. [How to run it](#how-to-run-it)
1. [Improvements](#improvements)

## Heroku
[Heroku Link](https://metricslogger.herokuapp.com/)

## Dependencies
|Tool|Version|
|---|---|
|Ruby|3.1.2|
|Rails|7.0.3|
|Node|16.3.0|

## How to run it

Create an `application.yml` file into `config` folder to add env variables:
```
DB_HOST:
DB_USERNAME:
DB_PASSWORD:
```
Create the database with rails command and run the little seed (if you want) to have data.

Run the backend and frontend in different terminals:
```
rails s
```
```
./bin/vite dev
```

## Improvements
- Cache for requests
- Auto-reload if a new metric is added to every client connected
- Improve UI/UX
- Add linter and test to frontend
- Improve docker-compose
