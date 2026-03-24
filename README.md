# fastlane-docker
_A `Dockerfile` that is used on _fastlane_'s CIs for testing _fastlane_ on a Linux system with all dependencies._

### Tools included

- Ruby 3.3
- Python 3.8.13
- Java 21
- NodeJS 20
- Xar (for .pkg creation)

## Places being used

- [fastlane/docs](https://github.com/fastlane/docs/blob/master/.circleci/config.yml)
- [fastlane/fastlane](https://github.com/fastlane/fastlane/blob/master/.circleci/config.yml)

## Publishing

- Push a tag with the version you want to publish (`x.y.z`).
