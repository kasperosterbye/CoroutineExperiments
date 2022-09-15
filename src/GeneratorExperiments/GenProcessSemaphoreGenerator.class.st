"
I implement a simple generator.
The generator is run in a seperate process, and it synchronize with the client thread using two semaphores, one for waiting the client, and one for waiting the generator
"
Class {
	#name : #GenProcessSemaphoreGenerator,
	#superclass : #GenAbstractGenerator,
	#instVars : [
		'nextVal',
		'finished',
		'clientSem',
		'genSem'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #testing }
GenProcessSemaphoreGenerator >> atEnd [
	clientSem wait.
	clientSem signal.
	^ finished
]

{ #category : #accessing }
GenProcessSemaphoreGenerator >> next [
	"Take next value, and release generator"
	|next|
	clientSem wait.
	finished ifTrue: [ ^nil ].
	next := nextVal.
	genSem signal.
	^ next 
]

{ #category : #'instance creation' }
GenProcessSemaphoreGenerator >> on: genBlock [
	
	clientSem := Semaphore new.
	genSem := Semaphore new.
	finished := false.
	[ genBlock value: self. finished := true. clientSem signal] fork.
	

]

{ #category : #accessing }
GenProcessSemaphoreGenerator >> peek [
	clientSem wait.
	clientSem signal.
	^ nextVal
]

{ #category : #public }
GenProcessSemaphoreGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientSem signal.
	genSem wait.
	
]
