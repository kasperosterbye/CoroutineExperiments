"
I am a generator where the generator is run in a separate process.
The client and generator synchronize using suspend/resume.
"
Class {
	#name : #GenProcessSuspendGenerator,
	#superclass : #GenAbstractGenerator,
	#instVars : [
		'nextVal',
		'finished',
		'genProcess',
		'clientProcess',
		'savedGenBlock'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #testing }
GenProcessSuspendGenerator >> atEnd [
	^ finished
]

{ #category : #'open/close' }
GenProcessSuspendGenerator >> close [
	genProcess terminate.
	finished := true.
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
	savedGenBlock := genBlock.
	finished := false.
	clientProcess := Processor activeProcess.
	genProcess := [ 
		[genBlock value: self] 
			on: Error 
			do: [:err |
				clientProcess signalException: err]. 
		finished := true. 
		clientProcess resume] newProcess.
	genProcess resume.
	clientProcess suspend.

]

{ #category : #accessing }
GenProcessSuspendGenerator >> peek [
	^ nextVal 
]

{ #category : #initialization }
GenProcessSuspendGenerator >> reset [
	genProcess terminate.
	self on: savedGenBlock 
	
]

{ #category : #public }
GenProcessSuspendGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	clientProcess resume.
	genProcess suspend.
	
]
