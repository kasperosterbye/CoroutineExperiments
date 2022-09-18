"
I am basic coroutine. My behaviour is defined using a block.

I am not running when created, but must be explicitly started using the `attach` method.

When attached, I run until my next call to `suspend` or `suspend:` (or until terminate). 

The `suspend:` argument is returned as the result of the attach call. The argument of `attach:` becomes the result of my the `suspend:` I am resuming from. See `testAttachValueReturn` and `testSuspendValueReturn` in my test class for examples.

### Instance variables
- suspensionPoint keeps to context I will be resuming, or if I am running, the context of my attacher.
- terminated boolean telling if my block is terminated.
- transfer - keeps the value passed back and forth between `attach:` and `suspend:`
"
Class {
	#name : #GenSwapCoroutine,
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
GenSwapCoroutine class >> on: block [
	^ self new on: block
]

{ #category : #coroutine }
GenSwapCoroutine >> attach [
	^ self attach: nil.
]

{ #category : #coroutine }
GenSwapCoroutine >> attach: returnValue [
	terminated ifTrue: [ GenCoroutineTerminated signal ].
	transfer := returnValue.
	"attach the coroutine, and store caller in suspensionPoint"
	suspensionPoint := thisContext swapSender: suspensionPoint.
	"Coroutine suspended - return value from suspend:"
	^ transfer.
]

{ #category : #coroutine }
GenSwapCoroutine >> isTerminated [
	^ terminated
]

{ #category : #'instance creation' }
GenSwapCoroutine >> on: block [
	suspensionPoint := thisContext.
	self run: block 
	
]

{ #category : #'instance creation' }
GenSwapCoroutine >> run: block [

	terminated := false.
	unwindTo := thisContext.
	self suspend: self.
	[ unwindTo := thisContext.
	  block value: self]
		on: Error
		do: [ :err | transfer := #CoroutineSignal -> err ].
	terminated := true.
	"transfer might be an error message"
	self suspend: transfer
]

{ #category : #coroutine }
GenSwapCoroutine >> suspend [
	^ self suspend: nil
]

{ #category : #coroutine }
GenSwapCoroutine >> suspend: returnValue [
	transfer := returnValue.
	"resume caller of attach, and store my progress in suspensionPoint"
	suspensionPoint := thisContext swapSender: suspensionPoint.
	terminated ifTrue: [
		(transfer isAssociation and: [ transfer key = #CoroutineSignal ])
			ifTrue: [ 
				transfer value signal.
				thisContext unwindTo: unwindTo].
		^ nil  ].
	"I have been reattached, return value set by attach:"
	^ transfer 
]

{ #category : #'debugging actions' }
GenSwapCoroutine >> terminate [
	terminated ifTrue: [ ^self ].
	suspensionPoint unwindTo: unwindTo.
	suspensionPoint := unwindTo.
	terminated := true.
	suspensionPoint := thisContext swapSender: suspensionPoint
	
]
