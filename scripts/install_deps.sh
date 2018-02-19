#!/bin/bash

for repo in $(ls deps); do
  git clone https://github.com/jeremycloud/"$repo".git
done
