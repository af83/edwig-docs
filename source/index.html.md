---
title: API Reference

language_tabs:
  - shell

search: true
---

#Introduction

First of all, to begin using Edwig, you'll have to clone the following repository:
- [https://github.com/af83/edwig](https://github.com/af83/edwig)

In this documentation, we'll see how Edwig works by detailing, step by step, each one of the following topics:

1. Referential 
2. Partner 
3. Line 
4. StopArea 
5. StopVisit 
6. VehicleJourney 
7. Gestion du Modele 
8. SIRI 











# 1. Referential

A Referential allows us to put apart many networks into a same server.

##Edwig manages Referentials.

A Referential is composed by:

* a uuid 
* a slug 
* a Partner list
* a collect manager
* a diffusion manager
* a model representing the transport network (StopAreas, Lines, ...)

##Create a Referential

While creating a Referential, we have to indicate a **slug**.

A Referential owns a uuid set by Edwig.
No Partner nor data into the model (StopAreas, Lines, etc...) are defined by default.
Collect and diffusion managers are created and ready to use.

**Create a Referential**

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Slug": "test"
  }

  EOF
```

POST /_referentials

##Modify a Referential

We have to indicate the **Referential's ID (into the URL)**.

**Modify a Referential:**


```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Slug": "another_test"
  }

```

PUT /_referentials/:uuid { "Slug": "another_test" }

##Delete a Referential

We have to indicate the **Referential's ID (into the URL)**.

The Referential and associated elements (Partners, managers, models) will be destroyed.

**Delete a Referential**

DELETE /_referentials/:uuid

##Consult Available Referentials

We can consult the informations about one or all Edwig's Referentials:

**Consult one Referential**

>For one Referential:
```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Id": "6ba7b814-9dad-11d1-0000-00c04fd430c8",
    "Partners": [      
      "e035bff4-6712-4589-821c-df599237b5ff"      
    ],      
    "Slug": "referential"      
  }

  EOF
```

GET /_referentials/:uuid

**Consult all Referentials:**  

>For all Referentials:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [    
    {      
      "Id": "6ba7b814-9dad-11d1-0000-00c04fd430c8",      
      "Partners": [       
        "e035bff4-6712-4589-821c-df599237b5ff"      
      ],         
      "Slug": "referential"      
    },       
    {     
      "Id": "13c5a17e-9aa3-1001-015e-02c04fd430c8",       
      "Partners": [],      
      "Slug": "referential2"      
    }      
  ]  

  EOF
```

GET /_referentials 










# 2. Partner

A Partner is a transporter.

##Edwig manages Partners for each Referential

A Partner is composed by:

* a uuid (Defined by Edwig)
* a slug
* an operationnalStatus (Defined by Edwig)
* a connectors list (Defined by Edwig)
* a connectors's kind list
* a parameters list (key/value type)

The parameters can particularily be:

* remote_objectid_kind
* remote_url
* remote_credential
* local_credential

**remote_objectid_kind:** Is used to différentiate the Objectids's kind used/sent by the partner. A remote objectIdKind may not have spaces nor ':'.

**remote_url:** External server's address used, by example, to make SIRI requests.

**remote_credential:** Identification for the external server (Used in RequestorRef, by example, in SIRI).

**local_credential:** ID that will be used by the external server to realise requests to Edwig (To know where a request come from).

The Partners's list is independant for each Referential.

##Create a Partner

While creating the Partner, we have to indicate a **slug**

We can indicate:

* the wanted connector's kind
* a parameters list

While creating it, the Patner is validated. In case of failure to comply with one of the validation rules, the Partner is not created and errors are returned in the API response. The connectors's use includes the validation rules, unique to each connector.

A Partner has its operationalStatus set to unknown by default.

Example of attributs sent to the API:

**Create a Partner**

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "slug": "STIF",
    "connectorTypes" : [ 
      "SIRIStopMonitoringRequestBroadcaster", 
      "SIRIEstimatedTimeTableSubscriptionBroadcaster", 
      "SIRICheckStatusRequestClient", 
      "SIRICheckStatusRequestServer", 
      "SIRIStopMonitoringRequestCollector" 
    ],
    "settings": { 
      "remote_url": "https://relai.stif.info", 
      "remote_credential": "RATPDEV:1234", 
      "remote_maxRequestRate" : 30, 
      "local_credential": "STIF:98395d4a8251ba8bf209ea96a63f0ed254ba0cc24692a06aad491c744e466b09", 
      "local_maxRequestRate" : 120 
    },
  }

  EOF
```

POST /:referential_slug/partners

##Consult Available Partners

We can consult the informations concerning one or all the Edwig's Referentials.

**Consult one Referential:**

>For one Referential:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Id": "5d6d607c-d33b-4062-adc1-58691937b7d0",
    "Slug": "ratpdev_partner",
    "Settings": {
      "remote_credential": "RATPDEV:Concerto",
      "remote_objectid_kind": "Skybus",
      "remote_url": "test.url/siri/SiriServices"
    },
    "ConnectorTypes": [
      "siri-check-status-client",
    ],
    "OperationnalStatus": "up"
  }

  EOF
```

GET /:referential_slug/partners/:uuid
 
**Consult all the Referentials:** 

