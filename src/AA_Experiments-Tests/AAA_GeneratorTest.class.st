"
An AAA_GeneratorTest is a test class for testing the behavior of AAA_Generator
"
Class {
	#name : #'AAA_GeneratorTest',
	#superclass : #TestCase,
	#category : #'AA_Experiments-Tests'
}

{ #category : #accessing }
AAA_GeneratorTest class >> packageNamesUnderTest [
	^ #('Generator')
]

{ #category : #generators }
AAA_GeneratorTest >> fibonacciSequence [
	"Yields an infinite sequence of fibonacci numbers."
	
	^ AAA_Generator on: [ :generator |
		| a b |
		a := 0. b := 1.
		[ a := b + (b := a).
		  generator yield: a ]
			repeat ]
]

{ #category : #generators }
AAA_GeneratorTest >> numbersBetween: aStartInteger and: aStopInteger [
	"Yields the nubmers between aStartInteger and aStopInteger."
	
	^ AAA_Generator on: [ :generator |
		aStartInteger to: aStopInteger 
			do: [ :value | generator yield: value ] ]
]

{ #category : #tests }
AAA_GeneratorTest >> testAtEnd [
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
AAA_GeneratorTest >> testClose [
	| generator doEnsure notEnsure |
	doEnsure := notEnsure := 0.
	[ generator := AAA_Generator
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
AAA_GeneratorTest >> testContents [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator contents equals: #(1 2 3)
]

{ #category : #tests }
AAA_GeneratorTest >> testEmpty [
	| generator |
	generator := AAA_Generator on: [ :g | ].
	self assert: generator atEnd.
	self assert: generator peek isNil.
	self assert: generator next isNil
]

{ #category : #tests }
AAA_GeneratorTest >> testEnsure [
	| generator |
	generator := AAA_Generator
		on: [ :g | 
			[ g
				yield: 1;
				yield: 2 ]
				ensure: [ g yield: 3 ] ].
	self assert: generator upToEnd asArray equals: #(1 2 3)
]

{ #category : #tests }
AAA_GeneratorTest >> testErrorPropagation [
	"Ensure that errors in the generator block are properly propagated"

	| generator |
	generator := AAA_Generator
		on: [ :g | 
			g yield: 1.
			g error: 'yo' ].
	self should: [ generator next ] raise: Error
]

{ #category : #tests }
AAA_GeneratorTest >> testFibonacci [
	| generator |
	generator := self fibonacciSequence.
	self assert: (generator next: 10) asArray equals: #(1 1 2 3 5 8 13 21 34 55)
]

{ #category : #tests }
AAA_GeneratorTest >> testNext [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator next equals: 1.
	self assert: generator next equals: 2.
	self assert: generator next equals: 3.
	self assert: generator next isNil
]

{ #category : #tests }
AAA_GeneratorTest >> testPeek [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator peek equals: 1.
	self assert: generator peek equals: 1.
	generator next.
	self assert: generator peek equals: 2
]

{ #category : #tests }
AAA_GeneratorTest >> testReset [
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
AAA_GeneratorTest >> testResetUnwind [
	"Just like close, just using reset"

	| generator doEnsure notEnsure |
	doEnsure := notEnsure := 0.
	[ generator := AAA_Generator
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
AAA_GeneratorTest >> testSimple [
	| generator |
	generator := AAA_Generator
		on: [ :g | 
			g
				yield: 1;
				yield: 2 ].
	self assert: generator upToEnd asArray equals: #(1 2)
]
