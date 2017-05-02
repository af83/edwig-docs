---
title: API Reference

language_tabs:
  - shell

search: true
---

# Introduction

Tout d'abord pour commencer à utiliser Edwig vous devrez cloner le repository suivant:     
- [https://github.com/af83/edwig](https://github.com/af83/edwig)    
    
Dans cette documentation nous allons voir le fonctionnement d'Edwig en détaillant étape par étape chacun des topics suivant:  

1. Referential 
2. Partner 
3. Line 
4. StopArea 
5. StopVisit 
6. VehicleJourney 
7. Gestion du Modele 
8. SIRI 











# 1. Referential 
 
Un referential permet d’isoler plusieurs réseaux au sein d’un même serveur. 
 
##Edwig gère des Referentials. 
 
Un Referential est composé de:
 
* Un uuid 
* Un slug 
* Une liste de Partners 
* Un gestionnaire de Collecte 
* Un gestionnaire de Diffusion 
* Un modèle representant le réseau de transport (StopAreas, Lines, ...) 
 
##Créer un Referential 

A la création, je dois indiquer **un slug**. 
 
Un Referential possède un uuid déterminé par Edwig. 
Aucun Partner ni donnée dans le modèle (StopAreas, Lines, etc) n’est défini par défaut.  
Les gestionnaires de Collecte et de Diffusion sont créés et prêts à l’usage. 

**Création d’un referential:**  

POST /_referentials { "Slug": "test" }

 
##Modifier un Referential 

Je dois indiquer **l'identifiant du Referential (dans l'URL)** 

**Modification d’un referential:** 

PUT /_referentials/:uuid { "Slug": "another_test" }

##Supprimer un Referential 


Je dois indiquer **l'identifiant du Referential (dans l'URL)** 

Le Referential est supprimé. 

Tous les éléments associés (Partners, gestionnaires, modèle) sont supprimés aussi. 

**Suppression d’un referential:** 

DELETE /_referentials/:uuid

##Consulter les Referentials disponibles 

Je peux consulter les informations concernant un ou tous les Referentials d’Edwig : 

**Consultation d’un referential :** 

>Consultation d'un referential:

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

**Consultation de tous les referentials:**  

>Consultation de tout les referentials:

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










#2. Partner 

Un partner est un transporteur 

##Edwig gère des Partners pour chaque Referential 

Un partner est constitué de:
  
* uuid (défini par Edwig)
* slug
* operationnalStatus (défini par Edwig)
* liste de connecteurs (défini par Edwig)
* liste de types de connecteurs
* liste de paramètres (du type clé/valeur)

Les paramètres peuvent être en particulier: 

* remote_url
* remote_credential
* remote_maxRequestRate
* remote_maxConcurrentRequest
* local_credential
* local_maxRequestRate
* local_maxConcurrentRequest

La liste des Partners est indépendante pour chaque Referential.

##Créer un Partner


A la création, je dois indiquer **un slug**

Je peux indiquer: 

* les types de connecteur souhaités
* une liste de paramètres

A la création, le Partner est validé. En cas de non respect d’une des règles de validation, le Partner n’est pas créé et les erreurs sont retournées dans la réponse de l’API. L’utilisation de Connectors impliquent des règles de validation, propres à chaque connecteur.

Un Partner a son operationnalStatus à unknown par défaut.

Exemple d'attribut soumis a l'API:

**Création d'un Partner:**

POST /:referential_slug/partners

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

##Consulter les Partners disponibles

Je peux consulter les informations concernant un ou tous les Referentials d’Edwig:

**Consultation d’un Partner:** 

>Consultation d'un partner:

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
 
**Consultation de l’ensemble des Partners:** 

>Consultation de l'ensemble des Partners:

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

##Modifier un Partner

Je dois indiquer **l'identifiant du Partner (dans l'URL)**

Je peux indiquer:

* le nouveau slug
* la nouvelle liste des types de connecteur souhaités
* la nouvelle liste de paramètres

