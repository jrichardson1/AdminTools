#!/bin/bash
###############################################################################
# HadoopHealthCheck.sh                      Jeff Richardson            2/23/15
# Purpose:  Execute a quick health check of the Hadoop ecosystem.
# Minimum requirements come from "Hadoop The Definitive Guide 4th Edition",
# Chapter 10.
###############################################################################

#------------------------------------------------------------------------------
function checkJavaVersion()
{
  echo -e "\n-----------------------"
  echo -e "- Current Java version:"
  echo -e "-----------------------\n"
  java -version
  
  echo -e "\n------------------------"
  echo -e "- Current Java location:"
  echo -e "------------------------\n"
  echo $JAVA_HOME
  
} # end function checkJavaVersion()

#------------------------------------------------------------------------------
function checkHadoopEcosystemVersions()
{
  echo -e "\n-------------------------"
  echo -e "- Checking Hadoop ecosystem components' versions:"
  echo -e "-------------------------\n"
  hadoop version && echo -e "\n"  
  sqoop-version && echo -e "\n"  
  
  
} # end function checkHadoopEcosystemVersions()

#------------------------------------------------------------------------------
# Min = Two hex/octo-core 3 GHz CPUs for HDFS datanode or YARN node mgr
function checkProcessors()
{
  echo -e "\n-----------------------"
  echo -e "- Processor information:"
  echo -e "-----------------------\n"
  
  # This works for a single CPU VMware image...  Beef it up for SMP systems.
  grep ^processor /proc/cpuinfo
  grep "model name" /proc/cpuinfo
  grep MHz /proc/cpuinfo

} # end function checkProcessors()

#------------------------------------------------------------------------------
# Min = 64-512 GB ECC RAM for HDFS datanode or YARN node mgr
# Perform an additional check on swap. 
# Best practice: HDFS nodes should not swap.
# Check that the number of pages (or amount of data in bytes, whatever is easier)
# swapped in and out to disk, per second, does not exceed zero, or some very 
# small amount. This is not the same as monitoring the amount of swap space consumed.

function checkMemory()
{
  echo -e "\n-----------------------"
  echo -e "- Memory information:"
  echo -e "-----------------------\n"
  grep MemTotal /proc/meminfo
  grep MemFree /proc/meminfo
  grep SwapTotal /proc/meminfo
  grep SwapFree /proc/meminfo
  
} # end function checkMemory()

#------------------------------------------------------------------------------
# Min = 12-24 × 1-4 TB SATA disks for HDFS datanode or YARN node mgr
function checkStorage()
{
  echo -e "\n-----------------------"
  echo -e "- Storage information:"
  echo -e "-----------------------\n"

} # end function checkStorage()

#------------------------------------------------------------------------------
# Min = Gigabit Ethernet with link aggregation for HDFS datanode or YARN node mgr
function checkNetwork()
{
  echo -e "\n-----------------------"
  echo -e "- Network information:"
  echo -e "-----------------------\n"

} # end function checkNetwork()

#------------------------------------------------------------------------------
function checkDaemons()
{
  for i in hdfs yarn hbase mapred
  do
    echo -e "\n-----------------------"
    echo -e "- $i daemons:"
    echo -e "-----------------------\n"
    ps -ef | grep ^$i | awk '{print substr($9,3)}'
  done  

  for i in hive
  do
    echo -e "\n-----------------------"
    echo -e "- $i daemons:"
    echo -e "-----------------------\n"
    ps -ef | grep ^$i | awk '{print $24}'  
  done

  for i in hue
  do
    echo -e "\n-----------------------"
    echo -e "- $i daemons:"
    echo -e "-----------------------\n"
    ps -ef | grep ^$i | awk '{print substr($9,28)}'  
  done

  for i in impala
  do
    echo -e "\n-----------------------"
    echo -e "- $i daemons:"
    echo -e "-----------------------\n"
    ps -ef | grep ^$i | awk '{print substr($8,22)}'  
  done

  #cloudera

#httpfs
#ntp
#oozie
#rpc
#rtkit
#solr
#spark
#sqoop2
#flume  

 
} # end function checkDaemons()

