"
I implement a simple generator.
The generator is run in a seperate process. 
The client and the generator never run at the same time, controlled by suspend and resume.
"
Class {
	#name : #GenProcessSuspendGenerator,
	#superclass : #GenAbstractGenerator,
	#instVars : [
		'nextVal',
		'nextReturn',
		'finished',
		'genProcess',
		'clientProcess'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #testing }
GenProcessSuspendGenerator >> atEnd [
	^ finished
]

{ #category : #accessing }
GenProcessSuspendGenerator >> next [
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
GenProcessSuspendGenerator >> on: genBlock [
	finished := false.
	clientProcess := Processor activeProcess.
	genProcess := [ genBlock value: self. finished := true. clientProcess resume] newProcess.
	genProcess resume.
	clientProcess suspend.

]

{ #category : #accessing }
GenProcessSuspendGenerator >> peek [
	^ nextVal 
]

{ #category : #public }
GenProcessSuspendGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientProcess resume.
	genProcess suspend.
	
]