A la modification, le Partner est validé. Les règles sont les mêmes qu’à la création. Si le Partner n’est pas valide, la modification n’est pas prise en compte.

Exemple d'attributs soumis à l'API: 

**Modification d’un Partner:** 

PUT /:referential_slug/partners/:uuid

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

##Supprimer un Partner

Je dois indiquer **l'identifiant du Partner (dans l'URL)**

Les Connectors associés sont également supprimés.

**Suppression d’un Partner:**

DELETE /:referential_slug/partners/:uuid

##Liste de connecteurs

Un Partner ne peut avoir qu’un seul Connector d’un même type.

Les Connectors régissent les échanges réalisés avec le Partner associé. Chaque Connecteur prend en charge l’envoi ou la réception d’un message dans un protocole donné.

Les Connectors sont instanciés automatiquement en fonction de la liste de type de connectors définie dans le Partner. Si le type d’un Connector “disparaît” de cette liste, le Connector est détruit.

Un Connector peut induire des contraintes de validation dans le Partner (setting obligatoire, autre Connector requis, etc).

Connectors existants:

* OperationnalStatus
* SIRICheckStatusRequestClient
* Collector
* SIRIStopMonitoringRequestCollector (demander à un Partner l’état des prochaines StopVisits d’un StopArea)










#3. Line

Une ligne regroupe un ou plusieurs **itinéraires** - **“Route”** en anglais, appelés aussi **“séquences d’arrêts”** en français - prédéfinis (généralement l’aller et le retour) de transport en commun définissant un service offert au public bien identifié, le plus souvent par un nom ou un code commercial (connu du voyageur).

Une ligne de transport est identifiée sur le terrain par son nom ou son code commercial.
Dans les données de référence publiées par le STIF, pour chaque ligne commerciale, une identification unique et pérenne est ajoutée via un identifiant unique (ID_Line).
En attribut, on trouve également la référence à la ligne administrative (ID_GroupOfLines) dont dépend la ligne commerciale ainsi qu’un code technique de la ligne (ExternalCode_Line) permettant de faire le lien avec les données Ligne dans les données d’offre théorique GTFS. Dans Chouette, cette notion est gérée par un objectid.

De plus, une ligne est définie par un réseau auquel elle appartient, le transporteur qui la gère, et son mode.

Pour fonctionner une ligne dépend d’une **mission** - **“Journey Pattern”** en anglais -, d’une course - **“Vehicule Journey Pattern”** en anglais - et d’un calendrier qui définit les dates de validité des horaires et les jours effectifs (exemple : les lundis, mardis, jeudis et vendredi de mars 2016 à juin 2016).

##Edwig gère des Lines pour chaque Referential

Une Line est constituée de:

* uuid (défini par Edwig)
* un name
* des ObjectIDs
* des attributs 
* des references

La liste des Lines est indépendante pour chaque Referential.

##Créer une Line dans un Referential

Je dois indiquer **le nom de la ligne**

Je peux indiquer **une liste d’ObjectIDs**

A la création, la Line est validée. En cas de non respect d’une des règles de validation, la Line n’est pas créée et les erreurs sont retournées dans la réponse de l’API. 

La Line doit:

* avoir un Name non vide
* utiliser des ObjectIDs valides
* utiliser des ObjectIDs non utilisés par une autre Line

**Création d’une Line:** 

POST /:referential_slug/lines

{
  "Name": "Ligne 3 Metro",
  "ObjectIds": {
    "Reflex": "1234"
  },
  "Attributes" : {
    "JourneyNote":"abcd"
  },
  "References": {
    "JourneyPattern":{"ObjectId":{"1234":"5678"}, "Id":"42"}
  }
}

##Consulter les Lines disponibles

**Consulter une ligne:**

>Consulter une ligne:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Id": "95d8379f-68d5-4426-8a1b-fa49a9bd14a2",
    "Name": "Line01",
    "ObjectIDs": [
      {
        "Kind": "Skybus",
        "Value": "1234"
      }
    ],
  }

  EOF
