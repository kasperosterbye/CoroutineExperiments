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
	#name : #ThreadSuspendGenerator,
	#superclass : #Object,
	#instVars : [
		'nextVal',
		'nextReturn',
		'finished',
		'clientSem',
		'genProcess'
	],
	#category : #'AA_Experiments'
}

{ #category : #'instance creation' }
ThreadSuspendGenerator class >> on: genBlock [
	^ self new on: genBlock.
]

{ #category : #'instance creation' }
ThreadSuspendGenerator class >> somePrimes [
	"self somePrimes" 
	<example>
	^ String streamContents: [ :str | 
		| generator |
		generator := self on: [:g| Integer primesUpTo: 100 do:[:prime| g yield: prime]].
		[generator atEnd] whileFalse:[ str nextPutAll: generator next printString; cr]]
]

{ #category : #testing }
ThreadSuspendGenerator >> atEnd [
	^ self hasNext 
]

{ #category : #testing }
ThreadSuspendGenerator >> hasNext [
	|hasNext|
	clientSem wait.
	hasNext := finished not.
	clientSem signal.
	^ hasNext
]

{ #category : #accessing }
ThreadSuspendGenerator >> next [
	"Take next value, and release generator"
	|next|
	clientSem wait.
	next := nextVal.
	genProcess resume.
	^ next 
]

{ #category : #'instance creation' }
ThreadSuspendGenerator >> on: genBlock [
	clientSem := Semaphore new.
	genProcess := Semaphore new.
	finished := false.
	genProcess := [ genBlock value: self. finished := true. clientSem signal] newProcess.
	genProcess resume.

]

{ #category : #public }
ThreadSuspendGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientSem signal.
	genProcess suspend.
	
]
