#!/bin/bash -e

# BEGIN TIMEOUT #
TIMEOUT=4200
BOSSPID=$$
(
  sleep $TIMEOUT
  echo
  echo "Test timed out after $TIMEOUT seconds."
  echo
  kill -9 $BOSSPID
)&
TIMERPID=$!
echo "PIDs: Boss: $BOSSPID, Timer: $TIMERPID"

trap "echo killing timer ; kill -9 $TIMERPID" EXIT
# END TIMEOUT #

if which ant ; then
  echo -n
else
  if [ -e /etc/profile.d/ant.sh ] ; then
    . /etc/profile.d/ant.sh
  else
    echo Apache ANT is missing!
    exit 2
  fi
fi
ant -version

if [ -e /usr/local/jruby ] ; then
  export JRUBY_HOME=/usr/local/jruby
  CUSTOM_JRUBY_SET=yes
elif [ -e /Library/Frameworks/JRuby.framework/Versions/Current ] ; then
  export JRUBY_HOME=/Library/Frameworks/JRuby.framework/Versions/Current
  CUSTOM_JRUBY_SET=yes
fi

if [ "$CUSTOM_JRUBY_SET" == "yes" ] ; then
  export PATH=$JRUBY_HOME/bin:$JRUBY_HOME/lib/ruby/gems/*/bin:$PATH
  jruby --version
fi

rake platform:clean
rake test --trace
