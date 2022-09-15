"
I am a generator based on the simple coroutine, thus giving no error propagation in case of errors in the generator.
"
Class {
	#name : #GenSimpleGenerator,
	#superclass : #GenAbstractGenerator,
	#instVars : [
		'coroutine',
		'next'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #testing }
GenSimpleGenerator >> atEnd [
	^ coroutine isTerminated 
]

{ #category : #accessing }
GenSimpleGenerator >> contents [
	"Answer the contents of this generator. Do not call this method on infinite generators."

	| stream |
	stream := (Array new: 10) writeStream.
	[ self atEnd ]
		whileFalse: [ stream nextPut: self next ].
	^ stream contents
]

{ #category : #accessing }
GenSimpleGenerator >> next [
	| currentNext |
	self atEnd ifTrue: [ ^ nil ].
	currentNext := next.
	next := coroutine attach.
	^ currentNext 
]

{ #category : #accessing }
GenSimpleGenerator >> nextPut: aValue [
	^ self yield: aValue
]

{ #category : #accessing }
GenSimpleGenerator >> on: aBlock [
	coroutine := GenSimpleCoroutine on: [:co | aBlock value: self ].
	next := coroutine attach.
]

{ #category : #public }
GenSimpleGenerator >> peek [
	^ next
]

{ #category : #public }
GenSimpleGenerator >> yield: aValue [
	| currentNext |
	currentNext := next.
	next := coroutine suspend: aValue.
	^ currentNext
]
