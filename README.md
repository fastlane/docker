# fastlane-docker

A `Dockerfile` that is used on _fastlane_'s CIs which is configured for Ruby 2.6, Python 3.6.8, and Java 8.

## Publishing a new version

```
docker build -t fastlanetools/ci:x.y.z ./
docker push fastlanetools/ci:x.y.z
```
