Class {
	#name : #SimCarBuyer,
	#superclass : #SimSimulationObject,
	#instVars : [
		'entryTime'
	],
	#category : #'AA_Simulation-Demos'
}

{ #category : #simulation }
SimCarBuyer >> entryTime [

^entryTime

]

{ #category : #initialization }
SimCarBuyer >> initialize [

super initialize.

entryTime := (Simulation active) time.

]

{ #category : #simulation }
SimCarBuyer >> tasks [

self acquire: 1 ofResource: 'Car'.

]
