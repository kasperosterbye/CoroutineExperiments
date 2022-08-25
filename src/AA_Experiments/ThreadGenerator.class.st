"
I am a class to experiment with a thread based Generator.
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
	finished ifTrue: [ ^ nil ].
	genThread resume.
	sem wait.
	^ nextVal 
]

{ #category : #'instance creation' }
ThreadGenerator >> on: genBlock [
	sem := Semaphore new.
	finished := false.
	genThread := [ genBlock value: self. finished := true ] newProcess.
	

]

{ #category : #public }
ThreadGenerator >> yield: aValue [
	nextVal := aValue.
	sem signal.
	genThread suspend.
	
]
