"
A ThreadGeneratorTest is a test class for testing the behavior of ThreadGenerator
"
Class {
	#name : #ThreadGeneratorTest,
	#superclass : #TestCase,
	#category : #'AA_Experiments'
}

{ #category : #tests }
ThreadGeneratorTest >> allIn: gen [
	|col|
	col := OrderedCollection new.
	[ gen hasNext ] whileTrue: [ col add: gen next ].
	^ col
]

{ #category : #tests }
ThreadGeneratorTest >> eatAllIn: gen [
	
	[ gen atEnd ] whileTrue: [ gen next ]
]

{ #category : #tests }
ThreadGeneratorTest >> test10Elements [
	|col|
	col := self allIn: (ThreadSuspendGenerator on: [ :g | 1 to: 10 do: [:i | g yield: i]  ]).
	self assert: col asArray equals: #(1 2 3 4 5 6 7 8 9 10)
]

{ #category : #tests }
ThreadGeneratorTest >> test1Element [
	|col|
	col := self allIn: (ThreadSuspendGenerator on: [ :g | g yield: 99]).
	self assert: col asArray equals: #(99)
]

{ #category : #tests }
ThreadGeneratorTest >> testEmpty [
	|col|
	col := self allIn: (ThreadSuspendGenerator on: [ :g | ]).
	self assert: col isEmpty
]

{ #category : #tests }
ThreadGeneratorTest >> testSpeedCompare [
	|N threadGenerator contextGenerator threadTime contextTime|
	N := 1000.
	threadGenerator := ThreadSuspendGenerator on: [ :g | 1 to: N do: [:i | g yield: i] ].
	contextGenerator := Generator on: [ :g | 1 to: N do: [:i | g yield: i]  ].
	threadTime := Time microsecondsToRun: 
		[self eatAllIn:  threadGenerator ].
	contextTime := Time microsecondsToRun: 
		[self eatAllIn: contextGenerator].
	self assert: threadTime < contextTime
]
