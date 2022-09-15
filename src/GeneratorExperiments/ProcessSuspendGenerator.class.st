"
I implement a simple generator.
The generator is run in a seperate process. 
The client and the generator never run at the same time, controlled by suspend and resume.
"
Class {
	#name : #ProcessSuspendGenerator,
	#superclass : #Object,
	#instVars : [
		'nextVal',
		'nextReturn',
		'finished',
		'genProcess',
		'clientProcess'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #'instance creation' }
ProcessSuspendGenerator class >> on: genBlock [
	^ self new on: genBlock.
]

{ #category : #'instance creation' }
ProcessSuspendGenerator class >> somePrimes [
	"self somePrimes" 
	<example>
	^ String streamContents: [ :str | 
		| generator |
		generator := self on: [:g| Integer primesUpTo: 100 do:[:prime| g yield: prime]].
		[generator atEnd] whileFalse:[ str nextPutAll: generator next printString; cr]]
]

{ #category : #testing }
ProcessSuspendGenerator >> atEnd [
	^ finished
]

{ #category : #accessing }
ProcessSuspendGenerator >> next [
	"Take next value, and release generator"
	|next|
	finished ifTrue: [ ^nil ].
	next := nextVal.
	clientProcess := Processor activeProcess.
	genProcess resume.
	clientProcess suspend.
	^ next 
]

{ #category : #'instance creation' }
ProcessSuspendGenerator >> on: genBlock [
	finished := false.
	clientProcess := Processor activeProcess.
	genProcess := [ genBlock value: self. finished := true. clientProcess resume] newProcess.
	genProcess resume.
	clientProcess suspend.

]

{ #category : #accessing }
ProcessSuspendGenerator >> peek [
	^ nextVal 
]

{ #category : #public }
ProcessSuspendGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientProcess resume.
	genProcess suspend.
	
]