```

GET /:referential_slug/lines/:uuid

**Consulter l’ensemble des lignes:** 

>Consulter l'ensemble des lignes:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Id": "95d8379f-68d5-4426-8a1b-fa49a9bd14a2",
      "Name": "Line01",
      "ObjectIDs": [
        {
          "Kind": "Skybus",
          "Value": "1234"
        }
      ],
    },
    {
      "Id": "80e2379f-095e-4006-8a1b-fa49a9bd14a2",
      "Name": "Line02",
      "ObjectIDs": [
        {
          "Kind": "Reflex",
          "Value": "2345"
        }
      ],
    }
  ]

  EOF
```

GET /:referential_slug/lines

##Modifier une Line dans un Referential

Je dois indiquer **l'identifiant de la Line (dans l'URL)**
Je peux indiquer:

* le nom de la ligne
* une liste d’ObjectIDs

A la modification, la Line est validée. Les règles sont les mêmes qu’à la création. Si la Line n’est pas valide, la modification n’est pas prise en compte.

**Modification d’une Line:**  

PUT /:referential_slug/lines/:uuid

{
  “Name”: “Ligne 3 Metro”,
  "ObjectIds": {
    "Reflex": "2345"
  }
}

##Supprimer une Line dans un Referential

Je dois indiquer **l'identifiant de la Line (dans l'URL)**
**Suppression d’une Line:**

DELETE /:referential_slug/lines/:uuid










#4. StopAreas

Un stopArea correspond à un arrêt d’une ligne

##Edwig gère des StopAreas pour chaque Referential
 
Un StopArea est constitué de:

* uuid (défini par Edwig)
* d’un name
* des ObjectIDs
* CollectedUntil
* CollectedAlways
* Attributes
* References
* d’une date de dernière mise à jour
* d’une date de la dernière demande de mise à jour

##Créer un StopArea dans un Referential

Je dois indiquer **le nom de l’arrêt**

Je peux indiquer **une liste d’ObjectIDs**

A la création, le StopArea est validé. En cas de non respect d’une des règles de validation, la StopArea n’est pas créé et les erreurs sont retournées dans la réponse de l’API. 

Le StopArea doit :

* avoir un Name non vide
* utiliser des ObjectIDs valides
* utiliser des ObjectIDs non utilisés par un autre StopArea

**Création d’un stopArea:** 

POST /:referential_slug/stop_areas

{
  "Name": "test",
  "ObjectIds": {
    "Reflex": "1234"
  },
  "Attributes" : {
    "JourneyNote":"abcd"
  },
  "References" : {
    "JourneyPattern":{"ObjectId":{"1234":"5678"}, "Id":"42"}
  }
}


##Consulter les StopAreas disponibles 

**Consulter un StopArea disponible:** 

>Consulter un StopArea disponible:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Id": "65585332-ca56-4c0b-9992-1946ca77d196",
      "Name": "TestStopArea",
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

GET /:referential_slug/stop_areas/


**Consulter tous les StopAreas disponibles:** 

>Consulter tous les StopAreas disponibles:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Id": "65585332-ca56-4c0b-9992-1946ca77d196",
      "Name": "TestStopArea",
      "ObjectIDs": [
        {
          "Kind": "Skybus",
          "Value": "boaarle"
        }
      ],
      "UpdatedAt": "2016-12-22T12:27:36.623814602+01:00",
      "RequestedAt": "2016-12-22T12:27:36.623814602+01:00"
    },
    {
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

##Modifier un StopArea dans un Referential

Je dois indiquer **l'identifiant du StopArea (dans l'URL)**

Je peux indiquer :

* le nom de l’arrêt
* une liste d’ObjectIDs

A la modification, le StopArea est validé. Les règles sont les mêmes qu’à la création. Si le StopArea n’est pas valide, la modification n’est pas prise en compte.

**Modification d’un stopArea:**

PUT /:referential_slug/stop_areas/:uuid

{
  "Name": "test",
  "ObjectIds": {
    "Reflex": "1234"
  }
}

##Supprimer un StopArea dans un Referential

