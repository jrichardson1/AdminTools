#!/bin/bash
#set -x
###############################################################################
# makeCLIrefDocs.sh       Jeff Richardson          2/24/15
# Create command line reference documents.        
###############################################################################

#------------------------------------------------------------------------------
function createHadoopCLIRef()
{
  echo -e "Creating Hadoop Command Line Reference.\n.\c"
  echo -e "This document was created with the 'hadoop fs -help' command.\n\n" >HadoopCommandLineReference.txt
  hadoop fs -help >>HadoopCommandLineReference.txt
  chmod 664 HadoopCommandLineReference.txt
  echo -e ".."
} # end function createHadoopCLIRef

#------------------------------------------------------------------------------
function createHDFSCLIRef()
{
  echo -e "Creating HDFS Command Line Reference."
  echo -e "This document was created with the 'hdfs -help' and 'hdfs <option> -help' commands.\n\n" >HDFSCommandLineReference.txt
  hdfs -help >>HDFSCommandLineReference.txt
  hdfs -help >HDFSCommandLineReference.tmp
  chmod 664 HDFSCommandLineReference.*

  for i in `awk '{if (NR > 2) print $1}' HDFSCommandLineReference.tmp | sort | uniq`
  do
    if ([[ $i != 'current' ]] && [[ $i != 'Use' ]] && [[ $i != 'Most' ]])
    then
      echo -e ".\c"
      echo -e "\n-------------------------------------------------------------------------------\n" >>HDFSCommandLineReference.txt
      echo -e $i":\n" >>HDFSCommandLineReference.txt
	  if ([[ $i == 'journalnode' ]] || [[ $i == 'portmap' ]] || [[ $i == 'nfs3' ]])
      then
	    echo -e "WARNING: The -help option does not work with this hdfs option." >>HDFSCommandLineReference.txt
	    echo -e "Running hdfs with this option shuts down or starts the option/service." >>HDFSCommandLineReference.txt
	  else
        # These write to stderr
        if ([[ $i == 'cacheadmin' ]] || [[ $i == 'crypto' ]] || [[ $i == 'lsSnapshottableDir' ]] || [[ $i == 'snapshotDiff' ]])
	    then
          hdfs $i -help >>HDFSCommandLineReference.txt 2>&1
        else	
          hdfs $i -help 2>/dev/null >>HDFSCommandLineReference.txt
	    fi # end if cacheadmin, etc.
	  fi # end if journaldone, etc.
    fi # end if current, etc.
  done # end for i do
  rm HDFSCommandLineReference.tmp
  echo -e ""
} # end function createHDFSCLIRef

#------------------------------------------------------------------------------
function createSqoopCLIRef()
{
  referenceFile='SqoopCommandLineReference.txt'
  tmpFile='SqoopCommandLineReference.tmp'
  echo -e "Creating Sqoop Command Line Reference."
  echo -e "This document was created with the 'sqoop help' and 'sqoop <option> --help' commands.\n\n" >$referenceFile
  sqoop help >>$referenceFile 2>/dev/null
  sqoop help >$tmpFile 2>/dev/null
  chmod 664 $referenceFile

  for i in `awk '{if (NR > 5) print $1}' $tmpFile | sort | uniq`
  do
    if ([[ $i != 'help' ]] && [[ $i != 'See' ]])
    then
      echo -e ".\c"
      echo -e "\n-------------------------------------------------------------------------------\n" >>$referenceFile
      echo -e $i":\n" >>$referenceFile
	  if ([[ $i == 'metastore' ]])
      then
	    echo -e "WARNING: The --help option does not work with this sqoop option." >>$referenceFile
	    echo -e "Running sqoop with this option starts the option/service." >>$referenceFile
	  else
	    if ([[ $i == 'list-databases' ]])
	    then
	      echo -e "WARNING: The list-databases option does appear to have been implemented yet." >>$referenceFile
	      echo -e "Running sqoop with this option returns this information:" >>$referenceFile
		  echo -e "\tGeneric SqlManager.listDatabases() not implemented." >>$referenceFile
		fi # end if list-databases
        sqoop $i --help >>$referenceFile 2>&1
	  fi # end if metastore else
    fi # end if help, etc.
  done # end for i do
  rm $tmpFile
  echo -e ""
} # end function createSqoopCLIRef

