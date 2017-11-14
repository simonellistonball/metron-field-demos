# Auth Demo

This demo shows the use of profiles to detect unusual login behavior. Specifically, it detects that a user has logged onto an unusual number of hosts within a given time period.

## Building
Note that the loader depends on Metron components which are not published to Maven central, so you will need to run mvn install from a local metron tree to build the loader on your machine. 
