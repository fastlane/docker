# fastlane-docker

A `Dockerfile` that is used on _fastlane_'s CIs which is configured for Ruby 2.7, Python 3.6.8, and Java 8.

This is built to be used on a CI (primarly CircleCI) when needing to either test _fastlane_ on a Linux CI or test and deploy _fastlane_ docs using Linux. Using this `Dockerfile` is the most effecient way of using the required Ruby, Python, and Java versions for each build and keeping it consistent.

## Places being used

- [fastlane/docs](https://github.com/fastlane/docs/blob/master/.circleci/config.yml)
- [fastlane/fastlane](https://github.com/fastlane/fastlane/blob/master/.circleci/config.yml)

## Publishing a new version

```
docker build -t fastlanetools/ci:x.y.z ./
docker push fastlanetools/ci:x.y.z
```
