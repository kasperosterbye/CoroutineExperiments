"
Expects to handle several kinds of resources, represented abstractly by class Resource, and concretely by subclasses of Resource:  ResourceProvider, StaticResource, and ResourceCoordinator
"
Class {
	#name : #Simulation,
	#superclass : #Object,
	#instVars : [
		'resources',
		'currentTime',
		'eventQueue',
		'processCount'
	],
	#classVars : [
		'RunningSimulation'
	],
	#category : #'AA_Simulations'
}

{ #category : #accessing }
Simulation class >> active [
	^RunningSimulation
]

{ #category : #'instance creation' }
Simulation class >> new [
	^super new initialize
]

{ #category : #initialization }
Simulation >> activate [
	"This instance is now the active simulation"	
	RunningSimulation := self
]

{ #category : #'task language' }
Simulation >> coordinate: resourceName [
	(self includesResourceFor: resourceName)
		ifFalse: [resources add: ( SimResourceCoordinator named: resourceName)]
]

{ #category : #initialization }
Simulation >> defineArrivalSchedule [
	"A subclass specifies the schedule by which simulation objects dynamically enter into the simulation."
	^self
]

{ #category : #initialization }
Simulation >> defineResources [
	"A subclass specifies the schedule by which simulation objects that are initially entered into the simulation."
	^self
]

{ #category : #scheduling }
Simulation >> delayFor: timeDelay [
	self delayUntil: currentTime+timeDelay
]

{ #category : #scheduling }
Simulation >> delayUntil: aTime [
	| delayEvent |
	delayEvent := SimDelayedEvent onCondition: aTime.
	eventQueue add: delayEvent.
	"self stopProcess."
	delayEvent pause.
	"self startProcess"
]

{ #category : #'simulation control' }
Simulation >> enter: anObject [
	^self
]

{ #category : #'simulation control' }
Simulation >> exit: anObject [
	^self
]

{ #category : #'simulation control' }
Simulation >> finishUp [
	"We need to empty out the event queue."
	eventQueue := SortedCollection new.
	^nil
]

{ #category : #accessing }
Simulation >> includesResourceFor: resourceName [ 
	| test |
	test := resources 
				detect: [:each | each name = resourceName]
				ifNone: [nil].
	^test notNil
]

{ #category : #initialization }
Simulation >> initialize [
	resources := Set new.
	currentTime := 0.0.
	processCount := 0.
	eventQueue := SortedCollection new
]

{ #category : #scheduling }
Simulation >> newProcessFor: aBlock [
	self startProcess.
	[aBlock value. self stopProcess] fork
]

{ #category : #'simulation control' }
Simulation >> proceed [
	| eventProcess |
	[self readyToContinue]
		whileFalse: [Processor yield].
	eventQueue isEmpty
		ifTrue: [^self finishUp]
		ifFalse: 
			[eventProcess := eventQueue removeFirst.
			currentTime := eventProcess condition.
			eventProcess resume]
]

{ #category : #'task language' }
Simulation >> produce: amount of: resourceName [ 
	(self includesResourceFor: resourceName)
		ifTrue: [(self provideResourceFor: resourceName)
				produce: amount
			"sends produce: to a ResourceProvider"]
		ifFalse: [resources add: (SimResourceProvider named: resourceName with: amount)]
]

{ #category : #accessing }
Simulation >> provideResourceFor: resourceName [
	^resources detect: [ :each | each name = resourceName]
]

{ #category : #private }
Simulation >> readyToContinue [
	^processCount = 0
]

{ #category : #reporting }
Simulation >> report: label [
	Transcript show: label.
	Transcript tab.
	Transcript show: 'pc: ', processCount printString.
	Transcript space.
	Transcript show: 'procs: ', (Processor processesAt: Processor userSchedulingPriority) printString.
	Transcript space.
	Transcript show: 'events: ', eventQueue size printString.
	Transcript cr
]

{ #category : #'task language' }
Simulation >> schedule: actionBlock after: timeDelay [
	self schedule: actionBlock at: currentTime + timeDelay
]

{ #category : #'task language' }
Simulation >> schedule: aBlock at: timeInteger [
	"This is the mechanism for scheduling a single action."
	self newProcessFor: [self delayUntil: timeInteger.  aBlock value]
]

{ #category : #private }
Simulation >> schedule: aBlock startingAt: timeInteger andThenEvery: aProbabilityDistribution [ 
	self newProcessFor: 
			[self delayUntil: timeInteger.
			self newProcessFor: aBlock copy.
			aProbabilityDistribution do: 
				[:nextTimeDelay | 
				self delayFor: nextTimeDelay.
				self newProcessFor: aBlock copy]]
]

{ #category : #'task language' }
Simulation >> scheduleArrivalOf: aSimulationObjectClass accordingTo: aProbabilityDistribution [ 
	"This means start now"

	self
		scheduleArrivalOf: aSimulationObjectClass
		accordingTo: aProbabilityDistribution
		startingAt: currentTime
]

{ #category : #'task language' }
Simulation >> scheduleArrivalOf: aSimulationObjectClass accordingTo: aProbabilityDistribution startingAt: timeInteger [ 
	"Note that aSimulationObjectClass is the class Simulation or one of 
	its subclasses.  The real work is done in the private message 
	schedule:startingAt:andThenEvery:. "

	self
		schedule: [aSimulationObjectClass new startUp]
		startingAt: timeInteger
		andThenEvery: aProbabilityDistribution
]

{ #category : #'task language' }
Simulation >> scheduleArrivalOf: aSimulationObject at: timeInteger [ 
	self schedule: [aSimulationObject startUp]
		at: timeInteger
]

{ #category : #scheduling }
Simulation >> startProcess [
	processCount := processCount +1
]

{ #category : #'simulation control' }
Simulation >> startUp [
	self activate.
	self defineResources.
	self defineArrivalSchedule
]

{ #category : #scheduling }
Simulation >> stopProcess [
	processCount := processCount - 1
]

{ #category : #accessing }
Simulation >> time [
	^currentTime
]
