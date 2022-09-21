"
I implement a generator similar to `Generator`, but as a subclass of Coroutine.
"
Class {
	#name : #GenCoGenerator,
	#superclass : #GenAbstractGenerator,
	#instVars : [
		'coroutine',
		'next',
		'resetBlock'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #testing }
GenCoGenerator >> atEnd [
	^ coroutine isTerminated 
]

{ #category : #'open/close' }
GenCoGenerator >> close [
	coroutine terminate.
]

{ #category : #accessing }
GenCoGenerator >> contents [
	"Answer the contents of this generator. Do not call this method on infinite generators."

	| stream |
	stream := (Array new: 10) writeStream.
	[ self atEnd ]
		whileFalse: [ stream nextPut: self next ].
	^ stream contents
]

{ #category : #initialization }
GenCoGenerator >> coroutineClass [
	self subclassResponsibility
]

{ #category : #accessing }
GenCoGenerator >> next [
	| currentNext |
	self atEnd ifTrue: [ ^ nil ].
	currentNext := next.
	next := coroutine attach.
	^ currentNext 
]

{ #category : #accessing }
GenCoGenerator >> nextPut: aValue [
	^ self yield: aValue
]

{ #category : #accessing }
GenCoGenerator >> on: aBlock [
	resetBlock := aBlock.
	coroutine := self coroutineClass on: [:co | aBlock value: self ].
	next := coroutine attach.
]

{ #category : #public }
GenCoGenerator >> peek [
	^ next
]

{ #category : #initialization }
GenCoGenerator >> reset [
	coroutine terminate.
	self on: resetBlock
]

{ #category : #public }
GenCoGenerator >> yield: aValue [
	| currentNext |
	currentNext := next.
	next := coroutine suspend: aValue.
	^ currentNext
]
