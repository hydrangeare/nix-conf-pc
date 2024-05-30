#! /usr/bin/env bash

id=$(pgrep waybar)

if [ -n "$id" ]; then
	kill -9 $id
	waybar &
else
	waybar &
fi