>For all the Referentials:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Id": "5d6d607c-d33b-4062-adc1-58691937b7d0",
      "Slug": "ratpdev_partner",
      "Settings": {
        "remote_credential": "RATPDEV:Concerto",
        "remote_objectid_kind": "Skybus",
        "remote_url": "test.url/siri/SiriServices"
      },
      "ConnectorTypes": [
        "siri-check-status-client",
      ],
      "OperationnalStatus": "up"
    },
    {
      "Id": "5a6c689c-d33b-4028-avc1-56870937b7d0",
      "Slug": "ratpdev_partner2",
      "Settings": {
        "remote_credential": "RATPDEV:Concerto",
        "remote_objectid_kind": "Reflex",
        "remote_url": "second.test.url/siri"
      },
      "ConnectorTypes": [
        "siri-check-status-client",
        "siri-stop-monitoring-request-collector"
      ],
      "OperationnalStatus": "up"
    }
  ]

  EOF
```

GET /:referential_slug/partners

##Modify a Partner

We have to indicate the **Partner's ID (into the URL)**

We can indicate:

* the new slug
* the new list of wanted connector's kinds
* the new paramaters list

While modifiying it, the Partner is validated. The rules are the same as the creation's ones. If the Partner isn't valid, the modification isn't considered.

Example of attributes sent to the API:

**Modify a Partner:**

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "name": "STIF",
    "connectorTypes" : [ 
      "SIRIStopMonitoringRequestBroadcaster", 
      "SIRIEstimatedTimeTableSubscriptionBroadcaster", 
      "SIRICheckStatusRequestClient", 
      "SIRICheckStatusRequestServer", 
      "SIRIStopMonitoringRequestCollector" 
    ],
    "settings": { 
      "remote_url": "https://relai.stif.info", 
      "remote_credential": "RATPDEV:1234"
    },
  }

  EOF
 ```

PUT /:referential_slug/partners/:uuid

##Delete a Partner

We have to indicate the **Partner's ID (Into the URL)**.

The associated connectors are deleted too.

**Delete a Partner:**

DELETE /:referential_slug/partners/:uuid

##Connectors list

A Partner can only have one Connector with the same kind.

Connectors governs the trades realised with the associated Partner. Each Connector take over the sending or the receiving of a message into a given protocol.

Connectors are atomatically instanciated, based on connector's kinds list defined in the Partner. If the Connector's kind "disappear" from this list, the connector is destroyed.

A Connector can include validation constraints in the Partner (mandatory setting, other Connectors needed, etc...).

Existing Connectors:

* Siri-check-status-client
* Siri-check-status-server
* Siri-stop-monitoring-request-collector
* Siri-stop-monitoring-request-broadcaster
* Siri-service-request-broadcaster
* Siri-stop-points-discovery-request-broadcaster

**siri-check-status-client:** Is used to emit CheckStatus Resquests by a Guardian (automatically sending requests each 30 secondes). Need *remote_url* to the server's address and *remote_credentials* to identify.

**siri-check-status-server:** Is used to answer the CheckStatus requests. Need *local_credential* to identify the requests.

**siri-stop-monitoring-request-collector** Is used to answer the StopMonitoring by a Guardian (Automatically sending requests if a StopArea haven't been updated since a minute or more). Need *remote_objectid_kind* to known what kind of objectid the partner is using, *remote_url* for the server address, and *remote_credential* to indentify.

**siri-stop-monitoring-request-broadcaster:** Is used to answer the StopMonitoring requests. Need *remote_objectid_kind* to know what kind of objectid the partner is using and *local_credential* to indentify requests.

**siri-service-request-broadcaster:** Is used to answer the GetSiriService requests. Need *remote_objectid_kind* to know what kind of objectid the partner is using and *local_credential*
to identify requests.

**siri-stop-points-discovery-request-broadcaster:** Is used to answer StopPointDiscovery requests. Need *remote_objectid_kind* to know what kind of objectid the partner is using and *local_credential* to identify requests.










# 3. Line

A line includes one or more predefined public transport's **routes** defining an offered service to a well identified public, most of the time by a name or a commercial code (known as traveller).

A transport line is identified on the field by its name or its commercial code.
In the reference data published by the STIF, for each commecial line, a unique and sustainable identification is added by a unique ID (ID_Line).
In the attributs, we can also find the administrative line's reference (ID_GroupOfLines) which depends on the commercial line and the line's technical code (ExternalCode_Line) allowing us to do the link with the Line's data in the theorical offer's data (GTFS). In Chouette, this notion is managed by an objectid.

Moreover, a line is defined by a network which owns it, the transporter which manages it and its mode.

To work, a line depends on a **journey Pattern**, a **vehicle Journey Pattern** and a calendar which defines the dates of the schedules's validity and effective days (example: mondays, tuesdays, thursdays and fridays from March 2016 to Jun 2016).

##Edwig manage the lines for each Referential

A Line is composed by:

* A uuid (defined by Edwig)
* A name
* ObjectIDs
* Attributs 
* References

The Lines list is independante for each Referential.

##Create a Line in a Referential

We have to indicate the **Line's name**.

We can indicate an **ObjectId list**.

While creating it, the Line is validated. in case of failure to comply with the validation rules, the Line isn't created and errors are returned in the API response.

The Line have to:

* Have a non-empty Name
* Use valid ObjectIDs
* Use ObjectIDs unused by orther line

**Create Line**

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Attributes": {
      "JourneyNote": "abcd"
    },
    "Name": "Line01",
    "ObjectIDs": {
      "hastus": "1234"
    },
    "References": {
      "JourneyPattern": {
        "ObjectId": {
          "1234": "5678"
        },
        "Id": "42"
      }
    }
  }

  EOF
