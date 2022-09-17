"
I am a generator where the generator is run in a separate process.
The client and generator synchronize using two semaphores.
"
Class {
	#name : #GenProcessSemaphoreGenerator,
	#superclass : #GenAbstractGenerator,
	#instVars : [
		'nextVal',
		'finished',
		'genProcess',
		'clientProcess',
		'savedGenBlock',
		'semNextReady',
		'holdGenerator'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #accessing }
GenProcessSemaphoreGenerator >> atEnd [
	"(finished not and: [semNextReady isSignaled ])ifFalse:[ semNextReady wait. semNextReady signal.]."
	^ finished
]

{ #category : #'open/close' }
GenProcessSemaphoreGenerator >> close [
	genProcess terminate.
	finished := true.
]

{ #category : #accessing }
GenProcessSemaphoreGenerator >> next [
	"Take next value, and release generator"
	|next|
	finished ifTrue: [ ^nil ].
	next := nextVal.
	holdGenerator signal.
	"wait for next value to be computed"
	semNextReady wait.
	^ next 
]

{ #category : #'instance creation' }
GenProcessSemaphoreGenerator >> on: genBlock [
	clientProcess := Processor activeProcess.
	savedGenBlock := genBlock.
	semNextReady := Semaphore new.
	holdGenerator := Semaphore new.
	finished := false.
	genProcess := [
		[genBlock value: self] 
			on: Error 
			do: [:err | clientProcess signalException: err].
		finished := true. 
		semNextReady signal] fork.
	semNextReady wait.
	

]

{ #category : #accessing }
GenProcessSemaphoreGenerator >> peek [
	"(finished not and: [semNextReady isSignaled ])ifFalse:[ semNextReady wait. semNextReady signal.]."
	^ nextVal
]

{ #category : #initialization }
GenProcessSemaphoreGenerator >> reset [
	genProcess terminate.
	self on: savedGenBlock 
	
]

{ #category : #public }
GenProcessSemaphoreGenerator >> yield: aValue [
	"Yield the value to client, and wait for consumption (next call)"
	nextVal := aValue.
	semNextReady signal.
	holdGenerator wait.
	
]
