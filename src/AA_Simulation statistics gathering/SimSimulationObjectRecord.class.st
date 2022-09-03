Class {
	#name : #SimSimulationObjectRecord,
	#superclass : #Object,
	#instVars : [
		'entranceTime',
		'duration'
	],
	#category : #'AA_Simulation statistics gathering'
}

{ #category : #accessing }
SimSimulationObjectRecord >> duration [
        ^duration
]

{ #category : #accessing }
SimSimulationObjectRecord >> entrance [
        ^entranceTime
]

{ #category : #accessing }
SimSimulationObjectRecord >> entrance: currentTime [
        entranceTime := currentTime
]

{ #category : #accessing }
SimSimulationObjectRecord >> exit [
        ^entranceTime + duration
]

{ #category : #accessing }
SimSimulationObjectRecord >> exit: currentTime [
        duration := currentTime - entranceTime
]

{ #category : #printing }
SimSimulationObjectRecord >> printOn: aStream [
        entranceTime printOn: aStream.
        aStream tab.
        duration printOn: aStream
]