```

POST /:referential_slug/lines

##Consult Available Lines

**Consult one Line:**

>For one Line:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Attributes": {
      "JourneyNote": "abcd"
    },
   "Id": "95d8379f-68d5-4426-8a1b-fa49a9bd14a2",
   "Name": "Line01",
   "ObjectIDs": {
      "hastus": "1234"
    },
   "References": {
      "JourneyPattern": {
        "ObjectId": {
          "1234": "5678"
        },
        "Id": "42"
      }
    }
  }


  EOF
```

GET /:referential_slug/lines/:uuid

**Consult all the Lines:** 

>For all the Lines:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Attributes": {
        "JourneyNote": "abcd"
      },
     "Id": "95d8379f-68d5-4426-8a1b-fa49a9bd14a2",
     "Name": "Line01",
     "ObjectIDs": {
        "hastus": "1234"
      },
     "References": {
        "JourneyPattern": {
          "ObjectId": {
            "1234": "5678"
          },
          "Id": "42"
        }
      }
    },
    {
      "Id": "80e2379f-095e-4006-8a1b-fa49a9bd14a2",
      "Name": "Line02",
      "ObjectIDs": {
        "hastus": "5678"
      }
    }
  ]


  EOF
```

GET /:referential_slug/lines

##Nodify a Line in a Referential

We have to indicate the **Line's ID (in the URL)**.

We can indicate:

* the Line's name
* the ObjectID list

While modifiying it, the Line is validated. The rules are the same as the creation's ones. If the Line isn't valid, the modifications aren't considered.

**modify a Line:**

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Attributes": {
      "JourneyNote": "abcd"
    },
    "Name": "Line01",
    "ObjectIDs": {
      "hastus": "1234"
    },
    "References": {
      "JourneyPattern": {
        "ObjectId": {
          "1234": "5678"
        },
        "Id": "42"
      }
    }
  }

  EOF
```

PUT /:referential_slug/lines/:uuid

##Delete a Line in a referential

We have to indicate the **Line's ID (in the URL)**.

**Delete a Line:**

DELETE /:referential_slug/lines/:uuid










# 4. StopAreas

A StopArea corresponds to a stop on a Line.

##Edwig can manage the StopAreas for each Referential.

A StopArea is composed by: 

* A uuid (defined by Edwig)
* A name
* ObjectIDs
* CollectedUntil
* CollectedAlways
* Attributes
* References
* A date of the last update
* A date of the last update request

##Create a StopArea in a Referential

We have to indicate the **name of the stop**.

We can indicate a **ObjectID list**

While creating it, the StopArea is validated. In case of failure to comply with the validation rules, the StopArea isn't created and errors are returned in the API response.

The StopArea have to:

* Have a non-empty Name 
* Use valid ObjectIDs
* Use ObjectIDs unused by other StopArea

**Create a StopArea**

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF
  {
    "Attributes": {
      "JourneyNote": "abcd"
    },
    "CollectedAlways": true,
    "Name": "TestStopArea",
    "ObjectIDs": [
      {
        "Kind": "Skybus",
        "Value": "boaarle"
      }
    ],
    "References": {
      "JourneyPattern": {
        "ObjectId": {
          "1234": "5678"
        },
        "Id": "42"
      }
    }
  }

  EOF
```

POST /:referential_slug/stop_areas

##Consult Available StopAreas

**Consult one Available StopArea:**

>For one Available StopArea:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Attributes": {
      "JourneyNote": "abcd"
    },
    "CollectedAlways": true,
    "Id": "65585332-ca56-4c0b-9992-1946ca77d196",
    "Name": "TestStopArea",
    "ObjectIDs": [
      {
        "Kind": "Skybus",
        "Value": "boaarle"
      }
    ],
    "UpdatedAt": "2016-12-22T12:27:36.623814602+01:00",
    "References": {
      "JourneyPattern": {
        "ObjectId": {
          "1234": "5678"
        },
        "Id": "42"
      }
    },
    "RequestedAt": "2016-12-22T12:27:36.623814602+01:00"
  }

  EOF
```

GET /:referential_slug/stop_areas/

**Consult all the Available StopAreas:**

>For all the Available StopAreas:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Attributes": {
        "JourneyNote": "abcd"
      },
      "CollectedAlways": true,
      "Id": "65585332-ca56-4c0b-9992-1946ca77d196",
      "Name": "TestStopArea",
      "ObjectIDs": [
        {
          "Kind": "Skybus",
          "Value": "boaarle"
        }
      ],
      "UpdatedAt": "2016-12-22T12:27:36.623814602+01:00",
      "References": {
        "JourneyPattern": {
          "ObjectId": {
            "1234": "5678"
          },
          "Id": "42"
        }
      },
      "RequestedAt": "2016-12-22T12:27:36.623814602+01:00"
    },
    {
      "CollectedAlways": false,
      "CollectedUntil": "2016-12-22T12:47:36.623814602+01:00",,
      "Id": "65585332-ca56-4c0b-9992-1946ca77d196",
      "Name": "StopArea",
      "ObjectIDs": [
        {
          "Kind": "Skybus",
          "Value": "boaarle"
        }
      ],
      "UpdatedAt": "2016-12-22T12:27:36.623814602+01:00",
      "RequestedAt": "2016-12-22T12:27:36.623814602+01:00"
    } 
  ]


  EOF
