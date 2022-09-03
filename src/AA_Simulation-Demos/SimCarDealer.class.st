Class {
	#name : #SimCarDealer,
	#superclass : #Simulation,
	#instVars : [
		'statistics'
	],
	#category : #'AA_Simulation-Demos'
}

{ #category : #demo }
SimCarDealer class >> demo [
	<script>
	| aSimulation aStream|
	aSimulation := self new startUp.
	[aSimulation time < 180] whileTrue: [aSimulation proceed].
	aStream := 'dealer.events' asFileReference writeStream.
	aSimulation printStatisticsOn: aStream.
	aStream close.
]

{ #category : #initialization }
SimCarDealer >> defineArrivalSchedule [

self scheduleArrivalOf: SimCarBuyer

accordingTo: (SimUniform from: 2 to: 6)

startingAt: 1.0.

self scheduleArrivalOf: 

(SimCarDelivery new) at: 90.0.

"Only one delivery is scheduled; the instance of CarDelivery will reschedule itself."

]

{ #category : #initialization }
SimCarDealer >> defineResources [

self produce: 12 of: 'Car'.

]

{ #category : #simulation }
SimCarDealer >> exit: aSimulationObject [

super exit: aSimulationObject.

"A CarDelivery could be exiting -- ignore it."

(aSimulationObject isKindOf: SimCarBuyer)

ifTrue: [statistics store: 

currentTime - aSimulationObject entryTime]

]

{ #category : #initialization }
SimCarDealer >> initialize [

super initialize.

statistics := SimHistogram from: 1 to: 365 by: 7.

]

{ #category : #simulation }
SimCarDealer >> printStatisticsOn: aStream [

statistics printStatisticsOn: aStream.

]
