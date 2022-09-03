"
I implement a simple generator.
The generator is run in a seperate process, and it synchronize with the client thread using two semaphores, one for waiting the client, and one for waiting the generator
"
Class {
	#name : #ProcessSemGenerator,
	#superclass : #Object,
	#instVars : [
		'nextVal',
		'nextReturn',
		'finished',
		'clientSem',
		'genSem'
	],
	#category : #'AA_Experiments'
}

{ #category : #'instance creation' }
ProcessSemGenerator class >> on: genBlock [
	^ self new on: genBlock.
]

{ #category : #'instance creation' }
ProcessSemGenerator class >> somePrimes [
	"self somePrimes" 
	<example>
	^ String streamContents: [ :str | 
		| generator |
		generator := self on: [:g| Integer primesUpTo: 100 do:[:prime| g yield: prime]].
		[generator atEnd] whileFalse:[ str nextPutAll: generator next printString; cr]]
]

{ #category : #testing }
ProcessSemGenerator >> atEnd [
	^ self hasNext 
]

{ #category : #testing }
ProcessSemGenerator >> hasNext [
	|hasNext|
	clientSem wait.
	hasNext := finished not.
	clientSem signal.
	^ hasNext
]

{ #category : #accessing }
ProcessSemGenerator >> next [
	"Take next value, and release generator"
	|next|
	clientSem wait.
	next := nextVal.
	genSem signal.
	^ next 
]

{ #category : #'instance creation' }
ProcessSemGenerator >> on: genBlock [
	clientSem := Semaphore new.
	genSem := Semaphore new.
	finished := false.
	[ genBlock value: self. finished := true. clientSem signal] fork
	

]

{ #category : #public }
ProcessSemGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientSem signal.
	genSem wait.
	
]
