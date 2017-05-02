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

* remote_objectid_kind
* remote_url
* remote_credential
* local_credential

**remote_objectid_kind:** sert à différencier le type (kind) d'objectids utilisés/renvoyés par le partenaire. Un remote objectIdKind ne doit pas contenir d'espace ni de ':'.

**remote_url:** adresse du server externe utilisée par exemple pour faire des requête SIRI.

**remote_credential:** identification pour le serveur externe (utilisé en ReauestorRef par exemple en SIRI).

**local_credential:** identifiant qui sera utilisé par le serveur externe pour réaliser des requêtes vers Edwig (pour que l'on reconnaisse la provenance d'une demande).

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

* Siri-check-status-client
* Siri-check-status-server
* Siri-stop-monitoring-request-collector
* Siri-stop-monitoring-request-broadcaster
* Siri-service-request-broadcaster
* Siri-stop-points-discovery-request-broadcaster

**siri-check-status-client:** Sert à émettre des requêtes de CheckStatus via un Guardian (envoi de requêtes automatique toutes les 30 secondes). Nécessite *remote_url* pour l'adresse du serveur et *remote_credentials* pour s'identifier.

**siri-check-status-server:** Sert à répondre aux requêtes de CheckStatus. Nécessite *local_credential* pour identifier les requêtes.

**siri-stop-monitoring-request-collector** Sert à émettre des requêtes de StopMonitoring via un Guardian (envoi de requêtes automatiquement si un StopArea n'a pas été mis à jour depuis une minute ou plus). Nécessite *remote_objectid_kind* pour savoir ce que le partenaire utilise comme type d'objectid, *remote_url* pour l'adresse du serveur, et *remote_credential* pour s'identifier.

**siri-stop-monitoring-request-broadcaster:** Sert à répondre aux requêtes de StopMonitoring. Nécessite *remote_objectid_kind* pour savoir ce que le partenaire utilise comme type d'objectid et *local_credential* pour identifier les requêtes.

**siri-service-request-broadcaster:** Sert à répondre aux requêtes de GetSiriService. Nécessite *remote_objectid_kind* pour savoir ce que le partenaire utilise comme type d'objectid et *local_credential* pour identifier les requêtes.

**siri-stop-points-discovery-request-broadcaster:** Sert à répondre aux requêtes de StopPointDiscovery. Nécessite *remote_objectid_kind* pour savoir ce que le partenaire utilise comme type d'objectid et *local_credential* pour identifier les requestes.










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


##Consulter les Lines disponibles

**Consulter une ligne:**

>Consulter une ligne:

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

**Consulter l’ensemble des lignes:** 

>Consulter l'ensemble des lignes:

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

##Modifier une Line dans un Referential

Je dois indiquer **l'identifiant de la Line (dans l'URL)**
Je peux indiquer:

* le nom de la ligne
* une liste d’ObjectIDs

A la modification, la Line est validée. Les règles sont les mêmes qu’à la création. Si la Line n’est pas valide, la modification n’est pas prise en compte.

**Modification d’une Line:**  

PUT /:referential_slug/lines/:uuid

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


##Consulter les StopAreas disponibles 

**Consulter un StopArea disponible:** 

>Consulter un StopArea disponible:

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


**Consulter tous les StopAreas disponibles:** 

>Consulter tous les StopAreas disponibles:

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

##Modifier un StopArea dans un Referential

Je dois indiquer **l'identifiant du StopArea (dans l'URL)**

Je peux indiquer :

* le nom de l’arrêt
* une liste d’ObjectIDs

A la modification, le StopArea est validé. Les règles sont les mêmes qu’à la création. Si le StopArea n’est pas valide, la modification n’est pas prise en compte.

**Modification d’un stopArea:**

PUT /:referential_slug/stop_areas/:uuid

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


**Consulter l‘ensemble des StopVisits:**

>Consulter l'ensemble des StopVisits:

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

**Consulter l’ensemble des VehicleJourneys:** 

>Consulter l'ensemble des VehicleJourneys:

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

La réponse à la requête doit être conforme à la norme SIRI et au profil SIRI IDF 2.4

Le contenu des MonitoredStopVisits de la réponse est rempli en utilisant les attributs du Model de la manière suivante:


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

La réponse doit être conforme à la norme SIRI et au profil SIRI IDF 2.4.

Le contenu des AnnotatedStopPointRef de la réponse est rempli en utilisant les attributs du Model de la manière suivante :

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


##Configurer un Partner pour ne gérer en collecte qu’une liste donnée d’arrêts

Dans un Partner, on peut définir un settings collect_include_stopareas contenant une suite d’identifiants sparés par un virgule.

Exemple : collect_include_stopareas = “boaarle,trahote”

Cette liste d’identifiants est associée au remote_objectid_kind du même Partner. 

Cette liste est pris en compte par le CollectManager pour sélectionner (ou non) le Partner. En l’absence du setting, le Partner peut être utilisé pour alimenter n’importe quel StopArea.

##Configurer un Partner pour choisir sa priorité dans la collecte

Dans un Partner, on peut définir un setting collect.priority contenant un entier (supérieur ou égal à 0).

Exemple : collect.priority = “1”

Cette priorité est prise en compte par le CollectManager pour sélectionner le Partner. Un Partner avec un priorité plus basse est utilisé en priorité. En l’absence du setting, le Partner a la priorité la plus basse (0).


##Paramétrer un arrêt pour qu’il soit monitoré temporairement

Les attributs StopArea#CollectedAlways et StopArea#CollectedUntil permettent de contrôler la collecte temporaire ou non d’un arrêt.

Un arrêt avec StopArea#CollectedAlways à vrai sera toujours pris en compte par le mécanisme de collecte.

Un arrêt avec StopArea#CollectedAlways à faux ne sera pris en compte par le mécanisme de collecte que si CollectedUntil est défini et dans le futur.

Lorsqu’une requête de StopMonitoring est reçue sur un arrêt, son attribut CollectedUntil est repositionné dans le futur (+15 minutes). La collecte est assurée pendant toute cette période.

Ce qui signifie qu’un arrêt non monitoré par défaut, le sera temporairement tant que ses informations sont consultées via des requêtes de StopMonitorings.

Exemples :

Arrêt “RATP Dev”: 

* ObjectIDs hastus et stif
* CollectedAlways: true 
* CollectedUntil: non défini

Arrêt “STIF”:

* ObjectIDs stif
* CollectedAlways: false 
* CollectedUntil non défini initialement. 

Quand on reçoit une requête de StopMonitoring, CollectedUntil  passe à +15 minutes.

##Recharger automatiquement le Model d'un Referential à l'heure prévue

A l'heure configurée (04:00 par défaut), un Referential doit lancer la procédure de rechargement de son Model. Le Model change de date de référence et prend la date du jour.

Le setting "model.reload_at" du Referential permet de modifier cette heure (par exemple "03:15").

Pour l'instant, en l'absence de donnée en base, le rechargement d'un Model consiste à effacer tous les StopVisits, les Lines et les VehicleJourneys.