"
A ThreadGeneratorTest is a test class for testing the behavior of ThreadGenerator
"
Class {
	#name : #ProcessGeneratorTest,
	#superclass : #TestCase,
	#category : #'AA_Experiments'
}

{ #category : #tests }
ProcessGeneratorTest >> allIn: gen [
	|col|
	col := OrderedCollection new.
	[ gen hasNext ] whileTrue: [ col add: gen next ].
	^ col
]

{ #category : #tests }
ProcessGeneratorTest >> eatAllIn: gen [
	
	[ gen atEnd ] whileTrue: [ gen next ]
]

{ #category : #tests }
ProcessGeneratorTest >> test10Elements [
	|col|
	col := self allIn: (ProcessSuspendGenerator on: [ :g | 1 to: 10 do: [:i | g yield: i]  ]).
	self assert: col asArray equals: #(1 2 3 4 5 6 7 8 9 10)
]

{ #category : #tests }
ProcessGeneratorTest >> test1Element [
	|col|
	col := self allIn: (ProcessSuspendGenerator on: [ :g | g yield: 99]).
	self assert: col asArray equals: #(99)
]

{ #category : #tests }
ProcessGeneratorTest >> testEmpty [
	|col|
	col := self allIn: (ProcessSuspendGenerator on: [ :g | ]).
	self assert: col isEmpty
]

{ #category : #tests }
ProcessGeneratorTest >> testSpeedCompare [
	|N threadGenerator contextGenerator threadTime contextTime|
	N := 1000.
	threadGenerator := ProcessSuspendGenerator on: [ :g | 1 to: N do: [:i | g yield: i] ].
	contextGenerator := Generator on: [ :g | 1 to: N do: [:i | g yield: i]  ].
	threadTime := Time microsecondsToRun: 
		[self eatAllIn:  threadGenerator ].
	contextTime := Time microsecondsToRun: 
		[self eatAllIn: contextGenerator].
	self assert: threadTime < contextTime
]

{ #category : #tests }
ProcessGeneratorTest >> testSpeedCompare_ThreadBased [
	|N semaphoreGenerator suspendGenerator semTime suspendTime|
	N := 10*1000*1000.
	semaphoreGenerator := ProcessSemaphoreGenerator on: [ :g | 1 to: N do: [:i | g yield: i] ].
	suspendGenerator := ProcessSuspendGenerator  on: [ :g | 1 to: N do: [:i | g yield: i]  ].
	semTime := Time microsecondsToRun: 
		[self eatAllIn:  semaphoreGenerator ].
	suspendTime := Time microsecondsToRun: 
		[self eatAllIn: suspendGenerator].
	self assert: semTime < suspendTime
]
