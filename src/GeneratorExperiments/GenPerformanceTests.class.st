"
I perform a number of different performance tests on the five generator implementations
"
Class {
	#name : #GenPerformanceTests,
	#superclass : #Object,
	#category : #'GeneratorExperiments-Performance'
}

{ #category : #subjects }
GenPerformanceTests >> generators [
	^ { GenGenerator. GenSimpleGenerator. GenProcessSemaphoreGenerator. GenProcessSuspendGenerator. Generator}.
	
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementNumbers [
	| generatorBody timer |
	generatorBody := [ :gen | 
		1 to: 10000 do: [ :i | gen yield: i ] ].
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 300.
	^ self generators collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := generator on: generatorBody.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementPrimes [
	| generatorBody timer |
	generatorBody := [ :gen | 
		1000000 to: 1100000 do: [ :i | i isPrime ifTrue: [ gen yield: i ] ] ].
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 500.
	^ self generators collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := generator on: generatorBody.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementSorting [
	| sorter task timer |
	sorter := GeneratorSort new.
	task := sorter testSize: 100.
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 200.
	^ (self generators collect: [ :generator |
		sorter generatorClass: generator.
		generator name -> (timer minFor: [ sorter sort: task ])]) asDictionary
]
