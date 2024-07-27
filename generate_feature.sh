#!/bin/bash

cd lib || exit

cd features || exit

mkdir "$1"

cd "$1" || exit

mkdir data
cd data || exit 
mkdir datasources
mkdir models
mkdir repositories

cd ..

mkdir domain
cd domain || exit
mkdir entities
mkdir repositories
mkdir usecases

cd ..

mkdir presentation
cd presentation || exit
mkdir providers
mkdir pages
mkdir widgets