Je dois indiquer **l'identifiant du StopArea (dans l'URL)**

**Suppression d’un stopArea:** 

DELETE /:referential_slug/stop_areas/:uuid









#5. StopVisit

Un stopVisit correspond à l‘horraire de passage d’un bus en particulier sur une ligne particulier un arrêt particulier.

##Edwig gère des StopVisits pour chaque Referential

Un StopVisit est constitué de:

* un uuid (défini par Edwig)
* des ObjectIDs
* un CollectedAt
* un StopAreaId
* un VehicleJourneyId
* un ArrivalStatus
* un DepartureStatus
* un RecordedAt
* un VehicleAtStop
* un PassageOrder
* des Schedules
* des Attributes
* des References
* des horaires (Aimed, Expected, Actual)

##Consulter les StopVisits disponibles

**Consulter un StopVisit:**  

>Consulter un StopVisit:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "ArrivalStatus": "onTime",
    "DepartureStatus": "onTime",
    "Id": "b47c65d5-bcef-4dfa-a847-41baba3beab1",
    "ObjectIDs": { "reflex": "FR:77491:ZDE:34004:STIF" }
    "PassageOrder": 44,
    "Schedules" : [
       {
          "Kind":"aimed",
          "ArrivalTime":"2017-01-01T13:00:00.000Z",
          "DepartureTime":"2017-01-01T13:02:00.000Z”
      },
     {
          "Kind":"expected",
          "ArrivalTime":"2017-01-01T13:00:00.000Z",
          "DepartureTime":"2017-01-01T13:02:00.000Z”
      }
    ],
    "StopArea": "65585332-ca56-4c0b-9992-1946ca77d196",
    "VehicleJourney": "75624f6f-89e9-4a27-8c4e-68d8f044d6cf"
  }

  EOF
```

GET /:referential_slug/stop_visits/:uuid


**Consulter l‘ensemble des StopVisits:**

>Consulter l'ensemble des StopVisits:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "ArrivalStatus": "onTime",
      "DepartureStatus": "onTime",
      "Id": "b47c65d5-bcef-4dfa-a847-41baba3beab1",
      "ObjectIds": {
        "Reflex": "1234"
      },
      "PassageOrder": 44,
      "Attributes" : {
        "JourneyNote":"abcd"
      }
      "References" : {
        "JourneyPattern":{"ObjectId":{"1234":"5678"}, "Id":"42"}
      }
      "Schedules": [
        {
          "ArrivalTime": "2016-12-22T12:45:29+01:00",
          "DepartureTime": "2016-12-22T12:45:29+01:00",
          "Kind": "expected"
        },
        {
          "ArrivalTime": "0001-01-01T00:00:00Z",
          "DepartureTime": "0001-01-01T00:00:00Z",
          "Kind": "actual"
        },
        {
          "ArrivalTime": "2016-12-22T12:43:05+01:00",
          "DepartureTime": "2016-12-22T12:43:05+01:00",
          "Kind": "aimed"
        }
      ],
      "StopArea": "65585332-ca56-4c0b-9992-1946ca77d196",
      "VehicleJourney": "75624f6f-89e9-4a27-8c4e-68d8f044d6cf"
    },
    {
      "ArrivalStatus": "onTime",
      "DepartureStatus": "onTime",
      "Id": "ed2f2906-5c64-4211-9eda-c2ec68375b19",
      "ObjectIds": {
        "Reflex": "1234"
      },
      "PassageOrder": 44,
      "Schedules": [
        {
          "ArrivalTime": "2016-12-22T17:44:38+01:00",
          "DepartureTime": "2016-12-22T17:44:38+01:00",
          "Kind": "aimed"
        },
        {
          "ArrivalTime": "2016-12-22T17:44:38+01:00",
          "DepartureTime": "2016-12-22T17:44:38+01:00",
          "Kind": "expected"
        },
        {
          "ArrivalTime": "0001-01-01T00:00:00Z",
          "DepartureTime": "0001-01-01T00:00:00Z",
          "Kind": "actual"
        }
      ],
      "StopArea": "65585332-ca56-4c0b-9992-1946ca77d196",
      "VehicleJourney": "a80e1cd3-204f-4aff-bdaa-793d690ae3a8"
    }
  ]

  EOF
```

