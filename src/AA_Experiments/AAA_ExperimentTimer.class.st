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
