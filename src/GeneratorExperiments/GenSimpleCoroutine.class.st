"
I am a simpler implementation of `GenCoroutine` without error propagation and client side termination.
"
Class {
	#name : #GenSimpleCoroutine,
	#superclass : #Object,
	#instVars : [
		'suspensionPoint',
		'terminated',
		'transfer',
		'unwindTo'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #'instance creation' }
GenSimpleCoroutine class >> on: block [
	^ self new on: block
]

{ #category : #coroutine }
GenSimpleCoroutine >> attach [
	^ self attach: nil.
]

{ #category : #coroutine }
GenSimpleCoroutine >> attach: returnValue [
	terminated ifTrue: [ GenCoroutineTerminated signal ].
	transfer := returnValue.
	"attach the coroutine, and store caller in suspensionPoint"
	suspensionPoint := thisContext swapSender: suspensionPoint.
	"Coroutine suspended - return value from suspend:"
	^ transfer.
]

{ #category : #coroutine }
GenSimpleCoroutine >> isTerminated [
	^ terminated
]

{ #category : #'instance creation' }
GenSimpleCoroutine >> on: block [
	suspensionPoint := thisContext sender.
	terminated := false.
	self suspend: self.
	block value: self.
	terminated := true.
	self suspend: transfer
]

{ #category : #coroutine }
GenSimpleCoroutine >> suspend [
	^ self suspend: nil
]

{ #category : #coroutine }
GenSimpleCoroutine >> suspend: returnValue [
	transfer := returnValue.
	"resume caller of attach, and store my progress in suspensionPoint"
	suspensionPoint := thisContext swapSender: suspensionPoint.
	"I have been reattached, return value set by attach:"
	^ transfer 
]
