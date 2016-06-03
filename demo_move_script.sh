#!/bin/bash
# CM2.Network (c) 2016
# This bash script automatically MOVES!!! .dem files to the ftp server
# Note, that advanced checks are required to ensure we don't copy a demo that 
# isn't currently being written/recorded

# First make sure our directory exists, create it if not
ssh -p 5011 root@me2stats.eu "mkdir -p /etc/nginx/html/gotv/srv_ip/$SRCDS_IP/$SRCDS_PORT"

# Generate our super secret demo password
# Note: Leave this out if you want no password
RCONLETTER="$(echo $SRCDS_RCONPW | head -c 1)"
ZIPPW=$SRCDS_PW$RCONLETTER

# Demo suffix
SUFFIX="-CM2.Network"

# Infinite loop
while true
  do
    # Get the amount of .dem files in this directory to make sure there are any
    count=$(find . -maxdepth 1 -name '*.dem' | wc -l)
    if [ $count -ne 0 ]; then
      # Array index counter
      COUNTER=1
      
      # Iritate over all .dem files and get their sizes
      for demo in *.dem; do
        DEMO_SIZE[COUNTER]=$(wc -c <"$demo")
        COUNTER=$((COUNTER+1))
      done
      
      # Wait for 60 seconds
      sleep 60s
      # Get newest demo
      LATEST_DEM=$(ls -t -d *dem | head -1)
      # Reset array index counter
      COUNTER=1
      # Reiritate over all the .dem files and look if they still 
      # have the same size, if yes they are not being written
      # Also check the size and if it's bigger than 5MB 
      for demo in *.dem; do
        NEW_DEMO_SIZE=$(wc -c <"$demo")
        if [ $NEW_DEMO_SIZE -gt 5000000 ] && [ ${DEMO_SIZE[COUNTER]} -eq $NEW_DEMO_SIZE ]; then
          # demo is not being written to, move demo to sftp
          # If it's an auto demo then cut down the name to something more clear
          POSTFIX=${demo::-10}
          if [ "$POSTFIX" == "CM2Network" ]; then
            NEWDEMONAME=${demo::-11}
            NEWDEMONAME=$NEWDEMONAME$SUFFIX
          else
            NEWDEMONAME=$demo
            NEWDEMONAME=${demo::-4}
          fi
          zip --password $ZIPPW $NEWDEMONAME.zip $demo
          scp -P 5011 $NEWDEMONAME.zip root@me2stats.eu:/etc/nginx/html/gotv/srv_ip/$SRCDS_IP/$SRCDS_PORT/$NEWDEMONAME.zip
          rm -f $NEWDEMONAME.zip
          rm -f $demo
        elif [ $NEW_DEMO_SIZE -le 5000000 ] && [ "$demo" != "$LATEST_DEM" ]; then
          rm -f $demo
        fi
        COUNTER=$((COUNTER+1))
      done
    fi
    sleep 10s
done
