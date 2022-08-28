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
		'genThread',
		'sem',
		'nextVal',
		'nextReturn',
		'finished'
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
ThreadGenerator >> hasNext [
	^ finished not
]

{ #category : #accessing }
ThreadGenerator >> next [
	genThread resume.
	sem wait.
	finished ifTrue: [ ^ nil ].
	^ nextVal 
]

{ #category : #'instance creation' }
ThreadGenerator >> on: genBlock [
	sem := Semaphore new.
	finished := false.
	genThread := [ genBlock value: self. finished := true. sem signal ] newProcess.
	genThread resume.
	

]

{ #category : #public }
ThreadGenerator >> yield: aValue [
	nextVal := aValue.
	sem signal.
	genThread suspend.
	
]