```

GET /:referential_slug/stop_areas/:uuid

##Modify StopArea in a Referential

We have to indicate the **StopArea's ID(in the URL)**.

We can indicate:

* The stop's name
* The ObjectID list

While modifiying it, the StopArea is validated. The rules are the same as the creation's ones. If the StopArea isn't valid, the modification isn't considered.

**StopArea modification:** 

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Attributes": {
      "JourneyNote": "abcd"
    },
    "CollectedAlways": true,
    "Name": "TestStopArea",
    "ObjectIDs": [
      {
        "Kind": "Skybus",
        "Value": "boaarle"
      }
    ],
    "References": {
      "JourneyPattern": {
        "ObjectId": {
          "1234": "5678"
        },
        "Id": "42"
      }
    }
  }

  EOF
```

PUT /:referential_slug/stop_areas/:uuid

##Delete a StopArea in a Referential

We have to indicate the **StopArea ID (in the URL)**.

**Delete StopArea:**

DELETE /:referential_slug/stop_areas/:uuid










#5. StopVisit

A StopVisit corresponds to a bus's passage schedule in particular on a particular Line at a particular stop.

##Edwig manage the StopVisit for each Referential.

A StopVisit is composed by: 

* A uuid (defined by Edwig)
* ObjectIDs
* A CollectedAt
* A StopAreaId
* A VehicleJourneyId
* An ArrivalStatus
* A DepartureStatus
* A RecordedAt
* A VehicleAtStop
* A PassageOrder
* Schedules
* Attributes
* References
* Horaires (Aimed, Expected, Actual)

##Consult Available StopVisits 

**Consult one StopVisit:**

>For one available StopVisit:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "ArrivalStatus": "noReport",
    "Attributes": {
      "DepartureBoardingActivity": "boarding"
    },
    "Collected": true,
    "CollectedAt": "2017-04-24T14:48:01.15117002+02:00",
    "DepartureStatus": "noReport",
    "Id": "86f9154d-df94-42ce-8cab-ee89b6537b9a",
    "ObjectIDs": {
      "_default": "118f9488fa15b1589a8ce1bb45a3d9607f1b05e4",
      "ninoxe": "NINOXE:VehicleJourney:305-NINOXE:StopPoint:SP:24:LOC-4"
    },
    "PassageOrder": 5,
    "RecordedAt": "2017-04-24T03:50:09+02:00",
    "References": {
      "OperatorRef": {
        "ObjectId": {
          "ninoxe": "NINOXE:Company:15563880:LOC"
        },
        "Id": "1234"
      }
    },
    "Schedules": [
      {
        "ArrivalTime": "2017-04-24T17:36:00+02:00",
        "DepartureTime": "2017-04-24T17:38:00+02:00",
        "Kind": "aimed"
      },
      {
        "ArrivalTime": "2017-04-24T17:36:00+02:00",
        "DepartureTime": "2017-04-24T17:38:00+02:00",
        "Kind": "expected"
      }
    ],
    "StopAreaId": "50b8525b-be97-424f-89f3-ecb3e47cc666",
    "VehicleAtStop": false,
    "VehicleJourneyId": "05e8b2e4-27fc-47ca-b3c1-0236b5e89ab8"
  }

  EOF
```

GET /:referential_slug/stop_visits/:uuid

**Consult all the available StopVisit:**

>For all the Availble StopVisit:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "ArrivalStatus": "noReport",
      "Attributes": {
        "DepartureBoardingActivity": "boarding"
      },
      "Collected": true,
      "CollectedAt": "2017-04-24T14:48:01.15117002+02:00",
      "DepartureStatus": "noReport",
      "Id": "86f9154d-df94-42ce-8cab-ee89b6537b9a",
      "ObjectIDs": {
        "_default": "118f9488fa15b1589a8ce1bb45a3d9607f1b05e4",
        "ninoxe": "NINOXE:VehicleJourney:305-NINOXE:StopPoint:SP:24:LOC-4"
      },
      "PassageOrder": 5,
      "RecordedAt": "2017-04-24T03:50:09+02:00",
      "References": {
        "OperatorRef": {
          "ObjectId": {
            "ninoxe": "NINOXE:Company:15563880:LOC"
          },
          "Id": ""
        }
      },
      "Schedules": [
        {
          "ArrivalTime": "2017-04-24T17:36:00+02:00",
          "DepartureTime": "2017-04-24T17:38:00+02:00",
          "Kind": "aimed"
        },
        {
          "ArrivalTime": "2017-04-24T17:36:00+02:00",
          "DepartureTime": "2017-04-24T17:38:00+02:00",
          "Kind": "expected"
        }
      ],
      "StopAreaId": "50b8525b-be97-424f-89f3-ecb3e47cc666",
      "VehicleAtStop": false,
      "VehicleJourneyId": "05e8b2e4-27fc-47ca-b3c1-0236b5e89ab8"
    },
    {
      "ArrivalStatus": "noReport",
      "Attributes": {
        "DepartureBoardingActivity": "boarding"
      },
      "Collected": true,
      "CollectedAt": "2017-04-24T14:48:01.151202921+02:00",
      "DepartureStatus": "noReport",
      "Id": "d1bc5f20-2d26-4293-86d9-cf7e3280c795",
      "ObjectIDs": {
        "_default": "cd9ac5e84d448bb6b6e7b3ac15c6d6e36c16af3a",
        "ninoxe": "NINOXE:VehicleJourney:259-NINOXE:StopPoint:SP:24:LOC-3"
      },
      "PassageOrder": 4,
      "RecordedAt": "2017-04-24T03:50:09+02:00",
      "References": {
        "OperatorRef": {
          "ObjectId": {
            "ninoxe": "NINOXE:Company:15563880:LOC"
          },
          "Id": ""
        }
      },
      "Schedules": [
        {
          "ArrivalTime": "2017-04-24T18:06:00+02:00",
          "DepartureTime": "2017-04-24T18:06:00+02:00",
          "Kind": "expected"
        },
        {
          "ArrivalTime": "2017-04-24T18:06:00+02:00",
          "DepartureTime": "2017-04-24T18:06:00+02:00",
          "Kind": "aimed"
        }
      ],
      "StopAreaId": "ea6dc70b-9dbc-4a96-8133-79ef3c0c183f",
      "VehicleAtStop": false,
      "VehicleJourneyId": "4d3c136e-0a8a-406a-b247-279cfc7760f0"
    }
  ]


  EOF
```

