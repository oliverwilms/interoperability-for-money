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

SELECT COUNT(*) FROM RICHES.TRANSACT

DELETE RICHES.TRANSACT


Challenge

AutoStart

docker exec -it interoperability-for-money_iris_1 bash
irisowner@interoperability:/opt/irisapp$ iris restart iris
Starting IRIS
Starting Control Process
Automatically configuring buffers
Allocated 285MB shared memory: 122MB global buffers, 35MB routine buffers
This copy of InterSystems IRIS has been licensed for use exclusively by:
InterSystems IRIS Community
Copyright (c) 1986-2020 by InterSystems Corporation
Any other use is a violation of your license agreement
20211017 02:32:41.134 : 1047 : ZSTU LocalHostName = interoperability
20211017 02:32:41.134 : 1047 : ZSTU IRIS_MIRROR_ROLE =

02:32:41.414:Ens.Director: Production 'Oliver.Money.Production' starting...
02:32:41.520:Ens.Director: Production 'Oliver.Money.Production' started.
irisowner@interoperability:/opt/irisapp$