GET /:referential_slug/stop_visits/

##supprimer un StopVisit dans un Referential

**Suppression d’un StopVisit: **

DELETE /_referentials/:uuid










#6. VehiculeJourney

Un VehiculeJourney (course) définit les horaires de passage aux différents points d’arrêt de la mission.

Exemple : Ligne de Bus 1a Paimpont - Rennes, société Illenoo
La course définit un passage à 6h25 avenue de la Libération à Plélan, à 6h26 à La Pointe à Plélan et ainsi de suite.

<style type="text/css">
  th, td {
    border: 1px solid black;
  }
</style>

<table>
  <tr>
    <th colspan="2"><center>Jours de circulation<br><br></center></th>
    <th><center>Lundi<br>à<br>Vendredi</center></th>
  </tr>
  <tr>
    <th colspan="2">Période scolaire</th>
    <th style="background-color: green"><center>*</center></th>
  </tr>
  <tr>
    <th colspan="2">Période de vacances scolaires (zone B)</th>
    <th style="background-color: cyan"><center>*</center></th>
  </tr>
  <tr>
    <th colspan="2">AFFICHAGE SUR L'AUTOCAR</th>
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

##Edwig gère des VehicleJourney pour chaque Referential

Un VehicleJourney est constitué de :

* uuid (défini par Edwig)
* des ObjectIDs
* un LineId
* des Attributes
* des References

##Consulter les VehiculeJourneys disponibles


**Consulter un VehicleJourney:**

>Consulter un VehicleJourney:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  {
    "Id": "217d22f9-7e5a-43b8-ba31-9992a9e77153",
    "ObjectIds": {
      "Reflex": "1234"
    },
    "Line": "65585332-ca56-4c0b-9992-1946ca77d196",
    "Attributes" : {
        "JourneyNote":"abcd"
    },
    "References" : {
      "JourneyPattern":{"ObjectId":{"1234":"5678"}, "Id":"42"}
    }
  }

  EOF
```

GET /:referential_slug/vehicle_journeys/:uuid

**Consulter l’ensemble des VehicleJourneys:** 

>Consulter l'ensemble des VehicleJourneys:

```shell
  curl -d @- "<URL>"
  -H "Authorization: <Clé API>" <<EOF

  [
    {
      "Id": "6fafa63f-83a3-491d-bb9b-6873991d9c1f",
      "ObjectIds": {
        "Reflex": "1234"
      },
      "Line": "65585332-ca56-4c0b-9992-1946ca77d196",
    },
    {
      "Id": "217d22f9-7e5a-43b8-ba31-9992a9e77153",
      "ObjectIds": {
        "Reflex": "1234"
      },
      "Line": "65585332-ca56-4c0b-9992-1946ca77d196",
    }
  ]

  EOF
