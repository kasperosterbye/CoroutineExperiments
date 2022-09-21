"
I measure execution times
"
Class {
	#name : #GenExperimentTimer,
	#superclass : #Object,
	#instVars : [
		'blockReps',
		'measureReps'
	],
	#category : #'GeneratorExperiments-Performance'
}

{ #category : #accessing }
GenExperimentTimer >> blockReps: anObject [

	blockReps := anObject
]

{ #category : #performance }
GenExperimentTimer >> forkingMinFor: block [ 
	"return minimal execution time (least noice) in nanoseconds for blockReps executions of block.
	Fork actual experiment at high process priority to reduce noice"
	| experimenter awaitDone minTime| 
	awaitDone := Semaphore new.
	experimenter := [
		minTime :=  Time microsecondsToRun:  [ blockReps timesRepeat: block ].
		measureReps-1 timesRepeat: [ 
			minTime := minTime min: (Time microsecondsToRun:   [ blockReps timesRepeat: block ]) ].
		awaitDone signal.
	] newProcess.
	experimenter
		priority: 80;
		resume.
	awaitDone wait.
	^ minTime
]

{ #category : #performance }
GenExperimentTimer >> forkingNanoMinFor: block [ 
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
GenExperimentTimer >> measureReps: anObject [
	measureReps := anObject
]

{ #category : #performance }
GenExperimentTimer >> microToRun: aBlock [
	| start |
	start := self nanoSeconds.
	aBlock value"Unpreemptively".
	^ ((self nanoSeconds - start ) / 1000 ) asInteger
]

{ #category : #performance }
GenExperimentTimer >> minFor: block [ 
	"return minimal execution time (least noice) in microseconds for blockReps executions of block"
	| minTime| 
	minTime :=  (self microToRun: [ blockReps timesRepeat: block ]).
	measureReps-1 timesRepeat: [ 
		minTime := minTime min: (self microToRun: [ blockReps timesRepeat: block ]) ].
	^ minTime
]

{ #category : #performance }
GenExperimentTimer >> nanoMinFor: block [ 
	"return minimal execution time (least noice) in microseconds for blockReps executions of block"
	| minTime| 
	minTime :=  self nanoToRun: [ blockReps timesRepeat: block ].
	measureReps-1 timesRepeat: [ 
		minTime := minTime min: (self nanoToRun:  [ blockReps timesRepeat: block ]) ].
	^ minTime
]

{ #category : #performance }
GenExperimentTimer >> nanoSeconds [ 
	"Stolen from malltalk highResClock"
	<primitive: 'primitiveHighResClock'>
	^0
]

{ #category : #performance }
GenExperimentTimer >> nanoToRun: aBlock [
	| start |
	start := self nanoSeconds.
	aBlock value.
	^ self nanoSeconds - start 
]
