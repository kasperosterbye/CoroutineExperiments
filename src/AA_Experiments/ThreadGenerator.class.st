"
I am a class to experiment with a thread based Generator.

```
""Playground""
SmalltalkImage current garbageCollect. 8.

gen := (ThreadGenerator on: [ :gen | 1 to: 10 do: [:i | gen yield: i] ]).
gen := ThreadGenerator on: [ :gen | gen yield: 99 ].
gen next.
gen hasNext.

col := OrderedCollection new.[ gen hasNext ] whileTrue: [ col add: gen next ].col.
```
"
Class {
	#name : #ThreadGenerator,
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
ThreadGenerator class >> on: genBlock [
	^ self new on: genBlock.
]

{ #category : #'instance creation' }
ThreadGenerator class >> somePrimes [
	"self somePrimes" 
	<example>
	^ String streamContents: [ :str | 
		| generator |
		generator := self on: [:g| Integer primesUpTo: 100 do:[:prime| g yield: prime]].
		[generator atEnd] whileFalse:[ str nextPutAll: generator next printString; cr]]
]

{ #category : #testing }
ThreadGenerator >> atEnd [
	^ self hasNext 
]

{ #category : #testing }
ThreadGenerator >> hasNext [
	|hasNext|
	clientSem wait.
	hasNext := finished not.
	clientSem signal.
	^ hasNext
]

{ #category : #accessing }
ThreadGenerator >> next [
	"Take next value, and release generator"
	|next|
	clientSem wait.
	next := nextVal.
	genSem signal.
	^ next 
]

{ #category : #'instance creation' }
ThreadGenerator >> on: genBlock [
	clientSem := Semaphore new.
	genSem := Semaphore new.
	finished := false.
	thisContext halt.
	[ genBlock value: self. finished := true. clientSem signal] fork
	

]

{ #category : #public }
ThreadGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientSem signal.
	genSem wait.
	
]
