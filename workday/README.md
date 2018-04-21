# Work day simulation

A quick simulation of a working day for a bunch of users and servers. Fake users are created, some will make out of hours calls. The traffic will include logins, web requests and emails. 

The simulations rely heavily on the [faker](https://faker.readthedocs.io/en/latest/index.html) library. 

## Emails

Emails contain randomly generated text and some randomly inserted uris. 

## Web calls

To random external uris and ip addresses.

## Logins

From users to and internal ip address. The logins will have a low probability chance of failing. 
