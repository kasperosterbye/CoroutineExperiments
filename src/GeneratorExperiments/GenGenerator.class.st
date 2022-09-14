"
I implement a generator similar to `Generator`, but as a subclass of Coroutine.
"
Class {
	#name : #GenGenerator,
	#superclass : #Stream,
	#instVars : [
		'coroutine',
		'next',
		'resetBlock'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #'instance creation' }
GenGenerator class >> on: block [
	^ self basicNew on: block
]

{ #category : #testing }
GenGenerator >> atEnd [
	^ coroutine isTerminated 
]

{ #category : #'open/close' }
GenGenerator >> close [
	coroutine terminate.
]

{ #category : #accessing }
GenGenerator >> contents [
	"Answer the contents of this generator. Do not call this method on infinite generators."

	| stream |
	stream := (Array new: 10) writeStream.
	[ self atEnd ]
		whileFalse: [ stream nextPut: self next ].
	^ stream contents
]

{ #category : #accessing }
GenGenerator >> next [
	| currentNext |
	self atEnd ifTrue: [ ^ nil ].
	currentNext := next.
	next := coroutine attach.
	^ currentNext 
]

{ #category : #accessing }
GenGenerator >> nextPut: aValue [
	^ self yield: aValue
]

{ #category : #accessing }
GenGenerator >> on: aBlock [
	resetBlock := aBlock.
	coroutine := GenCoroutine on: [:co | aBlock value: self ].
	next := coroutine attach.
]

{ #category : #public }
GenGenerator >> peek [
	^ next
]

{ #category : #initialization }
GenGenerator >> reset [
	coroutine terminate.
	self on: resetBlock
]

{ #category : #public }
GenGenerator >> yield: aValue [
	| currentNext |
	currentNext := next.
	next := coroutine suspend: aValue.
	^ currentNext
]
