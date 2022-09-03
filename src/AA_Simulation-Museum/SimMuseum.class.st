Class {
	#name : #SimMuseum,
	#superclass : #Simulation,
	#instVars : [
		'statistics'
	],
	#category : #'AA_Simulation-Museum'
}

{ #category : #demo }
SimMuseum class >> demo [
	<script>
	| aSimulation aStream|
	aSimulation := self new startUp.
	[aSimulation time < 50] whileTrue: [aSimulation proceed].
	aStream := 'museum.events' asFileReference writeStream.
	aSimulation printStatisticsOn: aStream.
	aStream close.
]

{ #category : #'class initialization' }
SimMuseum >> defineArrivalSchedule [
        self scheduleArrivalOf: SimVisitor accordingTo: (SimUniform from: 5
to:10).
]

{ #category : #'class initialization' }
SimMuseum >> exit: aSimulationObject [
        super exit: aSimulationObject.
        statistics store: currentTime - aSimulationObject entryTime
]

{ #category : #'class initialization' }
SimMuseum >> initialize [
        super initialize.
        statistics := SimHistogram from: 5 to: 45 by: 5.
]

{ #category : #'class initialization' }
SimMuseum >> printStatisticsOn: aStream [
        statistics printStatisticsOn: aStream
]
