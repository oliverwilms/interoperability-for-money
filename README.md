# interoperability-for-money
This is my InterSystems IRIS Interoperability solution for InterSystems Interoperability Contest 2021. This is also my first time using Workflow.

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
There are two containers defined. Interoperability container portal can be found at http://localhost:52795/csp/sys/UtilHome.csp. 

If you are prompted to login, enter _SYSTEM and SYS

![screenshot](https://github.com/oliverwilms/bilder/blob/main/Interoperability_Workflow.JPG)

The Production has a File Service that reads any file in data directory. I included a sample file.

Analytics container can be found at http://localhost:32792/csp/sys/UtilHome.csp. Please note the password for _SYSTEM is abc123.

![screenshot](https://github.com/oliverwilms/bilder/blob/main/Analytics_SelectCount.PNG)

You can count the number of transaction in Analytics database by executing SELECT COUNT(*) FROM RICHES.TRANSACT.

Reset table to start fresh by executing query DELETE RICHES.TRANSACT

Read more about [Interoperability, RecordMap CSV Wizard, and Money](https://community.intersystems.com/post/interoperability-recordmap-csv-wizard-and-money)

I added Worflow. I edited my first BPL Process to send certain RecordMap records to Workflow process based on the Status field in each record. I added a Worflow Operation. I was happy to find a setting to Auto Create Role for me.