#------------------------------------------------------------------------------
# Note: the hive command actually starts the cli and hiveserver2 services.
# They write an error message but it does not go to stdout or stderr so the
# messages are written to the screen.  I don't attempt to clean that up.
# I don't use the 'hive -help' command.  It provides the same info as the CLI service.
function createHiveCLIRef()
{
  referenceFile='HiveCommandLineReference.txt'
  tmpFile='HiveCommandLineReference.tmp'
  echo -e "Creating Hive Command Line Reference."
  echo -e "This document was created with the 'hive --help' and 'hive --service <serviceName> --help' commands.\n\n" >$referenceFile
  hive --help >>$referenceFile 2>/dev/null
  hive --help >$tmpFile 2>/dev/null
  chmod 664 $referenceFile
  
  ((serviceCount=0))
  for i in `grep ^Service $tmpFile`
  do
    ((serviceCount+=1))
	# Skip the first two strings - "Service List:"
	if (((serviceCount > 2)) && [[ $i != 'help' ]])
	then
      echo -e ".\c"
      echo -e "\n-------------------------------------------------------------------------------\n" >>$referenceFile
      echo -e $i":\n" >>$referenceFile
      if ([[ $i == 'cli' ]] || [[ $i == 'hiveserver2' ]])
	  then
        echo -e "This message is not captured by the script, inserting it here programmatically:" >>$referenceFile
	    echo -e "DEPRECATED: Configuration property hive.metastore.local no longer has any effect. Make sure to provide a valid value for hive.metastore.uris if you are connecting to a remote metastore." >>$referenceFile
	  fi # end if cli or hiveserver2
      if [[ $i == 'hiveserver2' ]]
	  then
        echo -e "This message is not captured by the script, inserting it here programmatically:" >>$referenceFile
	    echo -e "Error starting HiveServer2 with given arguments" >>$referenceFile
	  fi # end if hiveserver2
      hive --service $i --help 2>&1 >>$referenceFile  
    fi # end if serviceCount
  done # end for i do

  rm $tmpFile
  echo -e ""
  
} # end function createHiveCLIRef

#------------------------------------------------------------------------------
function createYARNCLIRef()
{
  referenceFile='YARNCommandLineReference.txt'
  echo -e "Creating YARN Command Line Reference."
  echo -e "This document was created with the 'yarn -help' and 'yarn <option>' commands.\n\n" >$referenceFile
  yarn -help >>$referenceFile 2>/dev/null

  # Do not ask for help for these options: resourcemanager, nodemanager, 
  # These don't provide any extra help: classpath, CLASSNAME
  # These seem to give meaningful information:
  # application, rmadmin (more options), jar, node, logs, daemonlog
  
  for i in application daemonlog jar logs node
  do
    echo -e ".\c"
    echo -e "\n-------------------------------------------------------------------------------\n" >>$referenceFile
    echo -e "yarn $i:\n" >>$referenceFile
    yarn $i >>$referenceFile 2>&1 >>$referenceFile
  done # for i	  

  # yarn rmadmin has more options
  echo -e ".\c"
  echo -e "\n-------------------------------------------------------------------------------\n" >>$referenceFile
  echo -e "yarn rmadmin:\n" >>$referenceFile
  yarn rmadmin -help >>$referenceFile 2>&1 >>$referenceFile

  echo -e ""
  
} # end function createYARNCLIRef

#------------------------------------------------------------------------------
function createFlumeCLIRef()
{
  referenceFile='FlumeCommandLineReference.txt'
  tmpFile='FlumeCommandLineReference.tmp'
  echo -e "Creating Flume Command Line Reference."
  echo -e "This document was created with the 'flume -help' and 'flume <option> -help' commands.\n\n" >$referenceFile
  flume help >>$referenceFile 2>/dev/null
  flume help >$tmpFile 2>/dev/null
  chmod 664 $referenceFile

} # end function createFlumeCLIRef

#------------------------------------------------------------------------------
# Note: hbase -help does not work, use hbase with no parameters
function createHBaseCLIRef()
{
  referenceFile='HBaseCommandLineReference.txt'
  tmpFile='HBaseCommandLineReference.tmp'
  echo -e "Creating HBase Command Line Reference."
  echo -e "This document was created with the 'hbase' and 'hbase <option> -help' commands.\n\n" >$referenceFile
  hbase help >>$referenceFile 2>/dev/null
  hbase help >$tmpFile 2>/dev/null
  chmod 664 $referenceFile

} # end function createHBaseCLIRef
###############################################################################
#createHadoopCLIRef
#createHDFSCLIRef
#createSqoopCLIRef
#createHiveCLIRef
createYARNCLIRef

#------------
# to dos
#createFlumeCLIRef
#createHBaseCLIRef
#add a function to catch traps
