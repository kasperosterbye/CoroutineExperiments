"
I implement a generator similar to `Generator`, but as a subclass of Coroutine.
"
Class {
	#name : #'AAA_Generator',
	#superclass : #Stream,
	#instVars : [
		'coroutine',
		'next',
		'resetBlock'
	],
	#category : #'AA_Experiments'
}

{ #category : #'instance creation' }
AAA_Generator class >> on: block [
	^ self basicNew on: block
]

{ #category : #accessing }
AAA_Generator >> contents [
	"Answer the contents of this generator. Do not call this method on infinite generators."

	| stream |
	stream := (Array new: 10) writeStream.
	[ self atEnd ]
		whileFalse: [ stream nextPut: self next ].
	^ stream contents
]

{ #category : #accessing }
AAA_Generator >> nextPut: aValue [
	^ self yield: aValue
]

{ #category : #accessing }
AAA_Generator >> on: aBlock [
	resetBlock := aBlock.
	coroutine := AAA_Coroutine on: [:co | aBlock value: self ].
	next := coroutine attach.
]

{ #category : #public }
AAA_Generator >> peek [
	^ next
]

{ #category : #initialization }
AAA_Generator >> reset [
	coroutine terminate.
	self on: resetBlock
]

{ #category : #public }
AAA_Generator >> yield: aValue [
	| currentNext |
	currentNext := next.
	next := coroutine suspend: aValue.
	^ currentNext
]
