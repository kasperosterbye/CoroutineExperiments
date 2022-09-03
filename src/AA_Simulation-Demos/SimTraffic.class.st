Class {
	#name : #SimTraffic,
	#superclass : #Simulation,
	#instVars : [
		'statistics'
	],
	#category : #'AA_Simulation-Demos'
}

{ #category : #initialization }
SimTraffic >> defineArrivalSchedule [

self scheduleArrivalOf: SimCar accordingTo:
(SimUniform from: 0.5 to: 2).
self schedule: [self finishUp] at: 100.
"MJG Note: DOESN'T WORK!"

]

{ #category : #initialization }
SimTraffic >> initialize [

super initialize.

statistics := Dictionary new.

statistics at: #straight put: 0.

statistics at: #right put: 0.

statistics at: #left put: 0.

]

{ #category : #simulation }
SimTraffic >> printStatisticsOn: aStream [

aStream cr.

aStream nextPutAll: 'Car Direction Tally'.

statistics associationsDo:

[:assoc |

aStream cr.

assoc key printOn: aStream.

aStream tab.

assoc value printOn: aStream.]

]

{ #category : #simulation }
SimTraffic >> update: key [

statistics at: key 

put: (statistics at: key) + 1.

]
