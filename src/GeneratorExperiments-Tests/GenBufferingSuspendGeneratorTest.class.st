Class {
	#name : #GenBufferingSuspendGeneratorTest,
	#superclass : #GenPharoGeneratorTest,
	#category : #'GeneratorExperiments-Tests-Generators'
}

{ #category : #accessing }
GenBufferingSuspendGeneratorTest >> generatorClass [ 
	^ GenBufferingSuspendGenerator
]

{ #category : #tests }
GenBufferingSuspendGeneratorTest >> testErrorPropagation [
	"Ensure that errors in the generator block are properly propagated"

	| generator |
	generator := self generatorClass
		on: [ :g | 
			g yield: 1.
			g error: 'yo' ].
	"Original test assumes no buffering - here tests are moved to the next which cannot get a value"
	self should: [ generator next. generator next. ] raise: Error
]

{ #category : #tests }
GenBufferingSuspendGeneratorTest >> testMoreThanSingleBufferFill [
	"Buffer size is 100, fill buffer more than once, and do not fill it completely at last"
	| gen |
	gen := GenBufferingSuspendGenerator on: [ :g | 1 to: 10017 do: [:elem | g yield: elem]].
	self assert: gen contents equals: (1 to: 10017)
]