#------------------------------------------------------------------------------
function checkInstalledPackages()
{
  tempFile='pkgList.txt'
  rpm -qa | sort >$tempFile

  echo -e "\n--------------------------"
  echo -e "Installed system services:"
  echo -e "--------------------------"
  for i in ntp openssh
  do
    echo -e "\nSearching for $i:"
    grep ^$i $tempFile
  done
  
  # Need to see if sshd is configured and running.

  
  echo -e "\n------------------------------------"
  echo -e "Installed Hadoop ecosystem packages:"
  echo -e "------------------------------------"
  for i in bigtop cloudera flume hadoop hbase hive hue impala mahout oozie parquet pig solr spark sqoop zookeeper
  do
    echo -e "\nSearching for $i:"
    grep ^$i $tempFile
  done

  echo -e "\n--------------------------------"
  echo -e "Installed programming languages:"
  echo -e "--------------------------------"
  for i in c++ perl python ruby java
  do
    echo -e "\nSearching for $i:"
    grep $i $tempFile
  done
  #java -version
  
  echo -e "\nSearching for groovy:"
  find / -name groovy* 2>/dev/null
  
  rm -f $tempFile
} # end function checkInstalledPackages()

#------------------------------------------------------------------------------
# Not yet implemented.
# Refer to Hadoop_Operations.pdf - /etc/sysctl.conf
function checkKernelParameters()
{
} # end function checkKernelParameters()

#------------------------------------------------------------------------------
# Not yet implemented.
# ensure datanode disks are not LVM, i.e. /dev/vg*
function checkDisks()
{
} # end function checkDisks()

#------------------------------------------------------------------------------
# Not yet implemented.
# should be ext3, ext4 of xfs. xfs might be viable but is it better suited for concurrent access?
# check for read/write nfs mount point for namenodes
function checkFileSystems()
{
} # end function checkFileSystems()

#------------------------------------------------------------------------------
# Not yet implemented.
# Refer to Hadoop_Operations.pdf
# This might be different for root/user installations.
# The mapreduce user should not have write permissions to the hadoop directory.
# Should this include not only Linux filesystems but the hdfs filesystems, too?
# If not, then I need a separate function for hdfs filesystems.
function checkDirectoryPermissions()
{
} # end function checkDirectoryPermissions()

#------------------------------------------------------------------------------
# Not yet implemented.
# OK, actually checking the network topology would be difficult but speed and errors can be checked.
# How do I check for rack awareness configuration?
# http://wiki.apache.org/hadoop/topology_rack_awareness_scripts
# Would I check connectivity to the slaves and other nodes here or in the security section?
# Are we using /etc/hosts entries or relying on nslookup type calls?
function checkNetwork()
{
} # end function checkNetwork()

#------------------------------------------------------------------------------
# Not yet implemented.
# review parameters in core-site.xml and hdfs-site.xml
function checkHDFSsettings()
{
} # end function checkHDFSsettings()

#------------------------------------------------------------------------------
# Not yet implemented.
# Groups, userids, ssh, allowed/disallowed nodes
function checkSecurity()
{
} # end function checkSecurity()

#------------------------------------------------------------------------------
# Not yet implemented.
function check()
{
} # end function check()

#------------------------------------------------------------------------------
# main code
#------------------------------------------------------------------------------

# Do I need to run whoami and ensure I have the correct permissions to run
# these functions?


# Change this to an if statement.  If a parameter or set of parameters is
# used then call those functions; otherwise, call all of the functions.

checkJavaVersion
checkHadoopEcosystemVersions
checkProcessors
checkMemory
checkStorage
checkNetwork
checkDaemons
checkInstalledPackages

#--------------
# To dos
#--------------

#checkKernelParameters 
#checkDisks
#checkFileSystems
#checkDirectoryPermissions
#checkNetwork
#checkHDFSsettings
#checkSecurity

echo -e "\n---------------------------------------"
echo -e "Script $0 complete."
echo -e "---------------------------------------\n"
