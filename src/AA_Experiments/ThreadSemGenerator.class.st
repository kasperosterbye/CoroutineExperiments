Class {
	#name : #ThreadSemGenerator,
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
ThreadSemGenerator class >> on: genBlock [
	^ self new on: genBlock.
]

{ #category : #'instance creation' }
ThreadSemGenerator class >> somePrimes [
	"self somePrimes" 
	<example>
	^ String streamContents: [ :str | 
		| generator |
		generator := self on: [:g| Integer primesUpTo: 100 do:[:prime| g yield: prime]].
		[generator atEnd] whileFalse:[ str nextPutAll: generator next printString; cr]]
]

{ #category : #testing }
ThreadSemGenerator >> atEnd [
	^ self hasNext 
]

{ #category : #testing }
ThreadSemGenerator >> hasNext [
	|hasNext|
	clientSem wait.
	hasNext := finished not.
	clientSem signal.
	^ hasNext
]

{ #category : #accessing }
ThreadSemGenerator >> next [
	"Take next value, and release generator"
	|next|
	clientSem wait.
	next := nextVal.
	genSem signal.
	^ next 
]

{ #category : #'instance creation' }
ThreadSemGenerator >> on: genBlock [
	clientSem := Semaphore new.
	genSem := Semaphore new.
	finished := false.
	[ genBlock value: self. finished := true. clientSem signal] fork
	

]

{ #category : #public }
ThreadSemGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientSem signal.
	genSem wait.
	
]
