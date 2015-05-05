TEST=$(ls -al .libs 2>&1 > /dev/null) #test for libs dir
if [ $? -eq 0 ]
then
  set -e
  echo "Downloading dependencies..."
  wget https://search.maven.org/remotecontent?filepath=com/google/guava/guava/18.0/guava-18.0.jar -O src/java/org/bitcoin/guava-18.0.jar -q
  cd src/java 
  LIBSDIR=`find ../../ -name .libs | tr '\n' ':'`
  #echo libsdir $LIBSDIR
  echo "Running JNI Suite..."
  if [ "x$HOST" = "xi686-linux-gnu" ]; then echo "****WARNING**** 32-bit HOSTS UNSUPPORTED, refusing to run JNI tests..." && exit 0; fi #then JAVACC="-d32"; fi <- correct way to handle
  javac -cp ".:org/bitcoin/guava-18.0.jar" org/bitcoin/NativeSecp256k1.java && javac -cp ".:org/bitcoin/guava-18.0.jar" org/bitcoin/NativeSecp256k1Test.java && java $JAVACC -Djava.library.path=$LIBSDIR -cp ".:org/bitcoin/guava-18.0.jar" org/bitcoin/NativeSecp256k1Test
  RUNNERCODE=$?
  cd ../../
  exit $?
else
  echo "****WARNING**** ".libs" DIR NOT FOUND, refusing to run JNI tests..."
  exit 0
fi
