#!/usr/bin/env bats

load test_helper

source kingirak.sh

@test "Must resolv localhost" {
	run resolv localhost
	[[ "$output" == "127.0.0.1" ]]
}