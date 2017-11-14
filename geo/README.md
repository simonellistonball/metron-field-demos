# Geohash Demo

This demo uses the geohash feature of stellar and the profiler to identify improbable login events. 

We have a data generator which simulates two users login in from reasonably close IP addresses, and then a poison script which logs one of them in from another country.

The story for this feature is that we can build up a personalised picture of a user. Say they commute from London to North Essex everyday and log in from those locations, they will establish a centroid in their profile. 
