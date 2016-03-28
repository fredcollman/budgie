#!/bin/sh
rm /tmp/.zeus.sock || true
ZEUSSOCK=/tmp/.zeus.sock RAILS_TEST_HELPER=rails_helper bundler exec guard

