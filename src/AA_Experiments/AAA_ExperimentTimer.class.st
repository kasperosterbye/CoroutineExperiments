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
AAA_ExperimentTimer >> microsecondsFor: block [
	^ self microsecondsFor: block repeat: blockReps
]

{ #category : #'as yet unclassified' }
AAA_ExperimentTimer >> microsecondsFor: block repeat: n [
	^ Time microsecondsToRun: [ n timesRepeat: block ]
]

{ #category : #'as yet unclassified' }
AAA_ExperimentTimer >> minFor: block [
	^ self minFor: block of: measureReps
]

{ #category : #'as yet unclassified' }
AAA_ExperimentTimer >> minFor: block of: count [
	^ (1 to: count) 
		inject: Float fmax 
		into: [ :min :dummy | min min: (self microsecondsFor: block) ]
]
