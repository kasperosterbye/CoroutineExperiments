"
I compute bufSize elements at a time (using repeated calls to yield). 
Elements are still read one at a time.
"
Class {
	#name : #GenBufferingSuspendGenerator,
	#superclass : #GenAbstractGenerator,
	#instVars : [
		'finished',
		'genProcess',
		'clientProcess',
		'savedGenBlock',
		'buffer',
		'index'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #testing }
GenBufferingSuspendGenerator >> atEnd [
	^ finished and: [ index = 0 ]
]

{ #category : #'open/close' }
GenBufferingSuspendGenerator >> close [
	genProcess terminate.
	finished := true.
]

{ #category : #accessing }
GenBufferingSuspendGenerator >> next [
	"Take next value, and release generator"
	|next|
	self atEnd ifTrue: [ ^nil ].
	next := buffer at: index.
	index := index - 1.
	(finished not and: [ index = 0 ]) ifTrue: [ 
		genProcess resume.
		clientProcess suspend].
	^ next 
]

{ #category : #'instance creation' }
GenBufferingSuspendGenerator >> on: genBlock [
	savedGenBlock := genBlock.
	index := 0.
	buffer := Array new: 10.
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
GenBufferingSuspendGenerator >> peek [
	^ buffer at: index 
]

{ #category : #initialization }
GenBufferingSuspendGenerator >> reset [
	genProcess terminate.
	self on: savedGenBlock 
	
]

{ #category : #public }
GenBufferingSuspendGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	index := index + 1.
	buffer at: index put: aValue .
	index < buffer size 
		ifTrue: [ ^ self ].
	"Buffer full, let the client consume"
	clientProcess resume.
	genProcess suspend 
]
