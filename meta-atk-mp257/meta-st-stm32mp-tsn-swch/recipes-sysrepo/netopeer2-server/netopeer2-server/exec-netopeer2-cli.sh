#!/bin/bash -

LOCAL_PATH=$(dirname $BASH_SOURCE)
echo "$LOCAL_PATH"

export LD_LIBRARY_PATH=$LOCAL_PATH/lib:$LD_LIBRARY_PATH
export LIBYANG_EXTENSIONS_PLUGINS_DIR=$LOCAL_PATH/lib/libyang/extensions/
export LIBYANG_USER_TYPES_PLUGINS_DIR=$LOCAL_PATH/lib/libyang/user_types/
# to be executed on Ubuntu 24.04 (or others, you need to adapt the execution line
# by adding the interpreter used by your system: /lib64/ld-linux-x86-64.so.2
# for Ubuntu 24.04: /lib64/ld-linux-x86-64.so.2 $LOCAL_PATH/bin/netopeer2-cli
# for Ubuntu 22.04: /lib64/ld-linux-x86-64.so.2 $LOCAL_PATH/bin/netopeer2-cli
/lib64/ld-linux-x86-64.so.2 $LOCAL_PATH/bin/netopeer2-cli