GET /:referential_slug/stop_visits/

##Delete a StopVisit in a Referential

**Delete a StopVisit*

DELETE /_referentials/:uuid










# 6. VehicleJourney

A VehicleJourney defines the passage schedules to the different stop points of the JourneyPattern.

Example: "La Paimpont" Line - Rennes - Illenoo corporation.
The VehiculeJourney is defined by a passge at 6h25am "Avenue de la Libération" at Plélan, at 6h26am at "La Pointe" at "Plélan" and so on.

<style type="text/css">
  th, td {
    border: 1px solid black;
  }
</style>

<table>
  <tr>
    <th colspan="2"><center>Circulation days<br><br></center></th>
    <th><center>Monday<br>to<br>Friday</center></th>
  </tr>
  <tr>
    <th colspan="2">School period</th>
    <th style="background-color: green"><center>*</center></th>
  </tr>
  <tr>
    <th colspan="2">school holydays period (B zone)</th>
    <th style="background-color: cyan"><center>*</center></th>
  </tr>
  <tr>
    <th colspan="2">BUS DISPLAY</th>
    <th><center>Rennes<br>1a02</center></th>
  </tr>


  <tr>
    <td>PAIMPONT</td>
    <td>Campus Universitaire</td>
    <td></td>
  </tr>
  <tr>
    <td>PAIMPONT</td>
    <td>Centre</td>
    <td></td>
  </tr>
  <tr>
    <td>PLELAN</td>
    <td>Le Vieux Bourg</td>
    <td></td>
  </tr>
  <tr>
    <td>PLELAN</td>
    <td>Av. de la Libération</td>
    <td><center>6:25</center></td>
  </tr>
  <tr>
    <td>PLELAN</td>
    <td>La Pointe</td>
    <td><center>6:26</center></td>
  </tr>
  <tr>
    <td>PLELAN</td>
    <td>Les Brieux</td>
    <td><center>6:27</center></td>
  </tr>
  <tr>
    <td>PLELAN</td>
    <td>Le Néard</td>
    <td><center>6:28</center></td>
  </tr>
  <tr>
    <td>PLELAN</td>
    <td>Le Châtaignier</td>
    <td><center>6:29</center></td>
  </tr>

  <tr>
    <td>MONTERFIL</td>
    <td>Le Pâtis</td>
    <td></td>
  </tr>
  <tr>
    <td>TREFFENDEL</td>
    <td>Mairie</td>
    <td><center>6:35</center></td>
  </tr>
  <tr>
    <td>TREFFENDEL</td>
    <td>Gare</td>
    <td><center>6:37</center></td>
  </tr>
  <tr>
    <td>BREAL</td>
    <td>Parc d'activités</td>
    <td><center>6:45</center></td>
  </tr>

  <tr>
    <td>VEZIN LE COQUET</td>
    <td>Trois Marches</td>
    <td><center>6:58</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>Bethault</td>
    <td><center>6:59</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>Lemaistre</td>
    <td><center>7:00</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>Géniaux</td>
    <td><center>7:02</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>Guilloux/Lorient</td>
    <td><center>7:04</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>Pont de Bretagne</td>
    <td><center>7:07</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>République</td>
    <td><center>7:09</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>Liberté TNB</td>
    <td><center>7:11</center></td>
  </tr>
  <tr>
    <td>RENNES</td>
    <td>Gare Routière</td>
    <td><center>7:15</center></td>
  </tr>
</table>

##Edwig manages the VehicleJourney for each Referential

A VehicleJourney is composed by:

* A uuid (defined by Edwig)
* ObjectIDs
* A LineId
* Attributes
* References

##Consult Available VehicleJourneys

**Consult one available VehicleJourney:**

>For one VehicleJourney:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Attributes": {
      "DestinationAimedArrivalTime": "2017-04-24T15:44:00.000+02:00",
      "DestinationName": "Cimetière des Sauvages",
      "DirectionName": "Mago-Cime OMNI",
      "DirectionRef": "Left",
      "Monitored": "false",
      "OriginAimedDepartureTime": "2017-04-24T15:30:00.000+02:00",
      "OriginName": "Magicien Noir",
      "ProductCategoryRef": "0"
    },
    "Id": "18a04e0d-47bc-4c66-80e4-5d7a1c67071e",
    "LineId": "13d022ce-85e8-454e-885a-ab7b5791723e",
    "ObjectIDs": {
      "_default": "fc4a4d87c8151a2a58b1f6c74a092effa96c885d",
      "ninoxe": "NINOXE:VehicleJourney:224"
    },
    "References": {
      "DestinationRef": {
        "ObjectId": {
          "ninoxe": "NINOXE:StopPoint:SP:62:LOC"
        },
        "Id": "1234"
      },
      "JourneyPatternRef": {
        "ObjectId": {
          "ninoxe": "NINOXE:JourneyPattern:3_42_62:LOC"
        },
        "Id": "5678"
      }
    },
    "StopVisits": [
      "01ffe523-d6c8-45da-a153-250e45cc2cca"
    ]
  }

  EOF
