#!/bin/bash
#
# Modest suite of tests. To be completed.
#
# -- daniperez
#
NODEJS_VERSION="0.8.9"

testVersionMatches ()
{
  SCRIPT_NODE_VERSION="$(cat node-wrapper|grep NODEJS_VERSION=| sed 's/NODEJS_VERSION="\(.*\)"/\1/')"

  test $NODEJS_VERSION == $SCRIPT_NODE_VERSION

  result=$?

  echo "testVersionMatches: $result"

  return $((result))
}

testHelp ()
{
  ./node-wrapper |& grep "Usage" > /dev/null 2>&1
 
  result=$?
  
  echo "testHelp: $result"

  return $((result))
}

testUrls ()
{
  ARCH="86 64"
  OS="linux darwin"

  for _ARCH_ in $ARCH
  do
    for _OS_ in $OS
    do
      NODEJS_URL="http://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-$_OS_-x$_ARCH_.tar.gz"

      wget -q --spider $NODEJS_URL

      if [ "x$?" == "x0" ]; then
        echo "testUrls($NODEJS_URL): $?"
      else
        result=$?
        echo "testUrls($NODEJS_URL): $result"
        return $?
      fi
    done
  done

  return "0"
}

testGrunt()
{
  ./node-wrapper grunt --version | grep "grunt v" > /dev/null 

  result=$?

  echo "testGrunt: $result"

  return $((result))
}

testVersionMatches
testHelp
testUrls
testGrunt
