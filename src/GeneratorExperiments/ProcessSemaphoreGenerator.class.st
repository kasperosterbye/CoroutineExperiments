"
I implement a simple generator.
The generator is run in a seperate process, and it synchronize with the client thread using two semaphores, one for waiting the client, and one for waiting the generator
"
Class {
	#name : #ProcessSemaphoreGenerator,
	#superclass : #Object,
	#instVars : [
		'nextVal',
		'finished',
		'clientSem',
		'genSem'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #'instance creation' }
ProcessSemaphoreGenerator class >> on: genBlock [
	^ self new on: genBlock.
]

{ #category : #'instance creation' }
ProcessSemaphoreGenerator class >> somePrimes [
	"self somePrimes" 
	<example>
	^ String streamContents: [ :str | 
		| generator |
		generator := self on: [:g| Integer primesUpTo: 100 do:[:prime| g yield: prime]].
		[generator atEnd] whileFalse:[ str nextPutAll: generator next printString; cr]]
]

{ #category : #testing }
ProcessSemaphoreGenerator >> atEnd [
	^ finished
]

{ #category : #accessing }
ProcessSemaphoreGenerator >> next [
	"Take next value, and release generator"
	|next|
	finished ifTrue: [ ^nil ].
	clientSem wait.
	next := nextVal.
	genSem signal.
	^ next 
]

{ #category : #'instance creation' }
ProcessSemaphoreGenerator >> on: genBlock [
	clientSem := Semaphore new.
	genSem := Semaphore new.
	finished := false.
	[ genBlock value: self. finished := true. clientSem signal] fork
	

]

{ #category : #accessing }
ProcessSemaphoreGenerator >> peek [
	^ nextVal
]

{ #category : #public }
ProcessSemaphoreGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientSem signal.
	genSem wait.
	
]
