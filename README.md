# SPA Tools

This repository is for testing Travis CI for uploading artifiacts.

The `travis.yml` uses the `addons.artifcat` declaration to copy the deploy
artifcats to AWS S3
[Documentation](https://docs.travis-ci.com/user/uploading-artifacts/).
This requires the `ARTIFACTS_KEY` and `ARTIFACTS_SECRET` environment
variables to be set in the Settings section of Travis (on `travis-ci.org`)
for this Github repository.

## Remark
All files in the `artifacts` directory will be uploaded to the directoy specified by `target_paths`
(sic!). The example `.travis.yml` sets `target_paths` to `$TRAVIS_BUILD_NUMBER`. When
dropping the `targe_paths` this defaults to `$GITHUB_NAME$REPOSITORY_NAME$TRAVIS_BUILD_NUMBER`.

## Resources
[Helpful linter for writing the `travis.yml`](https://lint.travis-ci.org/)