```

GET /:referential_slug/vehicle_journeys/:uuid

**Consult all the avalaible VehicleJourney:**

>For all the VehicleJourney:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Attributes": {
        "DestinationAimedArrivalTime": "2017-04-24T15:44:00.000+02:00",
        "DestinationName": "aaaa",
        "DirectionName": "bbbb",
        "DirectionRef": "Left",
        "Monitored": "false",
        "OriginAimedDepartureTime": "2017-04-24T15:30:00.000+02:00",
        "OriginName": "cccc",
        "ProductCategoryRef": "0"
      },
      "Id": "18a04e0d-47bc-4c66-80e4-5d7a1c67071e",
      "LineId": "13d022ce-85e8-454e-885a-ab7b5791723e",
      "ObjectIDs": {
        "_default": "fc4a4d87c8151a2a58b1f6c74a092effa96c885d",
        "ninoxe": "NINOXE:VehicleJourney:224"
      },
      "References": {
        "DestinationRef": {
          "ObjectId": {
            "ninoxe": "NINOXE:StopPoint:SP:62:LOC"
          },
          "Id": "1234"
        },
        "JourneyPatternRef": {
          "ObjectId": {
            "ninoxe": "NINOXE:JourneyPattern:3_42_62:LOC"
          },
          "Id": "5678"
        }
      },
      "StopVisits": [
        "01ffe523-d6c8-45da-a153-250e45cc2cca"
      ]
    },
    {
      "Attributes": {
        "DestinationAimedArrivalTime": "2017-04-24T16:14:00.000+02:00",
        "DestinationName": "eeee",
        "DirectionName": "ffff",
        "DirectionRef": "Left",
        "Monitored": "false",
        "OriginAimedDepartureTime": "2017-04-24T16:00:00.000+02:00",
        "OriginName": "gggg",
        "ProductCategoryRef": "0"
      },
      "Id": "51c19567-58dc-4f29-bd0c-46964f4aa47e",
      "LineId": "13d022ce-85e8-454e-885a-ab7b5791723e",
      "ObjectIDs": {
        "_default": "4c3c35e4551fbb1866c8b7fd39e2748700ae9915",
        "ninoxe": "NINOXE:VehicleJourney:262"
      },
      "References": {
        "DestinationRef": {
          "ObjectId": {
            "ninoxe": "NINOXE:StopPoint:SP:62:LOC"
          },
          "Id": "9876"
        },
        "JourneyPatternRef": {
          "ObjectId": {
            "ninoxe": "NINOXE:JourneyPattern:3_42_62:LOC"
          },
          "Id": "5432"
        }
      },
      "StopVisits": [
        "4f869d69-4959-4e63-939d-37851d6466a2"
      ]
    }
  ]


  EOF
```

GET /:referential_slug/vehicle_journeys/

##Delete a VehicleJourney in a Referential

We have to indicate the **VehicleJourney ID (in the URL)**.

**Delete a VehicleJourney:**

DELETE /:referential_slug/vehicle_journeys/:uuid










# 7. Model management

##Edwig manages the Partners defined in the database when we load a Referential

At the beginning, Edwig creates the Referentials defined in the database.

For each Referential, are read:

* Its uuid
* Its slug

##Edwig loads the Partners defined in the database when we load the Referential

At the beginning, Edwig creates the Partners defined in the database (this, for each Referntial defined in the database)

For each Partner, are read:

* Its uuid
* Its slug
* Its Wanted connector's kind list
* Its parameters list

##Edwig regularily verify the operational state of the Partners

The Partner's status is periodically verified (if a Connector is availble). This time lap is about 30 secondes. An operationnalStatus can be: unknown, up or down.

**Unknown**

A Partner have its operationnalStatus set to "unknown" by default.
The operationnalStatus is "unknown" as long as no Connector allows us to know the Partner's state.

**Up**

The operationnalStatus is "up" since a Connector confirms the Partner's disponibility.

**Down**

The operationnalStatus is "down" if a Connector returns a negative state.

##Edwig regularily worries about the Partner's operationnal state

Each model's StopArea has to be up to date.

When a StopArea respects those requirements:

* It hasn't been updated since 1 minutes
* It hasn't initiated any requests since 1 minutes

An update request of this StopArea is made to the collecte manager.

Note: other requirements are to come with other fonctionalities (monitored_always / monitored_until, etc...).

##Edwig update its model with the StopVisit's update events received by the collect manager.

A StopVisit's update events includes:

* The StopVisit's ObjectId
* The DepartureStatus and the ArrivalStatus
* The different times
* The original message's complete informations

If a StopVisit correspond to an events's ObjectID, it is updated with the event's informations.

Else, the StopVisit, the StopArea if necessary, its Line and its VehicleJourney are created from the original message's conplete informations.










# 8. SIRI

The "Service Interface for Real time Information" (SIRI) is a realtime data trading protocole on the  public transport network between the systems (not the communication with the final use or the restitution periphérique), in an XML format.

##The StopMonitoringRequestCollector Connector allows us to consultate the StopVisits of a Partner.

The Connector receives the StopArea's update requests. It transforms them into SIRI StopMonitoringRequest request with these requirements:

* MonitoringRef: The StopArea's ObjectID
* StopVisitTypes: all

