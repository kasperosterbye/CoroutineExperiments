"
I am a coroutine implemented on top of a process. 

"
Class {
	#name : #GenSuspendCoroutine,
	#superclass : #Object,
	#instVars : [
		'coProcess',
		'clientProcess',
		'terminated',
		'transfer'
	],
	#category : #'GeneratorExperiments-Coroutines'
}

{ #category : #'instance creation' }
GenSuspendCoroutine class >> on: block [
	^ self new on: block
]

{ #category : #coroutine }
GenSuspendCoroutine >> attach [
	^ self attach: nil.
]

{ #category : #coroutine }
GenSuspendCoroutine >> attach: returnValue [
	"called by client process"
	| returnToClient |
	terminated ifTrue: [ GenCoroutineTerminated signal ].
	returnToClient := transfer.
	transfer := returnValue.
	"allow co-routine to be activated by different processes"
	clientProcess := Processor activeProcess.
	coProcess resume.
	clientProcess suspend.
	^ transfer.
]

{ #category : #coroutine }
GenSuspendCoroutine >> isTerminated [
	^ terminated
]

{ #category : #'instance creation' }
GenSuspendCoroutine >> on: block [
	terminated := false.
	coProcess := [	
		self suspend: self.
		[ [block value: self]
				on: Error
				do: [ :err | clientProcess signalException: err ]]
		ensure: [
				terminated := true.
				clientProcess resume].
	] newProcess.
	^ self attach 
]

{ #category : #coroutine }
GenSuspendCoroutine >> suspend [
	^ self suspend: nil
]

{ #category : #coroutine }
GenSuspendCoroutine >> suspend: returnValue [
	"called by co-process"
	transfer := returnValue.
	clientProcess resume.
	coProcess suspend.
	^ transfer 
]

{ #category : #'debugging actions' }
GenSuspendCoroutine >> terminate [
	terminated ifTrue: [ ^self ].
	terminated := true.
	clientProcess := Processor activeProcess.
	coProcess terminate.
	
]
