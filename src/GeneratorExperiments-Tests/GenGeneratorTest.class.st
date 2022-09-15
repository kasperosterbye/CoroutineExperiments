"
An AAA_GeneratorTest is a test class for testing the behavior of AAA_Generator
"
Class {
	#name : #GenGeneratorTest,
	#superclass : #TestCase,
	#category : #'GeneratorExperiments-Tests'
}

{ #category : #accessing }
GenGeneratorTest class >> packageNamesUnderTest [
	^ #('Generator')
]

{ #category : #generators }
GenGeneratorTest >> fibonacciSequence [
	"Yields an infinite sequence of fibonacci numbers."
	
	^ GenGenerator on: [ :generator |
		| a b |
		a := 0. b := 1.
		[ a := b + (b := a).
		  generator yield: a ]
			repeat ]
]

{ #category : #generators }
GenGeneratorTest >> numbersBetween: aStartInteger and: aStopInteger [
	"Yields the nubmers between aStartInteger and aStopInteger."
	
	^ GenGenerator on: [ :generator |
		aStartInteger to: aStopInteger 
			do: [ :value | generator yield: value ] ]
]

{ #category : #tests }
GenGeneratorTest >> testAtEnd [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self deny: generator atEnd.
	generator next.
	self deny: generator atEnd.
	generator next.
	self deny: generator atEnd.
	generator next.
	self assert: generator atEnd
]

{ #category : #tests }
GenGeneratorTest >> testClose [
	| generator doEnsure notEnsure |
	doEnsure := notEnsure := 0.
	[ generator := GenGenerator
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
		generator close.
		self
			assert: doEnsure equals: 1;
			assert: notEnsure equals: 0 ]
	ensure: [ notEnsure := notEnsure + 1 ].
	self
		assert: doEnsure equals: 1;
		assert: notEnsure equals: 1
]

{ #category : #tests }
GenGeneratorTest >> testContents [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator contents equals: #(1 2 3)
]

{ #category : #tests }
GenGeneratorTest >> testEmpty [
	| generator |
	generator := GenGenerator on: [ :g | ].
	self assert: generator atEnd.
	self assert: generator peek isNil.
	self assert: generator next isNil
]

{ #category : #tests }
GenGeneratorTest >> testEnsure [
	| generator |
	generator := GenGenerator
		on: [ :g | 
			[ g
				yield: 1;
				yield: 2 ]
				ensure: [ g yield: 3 ] ].
	self assert: generator upToEnd asArray equals: #(1 2 3)
]

{ #category : #tests }
GenGeneratorTest >> testErrorPropagation [
	"Ensure that errors in the generator block are properly propagated"

	| generator |
	generator := GenGenerator
		on: [ :g | 
			g yield: 1.
			g error: 'yo' ].
	self should: [ generator next ] raise: Error
]

{ #category : #tests }
GenGeneratorTest >> testFibonacci [
	| generator |
	generator := self fibonacciSequence.
	self assert: (generator next: 10) asArray equals: #(1 1 2 3 5 8 13 21 34 55)
]

{ #category : #tests }
GenGeneratorTest >> testNested [
	| g1 g2 |
	'-----' traceCr.
	g1 := GenGenerator  on: [ :gg | 'g1>' traceCr. gg yield: 10. '<g1' traceCr. ].		
	g2 := GenGenerator on: [ :g | | n | 
		'g2>' traceCr.
		g1 peek traceCr. n := g1 next. ('n: ', n printString) trace. g yield: n. 
		'<g2' trace.].
	self assert: g2 atEnd not.
	self assert: g2 next equals: 10
]

{ #category : #tests }
GenGeneratorTest >> testNext [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator next equals: 1.
	self assert: generator next equals: 2.
	self assert: generator next equals: 3.
	self assert: generator next isNil
]

{ #category : #tests }
GenGeneratorTest >> testPeek [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator peek equals: 1.
	self assert: generator peek equals: 1.
	generator next.
	self assert: generator peek equals: 2
]

{ #category : #tests }
GenGeneratorTest >> testReset [
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
GenGeneratorTest >> testResetUnwind [
	"Just like close, just using reset"

	| generator doEnsure notEnsure |
	doEnsure := notEnsure := 0.
	[ generator := GenGenerator
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

{ #category : #tests }
GenGeneratorTest >> testSimple [
	| generator |
	generator := GenGenerator
		on: [ :g | 
			g
				yield: 1;
				yield: 2 ].
	self assert: generator upToEnd asArray equals: #(1 2)
]