The response is decomposed like this: Each MonitoringStopVisit allows us to create a StopVisit's update event. Each events is transmited to the collect manager.

The original messages's complete informations (StopVisitUpdateAttributes) are available:

* StopVisitAttributes#ObjectId : ItemIdentifier
* StopVisitAttributes#StopAreaObjectId : StopPointRef
* StopVisitAttributes#VehicleJourneyObjectId : DatedVehicleJourneyRef
* StopVisitAttributes#LineObjectId : LineRef
* StopVisitAttributes#PassageOrder : Order
* StopVisitAttributes#DepartureStatus : DepartureStatus
* StopVisitAttributes#ArrivalStatus : ArrivalStatus
* StopVisitAttributes#Schedules : DepartureTime and ArrivalTime for Aimed, Expected, and Actual
* StopVisitAttributes#LineName : PublishedLineName
* StopVisitAttributes#StopPointName : StopPointName

##Send a SIRI request

Each Referential owns an entry point allowing us to process the SIRI requests.

POST /:referential_slug/siri

The request is analysed:

* According to the SIRI RequestoRef, the corresponding Partner is selected
* According to requested SOAP method, The SIRI request is transmited to the corresponding Connector

The SOAP response is generated from the Connectors's SIRI response.

SOAP/Connector associations Example: 

* CheckStatus SOAP : SIRICheckStatusRequestServer
* GetStopMonitoring SOAP : SIRIStopMonitoringRequestBroadcaster

##Send a CheckStatus SIRI request

The response have to comply with the SIRI standards.
The returned ServiceStartedTime correspond to the Refential's launch time.

##Send a StopMonitoring SIRI request

In the StopMonitoring request, IDs are interpreted according to the remote_objectid_kind configured for the StopMonitoringRequestBroadcaster Connector.

If the remote_objectid_kinf is "reflex", and MonitoringRef is "FR:77491:ZDE:34004:STIF", The stop associated to the request will have to have the ObjectID "reflex":"FR:77491:ZDE:34004:STIF".

The response to the request have to comply with the SIRI stardard and the SIRI IDF 2.4 profil.

The request's MonitoredStopVisits content is filled by using the Model's attributs like this:

<table>
  <tr>
    <td>RecordedAtTime</td>
    <td>StopVisit#RecordedAt</td>
  </tr>
  <tr>
    <td>ItemIdentifier</td>    
    <td>StopVisit#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoringRef</td>
    <td>StopArea#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/LineRef</td>
    <td>Line#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/DirectionRef</td>   
    <td>VehicleJourney#Attribute[DirectionRef]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/FramedVehicleJourneyRef/DataFrameRef</td>    
    <td>Model#Date</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/FramedVehicleJourneyRef/DatedVehicleJourneyRef</td>   
    <td>VehicleJourney#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/JourneyPatternRef</td>   
    <td>VehicleJourney#Reference[JourneyPattern]#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/JourneyPatternName</td>    
    <td>VehicleJourney#Attribute[JourneyPatternName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/VehicleMode</td>   
    <td>VehicleJourney#Attribute[VehicleMode]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/PublishedLineName</td>   
    <td>Line#Name</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/RouteRef</td>    
    <td>VehicleJourney#Reference[RouteRef]#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/DirectionName</td>   
    <td>VehicleJourney#Attribute[DirectionName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/OperatorRef</td>   
    <td>VehicleJourney#Reference[OperatorRef]#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/ProductCategoryRef</td>    
    <td>VehicleJourney#Attribute[ProductCategory]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/ServiceFeatureRef</td>   
    <td>VehicleJourney#Attribute[ServiceFeature]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/VehicleFeatureRef</td>   
    <td>VehicleJourney#Attribute[VehicleFeature]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/OriginRef</td>
    <td>VehicleJourney#Reference[Origin]#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/OriginName</td>    
    <td>VehicleJourney#Attribute[OriginName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/Via/PlaceName</td>   
    <td>VehicleJourney#Attribute[ViaPlaceName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/Via/PlaceRef</td>    
    <td>VehicleJourney#Reference[ViaPlace]#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/DestinationRef</td>    
    <td>VehicleJourney#Reference[Destination]#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/DestinationName</td>   
    <td>VehicleJourney#Attribute[DirectionName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/VehicleJourneyName</td>    
    <td>VehicleJourney#Name</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/JourneyNote</td>
    <td>VehicleJourney#Attribute[JourneyNote]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/HeadwayService</td>
    <td>VehicleJourney#Attribute[HeadwayService]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/OriginAimedDepartureTime</td>    
    <td>VehicleJourney#Attribute[OriginAimedDepartureTime]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/OriginAimedDestinationTime</td>    
    <td>VehicleJourney#Attribute[OriginAimedDestinationTime]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/FirstOrLastJourney</td>    
    <td>VehicleJourney#Attribute[FirstOrLastJourney]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/Monitored</td>   
    <td>VehicleJourney#Attribute[Monitored]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoringError</td>   
    <td>VehicleJourney#Attribute[MonitoringError]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/Occupancy</td>   
    <td>VehicleJourney#Attribute[Occupancy]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/Delay</td>   
    <td>VehicleJourney#Attribute[Delay]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/TrainNumber/TrainNumberRef</td>    
    <td>VehicleJourney#Attribute[TrainNumbers]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/SituationRef</td>    
    <td>VehicleJourney#Attribute[SituationRef]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/StopPointRef</td>    
    <td>StopArea#ObjectID</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/Order</td>   
    <td>StopVisit#PassageOrder</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/VehicleAtStop</td>   
    <td>StopVisit#VehicleAtStop</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/PlatformTraversal</td>
    <td>StopVisit#Attribute[PlatformTraversal]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/DestinationDisplay</td>
    <td>StopVisit#Attribute[DestinationDisplay]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/AimedArrivalTime</td>    
    <td>StopVisit#Schedule[aimed]#Arrival</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ActualArrivalTime</td>   
    <td>StopVisit#Schedule[actual]#Arrival</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ExpectedArrivalTime</td>   
    <td>StopVisit#Schedule[expected]#Arrival</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ArrivalStatus</td>   
    <td>StopVisit#ArrivalStatus</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ArrivalProximyTest</td>    
    <td>StopVisit#Attribute[ArrivalProximyTest]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ArrivalPlatformName</td>   
    <td>StopVisit#Attribute[ArrivalPlatformName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ArrivalStopAssignment/AimedQuayName</td>   
    <td>StopVisit#Attribute[ActualQuayName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/AimedDepartureTime</td>    
    <td>StopVisit#Schedule[aimed]#Departure</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ActualDepartureTime</td>   
    <td>StopVisit#Schedule[actual]#Departure</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ExpectedDepartureTime</td>   
    <td>StopVisit#Schedule[expected]#Departure</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/DepartureStatus</td>   
    <td>StopVisit#DepartureStatus</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/DeparturePlatformName</td>   
    <td>StopVisit#Attribute[DeparturePlatformName]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/DepartureBoardingActivity</td>   
    <td>StopVisit#Attribute[DepartureBoardingActivity]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/AimedHeadwayInterval</td>    
    <td>StopVisit#Attribute[AimedHeadwayInterval]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/ExpectedHeadwayInterval</td>   
    <td>StopVisit#Attribute[ExpectedHeadwayInterval]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/DistanceFromStop</td>    
    <td>StopVisit#Attribute[DistanceFromStop]</td>
  </tr>
  <tr>
    <td>MonitoredVehicleJourney/MonitoredCall/NumberOfStopsAway</td>   
    <td>StopVisit#Attribute[NumberOfStopsAway]</td>
  </tr>
