# Metron Demos 

Each demo is fully packages and can be installed with load-name.sh in each demo directory (cwd as the script path). run.sh where present will trigger dumping data for the data into its input directory.

The demo scripts use the Metron REST API to install configuration for each element of the use case. They also update elastic templates, and install any data generators in relevant paths under the path of the standard ssh user on the cluster (what you get if you just ssh without user)

TODO - There will be a demo script with each folder.
TODO - Currently demos cannot modify profile configuration, so demos involving profiles require some manual setup

The key locations should be in environment: 

```
export METRON_HOST=<my-metron-host>
export ES_URL=http://<elastic-master>:9200
export REST_URL=http://${METRON_HOST}:8082
```
