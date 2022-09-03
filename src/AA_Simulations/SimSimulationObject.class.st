"
A SimulationObject represents any object that can be given a sequence of tasks to do.  The class specifies a general control sequence by which the object enters, carries out its tasks, and leaves the simulation.

	Resources can be produced, consumed, acquired, and tested by queries such as amountAvailable, serversWaiting, custoemrsWaiting?
"
Class {
	#name : #SimSimulationObject,
	#superclass : #Object,
	#category : #'AA_Simulations'
}

{ #category : #'instance creation' }
SimSimulationObject class >> new [
	^super new initialize
]

{ #category : #'task language' }
SimSimulationObject >> acquire: amount ofResource: resourceName [ 
	"Get the resource and then tell it to acquire amount of it.  Answers 
	an instance of StaticResource."

	^(Simulation active provideResourceFor: resourceName)
		acquire: amount withPriority: 0
]

{ #category : #'task language' }
SimSimulationObject >> acquire: amount ofResource: resourceName withPriority: priority [ 
	"Returns a StaticResource"
	^(Simulation active provideResourceFor: resourceName)
		acquire: amount withPriority: priority
]

{ #category : #'task language' }
SimSimulationObject >> acquireResource: resourceName [
	"Returns a StaticResource"
	^(Simulation active provideResourceFor: resourceName) acquire
]

{ #category : #'simulation control' }
SimSimulationObject >> finishUp [
	"Tell the simulation that the receiver is done with its tasks."
	Simulation active exit: self
]

{ #category : #'task language' }
SimSimulationObject >> holdFor: aTimeDelay [
	Simulation active delayFor: aTimeDelay
]

{ #category : #initialization }
SimSimulationObject >> initialize [
	"Do nothing.  Subclasses will initialize instance variables."

	^self
]

{ #category : #'task language' }
SimSimulationObject >> inquireFor: amount ofResource: resourceName [
	^(Simulation active provideResourceFor: resourceName) amountAvailable >= amount
]

{ #category : #'task language' }
SimSimulationObject >> numberOfProvidersOfResource: resourceName [
	| resource |
	resource := Simulation active provideResourceFor: resourceName.
	resource serversWaiting
		ifTrue: [^resource queueLength]
		ifFalse: [^0]
]

{ #category : #'task language' }
SimSimulationObject >> numberOfRequestersOfResource: resourceName [
	| resource |
	resource := Simulation active provideResourceFor: resourceName.
	resource customersWaiting
		ifTrue: [^resource queueLength]
		ifFalse: [^0]
]

{ #category : #'task language' }
SimSimulationObject >> produce: amount ofResource: resourceName [
	Simulation active produce: amount of: resourceName
]

{ #category : #'task language' }
SimSimulationObject >> produceResource: resourceName [
	^(Simulation active provideResourceFor: resourceName) producedBy: self
]

{ #category : #'task language' }
SimSimulationObject >> release: aStaticResource [
	^aStaticResource release
]

{ #category : #'task language' }
SimSimulationObject >> resourceAvailable: resourceName [
	"Does the active simulaton have a resource with this attribute available?"
	^Simulation active includesResourceFor: resourceName
]

{ #category : #'task language' }
SimSimulationObject >> resume: anEvent [
	^anEvent resume
]

{ #category : #'simulation control' }
SimSimulationObject >> startUp [
	Simulation active enter: self.
	"First tell the simulation that the receiver is beginning to do my tasks."
	self tasks.
	self finishUp
]

{ #category : #'task language' }
SimSimulationObject >> stopSimulation [
	Simulation active finishUp
]

{ #category : #'simulation control' }
SimSimulationObject >> tasks [
	"Do nothing.  Subclasses will schedule activities."
	^self
]
