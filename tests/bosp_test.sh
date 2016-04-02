#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/../src/bosp.sh"

function check_yaml_parser() {
  declare -A parsed_yaml=()
  local parsed_yaml
  bosp::yaml::parse "./fixtures/test.yml" "parsed_yaml"

  assertion__equal "simple-value" "${parsed_yaml["simple"]}"
  assertion__equal "simple-with-space-value" "${parsed_yaml["simple-with-spaces"]}"
  assertion__equal "Newline\nText with lines" "${parsed_yaml["newline"]}"
  assertion__equal "Newline folded Text with lines" "${parsed_yaml["newline-folded"]}"

  local parent_children=( $(bosp::get_children "parsed_yaml" "parent") )

  assertion__array_contains "child" "${parent_children[@]}"
  assertion__array_contains "child-with-spaces" "${parent_children[@]}"

  assertion__equal "child-value" "${parsed_yaml["parent:child"]}"
  assertion__equal "child-with-spaces-value" "${parsed_yaml["parent:child-with-spaces"]}"

  local list_children=( $(bosp::get_children "parsed_yaml" "list") )

  assertion__array_contains "[0]" "${list_children[@]}"
  assertion__array_contains "[1]" "${list_children[@]}"

  assertion__equal "Element" "${parsed_yaml["list:[0]"]}"
  assertion__equal "Element with spaces" "${parsed_yaml["list:[1]"]}"

  local array_list_children=( $(bosp::get_children "parsed_yaml" "array-list") )

  assertion__array_contains "[0]" "${array_list_children[@]}"
  assertion__array_contains "[1]" "${array_list_children[@]}"

  assertion__equal "array-element" "${parsed_yaml["array-list:[0]"]}"
  assertion__equal "Array element with spaces" "${parsed_yaml["array-list:[1]"]}"

  local associative_array_children=( $(bosp::get_children "parsed_yaml" "associative-array") )

  assertion__array_contains "key1" "${associative_array_children[@]}"
  assertion__array_contains "key2" "${associative_array_children[@]}"

  assertion__equal "key1-value" "${parsed_yaml["associative-array:key1"]}"
  assertion__equal "key2-value with space" "${parsed_yaml["associative-array:key2"]}"
}