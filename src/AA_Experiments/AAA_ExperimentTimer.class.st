"
I measure execution times
"
Class {
	#name : #'AAA_ExperimentTimer',
	#superclass : #Object,
	#instVars : [
		'blockReps',
		'measureReps'
	],
	#category : #'AA_Experiments'
}

{ #category : #accessing }
AAA_ExperimentTimer >> blockReps: anObject [

	blockReps := anObject
]

{ #category : #'as yet unclassified' }
AAA_ExperimentTimer >> forkingNanoMinFor: block [ 
	"return minimal execution time (least noice) in nanoseconds for blockReps executions of block.
	Fork actual experiment at high process priority to reduce noice"
	| experimenter awaitDone minTime| 
	awaitDone := Semaphore new.
	experimenter := [
		minTime :=  self nanoToRun: [ blockReps timesRepeat: block ].
		measureReps-1 timesRepeat: [ 
			minTime := minTime min: (self nanoToRun:  [ blockReps timesRepeat: block ]) ].
		awaitDone signal.
	] newProcess.
	experimenter
		priority: 80;
		resume.
	awaitDone wait.
	^ minTime
]

{ #category : #accessing }
AAA_ExperimentTimer >> measureReps: anObject [
	measureReps := anObject
]

{ #category : #'as yet unclassified' }
AAA_ExperimentTimer >> minFor: block [ 
	"return minimal execution time (least noice) in microseconds for blockReps executions of block"
	| minTime| 
	minTime :=  (Time microsecondsToRun: [ blockReps timesRepeat: block ]).
	measureReps-1 timesRepeat: [ 
		minTime := minTime min: (Time microsecondsToRun: [ blockReps timesRepeat: block ]) ].
	^ minTime
]

{ #category : #'as yet unclassified' }
AAA_ExperimentTimer >> nanoMinFor: block [ 
	"return minimal execution time (least noice) in microseconds for blockReps executions of block"
	| minTime| 
	minTime :=  self nanoToRun: [ blockReps timesRepeat: block ].
	measureReps-1 timesRepeat: [ 
		minTime := minTime min: (self nanoToRun:  [ blockReps timesRepeat: block ]) ].
	^ minTime
]

{ #category : #'as yet unclassified' }
AAA_ExperimentTimer >> nanoSeconds [ 
	"Stolen from malltalk highResClock"
	<primitive: 'primitiveHighResClock'>
	^0
]

{ #category : #performance }
AAA_ExperimentTimer >> nanoToRun: aBlock [
	| start |
	start := self nanoSeconds.
	aBlock value.
	^ self nanoSeconds - start 
]
