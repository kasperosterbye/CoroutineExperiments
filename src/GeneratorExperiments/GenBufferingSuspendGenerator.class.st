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
		'buffer'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #testing }
GenBufferingSuspendGenerator >> atEnd [
	^ finished and: [ buffer isEmpty ]
]

{ #category : #'open/close' }
GenBufferingSuspendGenerator >> close [
	genProcess terminate.
	buffer clear.
	finished := true.
]

{ #category : #accessing }
GenBufferingSuspendGenerator >> next [
	"Take next value, and release generator"
	|next|
	self atEnd ifTrue: [ ^nil ].
	next := buffer take.
	(next isKindOf: Error) ifTrue: [ next signal ].
	(finished not and: [ buffer isEmpty ] ) ifTrue: [ 
		genProcess resume.
		clientProcess suspend].
	^ next 
]

{ #category : #'instance creation' }
GenBufferingSuspendGenerator >> on: genBlock [
	savedGenBlock := genBlock.
	buffer := GenBuffer new: 100.
	finished := false.
	clientProcess := Processor activeProcess.
	genProcess := [ 
		[[genBlock value: self] 
			on: Error 
			do: [:err |
				buffer isEmpty
					ifTrue: [clientProcess signalException: err]
					ifFalse: [ buffer add: (GenGeneratorError new) ]
					]]
		ensure: [ 
			finished := true. 
			clientProcess resume]] newProcess.
	genProcess resume.
	clientProcess suspend.

]

{ #category : #accessing }
GenBufferingSuspendGenerator >> peek [
	buffer isEmpty ifTrue: [ ^ nil ].
	^ buffer peek
]

{ #category : #initialization }
GenBufferingSuspendGenerator >> reset [
	genProcess terminate.
	self on: savedGenBlock 
	
]

{ #category : #public }
GenBufferingSuspendGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	buffer add: aValue .
	buffer isFull  
		ifFalse: [ ^ self ].
	"Buffer full, let the client consume"
	clientProcess resume.
	genProcess suspend 
]