```

GET /:referential_slug/vehicle_journeys/

##Supprimer un VehicleJourney dans un Referential

Je dois indiquer **l'identifiant du VehicleJourney (dans l'URL)**

**Suppression d’un VehicleJourney:**

DELETE /:referential_slug/vehicle_journeys/:uuid










#7. Gestion du Modèle

##Edwig charge les Referentials définis en base de données lors de son lancement

Au démarrage, Edwig créé les Referentials définis dans sa base de donnée. 

Pour chaque Referential, sont lus: 

* son uuid
* son slug

##Edwig charge les Partners définis en base de données quand on charge un Referential

Au démarrage, Edwig créé les Partners définis dans sa base de donnée (et ce, pour chaque Referential défini en base):

Pour chaque Partner, sont lus:

* son uuid
* son slug
* sa liste des types de connecteur souhaités
* sa liste de paramètres

##Edwig vérifie régulièrement l’état opérationnel des Partners

Le status du Partner est vérifié périodiquement (si un Connector est disponible). Cet intervalle de temps est de 30 secondes. Un operationnalStatus peut être: unknown, up ou down.

**unknown**

Un Partner a son operationnalStatus à unknown par défaut.
L’operationnalStatus est à unknown tant qu’aucun Connector n'a permis de connaître l’état du Partner.

**up**

L’operationnalStatus est à up dès qu’un Connector confirme la disponibilité du Partner.

**down**

L’operationnalStatus est à down si un Connector retourne un état négatif.

##Edwig s’inquiète régulièrement l’état de chaque StopArea

Chaque StopArea du modèle doit être maintenu à jour. 

Lors qu’un StopArea respecte ces critères:

* il n’a pas été mis à jour depuis 1 minute
* il n’a pas déclenché de demande depuis 1 minute

Une demande de mise à jour de ce StopArea est formulée auprès du gestionnaire de collecte.

Note : d’autres critères à venir avec d’autres fonctionnalités (monitored_always / monitored_until, etc)

##Edwig met à jour son modèle avec les évènements de mise à jour de StopVisit reçus du gestionnaire de collecte

Un évènement de mise à jour de StopVisit intègre:
* l’ObjectID du StopVisit
* le DepartureStatus et le ArrivalStatuts
* les différents horaires
* les informations complètes du message d’origine (StopVisitUpdateAttributes)

Si un StopVisit correspond à l’ObjectID de l’évènement, il est mis à jour avec les informations de l’évènement.

Sinon le StopVisit, si nécessaire son StopArea, sa Line et son VehicleJourney sont créés à partir des informations complètes du message d’origine.









#8. SIRI

Le Service Interface for Real Time Information (SIRI) est un protocole d’échange de données Temps Réel sur les réseaux de transports en commun entre systèmes (et non la communication avec l'usager final ou le périphérique de restitution (afficheur), sous un format XML. 

##Le Connecteur de StopMonitoringRequestCollector permet de consulter les StopVisits d’un Partner

Le Connecteur reçoit des demandes de mises à jour de StopAreas. Il les transforme en requête SIRI StopMonitoringRequest avec ces critères:

* MonitoringRef: l’ObjectID du StopArea (du type configuré pour ce Connector)
* StopVisitTypes: all

La réponse est décomposée ainsi: chaque MonitoredStopVisit permet de créer un événement de mise à jour de StopVisit. Chaque évènement est transmis au gestionnaire de collecte.

Les informations complètes du message d’origine (StopVisitUpdateAttributes) sont accessibles:

* StopVisitAttributes#ObjectId : ItemIdentifier
* StopVisitAttributes#StopAreaObjectId : StopPointRef
* StopVisitAttributes#VehicleJourneyObjectId : DatedVehicleJourneyRef
* StopVisitAttributes#LineObjectId : LineRef
* StopVisitAttributes#PassageOrder : Order
* StopVisitAttributes#DepartureStatus : DepartureStatus
* StopVisitAttributes#ArrivalStatus : ArrivalStatus
* StopVisitAttributes#Schedules : DepartureTime et ArrivalTime pour Aimed, Expected, et Actual
* StopVisitAttributes#LineName : PublishedLineName
* StopVisitAttributes#StopPointName : StopPointName

----------------------------------------------------------------------------------------------------
**PHASE 2**

##Envoyer une requête SIRI 
Chaque référentiel dispose d’un point d’entrée permettant de traiter des requêtes SIRI.

POST /:referential_slug/siri

La requête est analysée :
en fonction du RequestorRef SIRI, le Partner correspondant est sélectionné. 
en fonction de la méthode SOAP sollicitée, la requête SIRI est transmise au Connector correspondant

La réponse SOAP est générée à partir de la réponse SIRI du Connector.

Exemple d’associations SOAP / Connector:

* CheckStatus SOAP : SIRICheckStatusRequestServer
* GetStopMonitoring SOAP : SIRIStopMonitoringRequestBroadcaster

##Envoyer une requête SIRI CheckStatus

La réponse doit être conforme à la norme SIRI.
Le ServiceStartedTime retourné correspond à l’heure de mise en service du Referential.

##Envoyer une requête SIRI StopMonitoring

Dans la requête StopMonitoring, les identifiants sont interprétés selon le remote_objectid_kind configuré pour le Connector StopMonitoringRequestBroadcaster.

Si le remote_objectid_kind est “reflex”, et MonitoringRef est “FR:77491:ZDE:34004:STIF”, l’arrêt associé à la requête devra avoir l’objectid “reflex”:”FR:77491:ZDE:34004:STIF”.

La réponse à la requête doit être conforme à la norme SIRI.

Le contenu de la réponse est rempli en utilisant les attributs suivants:

| path XML | attribut du modèle |

**TODO: copier/coller les données depuis le tableau de mapping**

##Envoyer une requête SIRI GetSiriService

Les différentes composantes de la requête GetSiriService sont adressées aux connectors dédiés de ce type de message.

Exemple d’association:

* StopMonitoringRequest: SIRIStopMonitoringRequestBroadcaster

Les réponses collectées auprès de chaque Connector sont agrégées pour former la réponse.









##Paramétrer un Connecteur pour qu’il utilise un remote_objectid_kind spécifique

Ce paramétrage est rendu possible pour un setting dédié à chaque Connecteur. Il est utilisé en priorité au setting remote_objectid_kind du Partner.

Exemple de setting :

* siri_stopmonitoring_request_broadcast_remote_objectid_kind spécifique pour SIRIStopMonitoringRequestBroadcaster

##Envoyer une requête SIRI StopDiscovery pour obtenir la liste des arrêts

La réponse au StopDiscovery utilise les identifiants correspondant au remote_objectid_kind configuré pour le Connector SIRIStopPointDiscoveryRequestBroadcaster. Les arrêts ne disposant pas d’un objectid de ce type sont naturellement filtrés.

La réponse doit être conforme à la norme SIRI.

Le contenu de la réponse est rempli en utilisant les attributs suivants:

| path XML | attribut du modèle |

**TODO: remplir**

##Configurer un Partner pour ne gérer en collecte qu’une liste donnée d’arrêts

Dans un Partner, on peut définir un settings collect_include_stopareas contenant une suite d’identifiants sparés par un virgule.

Exemple : collect_include_stopareas = “boaarle,trahote”

Cette liste d’identifiants est associée au remote_objectid_kind du même Partner. 

Cette liste est pris en compte par le CollectManager pour sélectionner (ou non) le Partner.

##Paramétrer un arrêt pour qu’il soit monitoré temporairement

Les attributs StopArea#monitored_always et StopArea#monitored_until permettent de contrôler le monitoring temporaire ou non d’un arrêt.

Un arrêt avec StopArea#monitored_always à vrai sera toujours pris en compte par le mécanisme de mise à jour de ses données.

Un arrêt avec StopArea#monitored_always à faux ne sera pris en compte par le mécanisme de mise à jour de ses données que si monitored_until est défini et dans le futur.

Lorsqu’une requête de StopMonitoring est reçue sur un arrêt, son attribut monitored_until est repositionné dans le futur (+10 minutes par exemple).

Ce qui signifie qu’un arrêt non monitoré par défaut, le sera temporairement tant que ses informations sont consultées via des requêtes s de StopMonitorings.

Exemples:

Arrêt “RATP Dev” : objectid hastus, monitored_always = true / monitored_until = 0

Arrêt “STIF” : objectid reflex, monitored_always = false / monitored_until = 0 initialement. Quand on recoit une requete de StopMonitoring, monitored_until  = now + 10 minutes

##Configurer pour un Partner le format des identifiants de message SIRI

**TODO identifier les autres endroits**

Identifiés pour l’instant:

Le ResponseMessageIdentifier doit respecter le format imposé par le profil SIRI STIF 2.4.

siri_responsemessageidentifier_format = “%{partner_slug}:ResponseMessage::%{uuid}:LOC”
