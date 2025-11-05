#!/bin/bash
set -e
echo "Building Java app"
mvn -B -DskipTests=false clean package
