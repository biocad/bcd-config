# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0.6] - 2018-09-20
### Fixed
- Bugfix with imports

## [0.1.0.5] - 2018-09-20
### Added
- Field `databases` in Postgres config.

## [0.1.0.4] - 2018-04-25
### Changed
- Field `database` changed to `databases` in Mongo config.

## [0.1.0.3] - 2018-04-25
### Added
- Field `database` in Mongo config.

## [0.1.0.2] - 2018-03-19
### Added
- Data for `bio-sources` library.

## [0.1.0.1] - 2018-03-05
### Changed
- Class name for get config from JSON. Now it is `FromJsonConfig` with method `fromJsonConfig :: MonadIO m => m a`.

## [0.1.0.0] - 2018-01-22
### Added
- `GetConfig` class with method `getConfig`
- Instances for FileSystem, Mongo, Mysql, Neo4j, Postgres, Redis, Schrodinger
