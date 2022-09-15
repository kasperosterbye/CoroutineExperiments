"
An AAA_GeneratorTest is a test class for testing the behavior of AAA_Generator
"
Class {
	#name : #GenFullGeneratorTest,
	#superclass : #GenReducedGeneratorTest,
	#category : #'GeneratorExperiments-Tests'
}

{ #category : #accessing }
GenFullGeneratorTest class >> packageNamesUnderTest [
	^ #('Generator')
]

{ #category : #generators }
GenFullGeneratorTest >> fibonacciSequence [
	"Yields an infinite sequence of fibonacci numbers."
	
	^ self generatorClass on: [ :generator |
		| a b |
		a := 0. b := 1.
		[ a := b + (b := a).
		  generator yield: a ]
			repeat ]
]

{ #category : #generators }
GenFullGeneratorTest >> numbersBetween: aStartInteger and: aStopInteger [
	"Yields the nubmers between aStartInteger and aStopInteger."
	
	^ self generatorClass on: [ :generator |
		aStartInteger to: aStopInteger 
			do: [ :value | generator yield: value ] ]
]

{ #category : #tests }
GenFullGeneratorTest >> testEnsure [
	| generator |
	generator := self generatorClass
		on: [ :g | 
			[ g
				yield: 1;
				yield: 2 ]
				ensure: [ g yield: 3 ] ].
	self assert: generator upToEnd asArray equals: #(1 2 3)
]

{ #category : #tests }
GenFullGeneratorTest >> testErrorPropagation [
	"Ensure that errors in the generator block are properly propagated"

	| generator |
	generator := self generatorClass
		on: [ :g | 
			g yield: 1.
			g error: 'yo' ].
	self should: [ generator next ] raise: Error
]

{ #category : #tests }
GenFullGeneratorTest >> testReset [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator next equals: 1.
	self assert: generator next equals: 2.
	generator reset.
	self assert: generator next equals: 1.
	self assert: generator next equals: 2.
	self assert: generator next equals: 3.
	self assert: generator next equals: nil.
	generator reset.
	self assert: generator next equals: 1
]

{ #category : #tests }
GenFullGeneratorTest >> testResetUnwind [
	"Just like close, just using reset"

	| generator doEnsure notEnsure |
	doEnsure := notEnsure := 0.
	[ generator := self generatorClass
		on: [ :g | 
			[ g
				yield: 1;
				yield: 2 ]
				ensure: [ doEnsure := doEnsure + 1 ] ].
		self
			assert: doEnsure equals: 0;
			assert: notEnsure equals: 0.
		self assert: generator peek equals: 1.
		self
			assert: doEnsure equals: 0;
			assert: notEnsure equals: 0.
		generator reset.
		self
			assert: doEnsure equals: 1;
			assert: notEnsure equals: 0 ]
	ensure: [ notEnsure := notEnsure + 1 ].
	self
		assert: doEnsure equals: 1;
		assert: notEnsure equals: 1
]
