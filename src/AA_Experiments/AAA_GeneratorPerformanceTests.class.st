Class {
	#name : #'AAA_GeneratorPerformanceTests',
	#superclass : #Object,
	#category : #'AA_Experiments'
}

{ #category : #'as yet unclassified' }
AAA_GeneratorPerformanceTests >> performMeasurementNumbers [
	| candidates timer |
	candidates := { AAA_Generator. AAA_SimpleGenerator. ProcessSemaphoreGenerator. ProcessSuspendGenerator. Generator}.
	timer := AAA_ExperimentTimer new
		blockReps: 100;
		measureReps: 1000.
	^ candidates collect: [ :generator |
		Smalltalk garbageCollect.
		generator name -> (timer forkingMinFor: [ | gen |
			gen := self yieldNumbers: generator.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]

{ #category : #'as yet unclassified' }
AAA_GeneratorPerformanceTests >> performMeasurementPrimes [
	| candidates timer |
	candidates := { AAA_Generator. AAA_SimpleGenerator. ProcessSemaphoreGenerator. ProcessSuspendGenerator. Generator}.
	timer := AAA_ExperimentTimer new
		blockReps: 1;
		measureReps: 500.
	^ candidates collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := self yieldPrimes: generator.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]

{ #category : #'as yet unclassified' }
AAA_GeneratorPerformanceTests >> yieldNumbers: generatorClass [
	^ generatorClass on: [ :gen | 
		(1 to: 10) do: [ :i | gen yield: i ] ].
]

{ #category : #'as yet unclassified' }
AAA_GeneratorPerformanceTests >> yieldPrimes: generatorClass [
	^ generatorClass on: [ :gen | 
		(1000000 to: 1100000) do: [ :i | i isPrime ifTrue: [ gen yield: i ] ] ].
]
