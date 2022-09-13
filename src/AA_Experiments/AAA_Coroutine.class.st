"
I am basic coroutine. My behaviour is defined using a block.

I am not running when created, but must be explicitly started using the `attach` method.

When attached, I runs until my next call to `suspend` or `suspend:`. The `suspend:` argument is returned as the result of the attach call. The argument of `attach:` becomes the result of my the `suspend:` I am resuming from.

### Instance variables
- suspensionPoint keeps to context I will be resuming, or if I am running, the context of my attacher.
"
Class {
	#name : #'AAA_Coroutine',
	#superclass : #Object,
	#instVars : [
		'suspensionPoint',
		'terminated',
		'transfer'
	],
	#category : #'AA_Experiments'
}

{ #category : #'instance creation' }
AAA_Coroutine class >> on: block [
	^ self new on: block
]

{ #category : #coroutine }
AAA_Coroutine >> attach [
	terminated ifTrue: [ AAA_CoroutineTerminated signal ].
	transfer := nil.
	suspensionPoint := thisContext swapSender: suspensionPoint.
	^ transfer.
]

{ #category : #coroutine }
AAA_Coroutine >> attach: returnValue [
	terminated ifTrue: [ AAA_CoroutineTerminated signal ].
	transfer := returnValue.
	suspensionPoint := thisContext swapSender: suspensionPoint.
	^ transfer.
]

{ #category : #coroutine }
AAA_Coroutine >> isTerminated [
	^ terminated
]

{ #category : #'instance creation' }
AAA_Coroutine >> on: block [
	terminated := false.
	suspensionPoint := thisContext sender.
	self suspend: self.
	block value: self.
	terminated := true.
	self suspend
	
]

{ #category : #coroutine }
AAA_Coroutine >> suspend [
	transfer := nil.
	suspensionPoint := thisContext swapSender: suspensionPoint.
	^ transfer
]

{ #category : #coroutine }
AAA_Coroutine >> suspend: returnValue [
	transfer := returnValue.
	suspensionPoint := thisContext swapSender: suspensionPoint.
	^ transfer 
]
