"
I am a simple circular fifo buffer to add and take elements.

## Instance variables
- buffer - Fixed size array
- in - index of last inserted element
- out - index of next element to take.
"
Class {
	#name : #GenBuffer,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'in',
		'out',
		'size'
	],
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #'instance creation' }
GenBuffer class >> new: size [
	^ self basicNew initialize: size
]

{ #category : #adding }
GenBuffer >> add: elem [
	self isFull ifTrue: [ Error signal: 'buffer full' ].
	in := self increment: in.
	buffer at: in put: elem.
	size := size +1
]

{ #category : #initialization }
GenBuffer >> clear [
	
	in := 0.
	out := 1.
	size := 0.
]

{ #category : #'private utilities' }
GenBuffer >> increment: index [
	^ (index % buffer size) + 1
]

{ #category : #initialization }
GenBuffer >> initialize [
	self initialize: 10.
]

{ #category : #initialization }
GenBuffer >> initialize: bufSize [
	super initialize.
	buffer := Array new: bufSize.
	self clear.
]

{ #category : #testing }
GenBuffer >> isEmpty [
	^ size = 0
]

{ #category : #testing }
GenBuffer >> isFull [
	^ size = buffer size
]

{ #category : #accessing }
GenBuffer >> peek [
	self isEmpty ifTrue: [ Error signal: 'buffer empty' ].
	^ buffer at: out
]

{ #category : #adding }
GenBuffer >> take [
	|elem|
	self isEmpty ifTrue: [ Error signal: 'buffer empty' ].
	elem := buffer at: out.
	out := self increment: out.
	size := size - 1.
	^ elem
]
