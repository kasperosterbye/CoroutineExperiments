Class {
	#name : #'AAA_SimpleGenerator',
	#superclass : #Stream,
	#instVars : [
		'coroutine',
		'next',
		'resetBlock'
	],
	#category : #'AA_Experiments'
}

{ #category : #'instance creation' }
AAA_SimpleGenerator class >> on: block [
	^ self basicNew on: block
]

{ #category : #testing }
AAA_SimpleGenerator >> atEnd [
	^ coroutine isTerminated 
]

{ #category : #accessing }
AAA_SimpleGenerator >> contents [
	"Answer the contents of this generator. Do not call this method on infinite generators."

	| stream |
	stream := (Array new: 10) writeStream.
	[ self atEnd ]
		whileFalse: [ stream nextPut: self next ].
	^ stream contents
]

{ #category : #accessing }
AAA_SimpleGenerator >> next [
	| currentNext |
	self atEnd ifTrue: [ ^ nil ].
	currentNext := next.
	next := coroutine attach.
	^ currentNext 
]

{ #category : #accessing }
AAA_SimpleGenerator >> nextPut: aValue [
	^ self yield: aValue
]

{ #category : #accessing }
AAA_SimpleGenerator >> on: aBlock [
	resetBlock := aBlock.
	coroutine := AAA_SimpleCoroutine on: [:co | aBlock value: self ].
	next := coroutine attach.
]

{ #category : #public }
AAA_SimpleGenerator >> peek [
	^ next
]

{ #category : #public }
AAA_SimpleGenerator >> yield: aValue [
	| currentNext |
	currentNext := next.
	next := coroutine suspend: aValue.
	^ currentNext
]
