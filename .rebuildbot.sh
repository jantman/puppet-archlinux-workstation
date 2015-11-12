#!/bin/bash -ex

rvm use $(cat .ruby-version)
which ruby
ruby -v
bundle install --path vendor
bundle exec rake beaker