</table>

##Send a SIRI GetSiriService request

The different elements of the GetSiriService request are addressed to the connectors dedicated to this kind of message.

Association example:

* StopMonitoringRequest: SIRIStopMonitoringRequestBroadcaster

The responses collected from each Connector are associated to form the response.

##Set a Connetor to make it able to use a specific remote_objectid_kind

This setting is possible thanks to a setting dedicated to each Connector. It is used in priority at the Partner's remote_objectid_kind setting.

Setting Example:

* siri_stopmonitoring_request_broadcast_remote_objectid_kind specific for SIRIStopMonitoringRequestBroadcaster

##Send a SIRI StopDiscovery request to obtain the stops list

The StopDiscovery response use the IDs corresponding to the remote_objectid_kinf set for the SIRISTopPointDiscoveryRequestBroadcaster Connector. The stops which haven't this king of ObjectID are naturally filtered.

The response have to comply with the SIRI standard and the SIRI IDF 2.4 Profil.

The resonse's AnnotatedStopPointRef content is filled using the Model's attributs like this:

<table>
  <tr>
    <td>StopPointRef</td>
    <td>StopArea#ObjectID</td>
  </tr>
  <tr>
    <td>StopName</td>
    <td>StopArea#Name</td>
  </tr>
</table>

##Configure a Partner to manage, in collect, a given list of stops

In a Partner, we can define a setting collect_include_stopareas containing a serie of IDs separated by a comma.

Example : collect_include_stopareas = “boaarle,trahote”

This serie of IDs is associated with the remote_objectid_kind from the same Partner.

This serie is considered by the CollectManager to select(or not) the Partner. If the setting is missing, the Partner can be used to supply any StopArea.

## Configurate a Partner to choose its priority in the collect.

In a Partner, we can define a collect.priority setting containing an integer (upper or equal to 0).

Example: collect.priority = “1”

This priority is considered by the CollectManager to select the Partner. A Partner with a lesser priority is used in priority. If the setting is missing, the Partner have the less state of priority (0).

##Set a stop to be temporarily monitored.

The StopArea#CollectedAlways and StopArea#CollectedUntil's attributs allows us to control the temporary(or not) collect of a stop.

A stop with a True StopArea#CollectedAlways will always be considered by the collect mechanism.

A stop with a False StopArea#CollectedAlways will only be considered by the collect mechanism if CollectedUntil is defined.

When StopMonitoring Request is received on a stop, its CollectedUntil Attribute is repositioned in the futur (+15 minutes). The collect is inssured during this period.

It signify that a default unmonitored stop will be temporary monitored until its informations are no longer consulted by StopMonitoring requests.

Example:

"RATP Dev" stop:

* ObjectID hastus and stif
* CollectedAlways: true
* CollectedUntil: undefined

"STIF" stop:

* ObjectIDs stif
* CollectedAlways: false
* CollectedUntil: Undefined by default

When we receive a StopMonitoring request, CollectedUntil go to +15 minutes

##Automatically reload tht Model of a Referential at a determined time

At the configured time (04:00 by default), a Referential have to launch its Model's reloading process. The Model change the referential date and take the today's date.

The Referential's "model.reload_at" setting allows us to modify this time (by example: "03:15").

For now, because of the missing database, the reloading of a Model deletes all the StopVistis, the Lines and the VehicleJourneys.