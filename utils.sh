#!/bin/bash

#
# Prints the given command, then executes it
#  Example: print_and_do_command echo 'hi'
#
function print_and_do_command {
	echo "-> $ $@"
	$@
}


#
# This one expects a string as it's input, and will eval it
# 
# Useful for piped commands like this: print_and_do_command_string "printf '%s' \"$filecont\" > \"$testfile_path\""
#  where calling print_and_do_command function would write the command itself into the file as well because
#  of the precedence order of the '>' operator
#
function print_and_do_command_string {
	echo "-> $ $1"
	eval "$1"
}

#
# Combination of print_and_do_command and error checking, exits if the command fails
#  Example: print_and_do_command_exit_on_error rm some/file/path
function print_and_do_command_exit_on_error {
	print_and_do_command $@
	if [ $? -ne 0 ]; then
		echo " [!] Failed!"
		exit 1
	fi
}

#
# Check the LAST COMMAND's result code and if it's not zero
#  then print the given error message and exit with the command's exit code
#
function fail_if_cmd_error {
	err_msg=$1
	last_cmd_result=$?
	if [ ${last_cmd_result} -ne 0 ]; then
		echo "${err_msg}"
		exit ${last_cmd_result}
	fi
}
# TEST/EXAMPLE:
# rm this/file/doesnt/exist
# fail_if_cmd_error "Could not delete the file"
