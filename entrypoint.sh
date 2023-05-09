#!/bin/bash
/dspace/bin/dspace database migrate
/dspace/bin/dspace create-administrator -e "dspace@email.com" -f "dspace" -l "dspace" -c "pt-br" -p "dspacepass"
$@