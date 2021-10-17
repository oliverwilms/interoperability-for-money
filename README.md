# interoperability-for-money
This is my InterSystems IRIS Interoperability solution for InterSystems Interoperability Contest 2021.

## Installation 

### ZPM
It's packaged with ZPM so it could be installed as:
```
zpm "install interoperability-for-money"
```
then open http://localhost:52795/csp/sys/UtilHome.csp


### Docker
The repo is dockerised so you can clone/git pull the repo into any local directory

```
$ git clone https://github.com/oliverwilms/interoperability-for-money.git
```

The Interoperability Production is intended to send messages to my Analytics solution from the previous contest. Please clone/git pull its repo

```
$ git clone https://github.com/oliverwilms/iris-analytics.git
```

Navigate to interoperability-for-money directory and start the application using docker-compose

```
$ cd interoperability-for-money
$ docker-compose up -d
```
There are two containers defined. Interoperability container portal can be found at http://localhost:52795/csp/sys/UtilHome.csp. Analytics container can be found at http://localhost:32792/csp/sys/UtilHome.csp.

Count Transactions in analytics container:

SELECT COUNT(*) FROM RICHES.TRANSACT

Reset table before processing a new file:

DELETE RICHES.TRANSACT
