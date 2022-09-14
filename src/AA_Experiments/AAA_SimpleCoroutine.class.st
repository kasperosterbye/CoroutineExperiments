Class {
	#name : #'AAA_SimpleCoroutine',
	#superclass : #Object,
	#instVars : [
		'suspensionPoint',
		'terminated',
		'transfer',
		'unwindTo'
	],
	#category : #'AA_Experiments'
}

{ #category : #'instance creation' }
AAA_SimpleCoroutine class >> on: block [
	^ self new on: block
]

{ #category : #coroutine }
AAA_SimpleCoroutine >> attach [
	^ self attach: nil.
]

{ #category : #coroutine }
AAA_SimpleCoroutine >> attach: returnValue [
	terminated ifTrue: [ AAA_CoroutineTerminated signal ].
	transfer := returnValue.
	"attach the coroutine, and store caller in suspensionPoint"
	suspensionPoint := thisContext swapSender: suspensionPoint.
	"Coroutine suspended - return value from suspend:"
	^ transfer.
]

{ #category : #coroutine }
AAA_SimpleCoroutine >> isTerminated [
	^ terminated
]

{ #category : #'instance creation' }
AAA_SimpleCoroutine >> on: block [
	suspensionPoint := thisContext sender.
	terminated := false.
	self suspend: self.
	block value: self.
	terminated := true.
	self suspend: transfer
]

{ #category : #coroutine }
AAA_SimpleCoroutine >> suspend [
	^ self suspend: nil
]

{ #category : #coroutine }
AAA_SimpleCoroutine >> suspend: returnValue [
	transfer := returnValue.
	"resume caller of attach, and store my progress in suspensionPoint"
	suspensionPoint := thisContext swapSender: suspensionPoint.
	"I have been reattached, return value set by attach:"
	^ transfer 
]
