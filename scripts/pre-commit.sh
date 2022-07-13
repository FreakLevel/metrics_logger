#!/bin/sh
#
# .git/hook/pre-commit
# Check for ruby style errors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
NC='\033[0m'

if git rev-parse --verify HEAD >/dev/null 2>&1
then
	against=HEAD
else
	# Initial commit: diff against an empty tree object
	# Change it to match your initial commit sha
	against=7df870e11cc7e82baf378f9f3a0111567ad62e9d
fi

# Check if rubocop is installed for the current project
rubocop -v >/dev/null 2>&1 || { echo >&2 "${red}[Ruby Style][Fatal]: Add rubocop to your Gemfile"; exit 1; }

# Get only the staged files
FILES="$(git diff --cached --name-only --diff-filter=AMC | grep "\.rb$" | tr '\n' ' ')"

# echo "${green}[Ruby Style][Info]: Checking Ruby Style${NC}"

if [ -n "$FILES" ]
then
	# echo "${green}[Ruby Style][Info]: ${FILES}${NC}"

	if [ ! -f '.rubocop.yml' ]; then
	  echo "${yellow}[Ruby Style][Warning]: No .rubocop.yml config file.${NC}"
	fi

	# Run rubocop on the staged files
	rubocop ${FILES}

	if [ $? -ne 0 ]; then
	  echo "${red}[Ruby Style][Error]: Fix the issues and commit again${NC}"
	  exit 1
	fi
else
	echo "${green}[Ruby Style][Info]: No files to check${NC}"
fi

exit 0
