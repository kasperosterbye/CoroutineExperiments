"
An AAA_GeneratorTest is a test class for testing the behavior of AAA_Generator
"
Class {
	#name : #GenPharoGeneratorTest,
	#superclass : #TestCase,
	#category : #'GeneratorExperiments-Tests-Generators'
}

{ #category : #accessing }
GenPharoGeneratorTest class >> packageNamesUnderTest [
	^ #('Generator')
]

{ #category : #generators }
GenPharoGeneratorTest >> fibonacciSequence [
	"Yields an infinite sequence of fibonacci numbers."
	
	^ self generatorClass on: [ :generator |
		| a b |
		a := 0. b := 1.
		[ a := b + (b := a).
		  generator yield: a ]
			repeat ]
]

{ #category : #accessing }
GenPharoGeneratorTest >> generatorClass [
	^ Generator
]

{ #category : #generators }
GenPharoGeneratorTest >> numbersBetween: aStartInteger and: aStopInteger [
	"Yields the nubmers between aStartInteger and aStopInteger."
	
	^ self generatorClass on: [ :generator |
		aStartInteger to: aStopInteger 
			do: [ :value | generator yield: value ] ]
]

{ #category : #tests }
GenPharoGeneratorTest >> testAtEnd [
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
GenPharoGeneratorTest >> testClose [
	| generator doEnsure notEnsure |
	doEnsure := notEnsure := 0.
	[ generator := Generator
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
GenPharoGeneratorTest >> testCloseCloses [
	| gen |
	gen := self numbersBetween: 1 and: 3.
	gen next.
	gen close.
	self assert: gen atEnd
	
]

{ #category : #tests }
GenPharoGeneratorTest >> testContents [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator contents equals: #(1 2 3)
]

{ #category : #tests }
GenPharoGeneratorTest >> testEmpty [
	| generator |
	generator := self generatorClass on: [ :g | ].
	self assert: generator atEnd.
	self assert: generator peek isNil.
	self assert: generator next isNil
]

{ #category : #tests }
GenPharoGeneratorTest >> testEnsure [
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
GenPharoGeneratorTest >> testErrorPropagation [
	"Ensure that errors in the generator block are properly propagated"

	| generator |
	generator := self generatorClass
		on: [ :g | 
			g yield: 1.
			g error: 'yo' ].
	self should: [ generator next ] raise: Error
]

{ #category : #tests }
GenPharoGeneratorTest >> testFibonacci [
	| generator |
	generator := self fibonacciSequence.
	self assert: (generator next: 10) asArray equals: #(1 1 2 3 5 8 13 21 34 55)
]

{ #category : #tests }
GenPharoGeneratorTest >> testNested [
	| g1 g2 |
	g1 := self generatorClass  on: [ :gg | gg yield: 10.].		
	g2 := self generatorClass on: [ :g | g yield: g1 next].
	self assert: g2 atEnd not.
	self assert: g2 next equals: 10
]

{ #category : #tests }
GenPharoGeneratorTest >> testNext [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator next equals: 1.
	self assert: generator next equals: 2.
	self assert: generator next equals: 3.
	self assert: generator next isNil
]

{ #category : #tests }
GenPharoGeneratorTest >> testPeek [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator peek equals: 1.
	self assert: generator peek equals: 1.
	generator next.
	self assert: generator peek equals: 2
]

{ #category : #tests }
GenPharoGeneratorTest >> testReset [
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
GenPharoGeneratorTest >> testResetUnwind [
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

{ #category : #tests }
GenPharoGeneratorTest >> testSimple [
	| generator |
	generator := self generatorClass
		on: [ :g | g yield: 1; yield: 2 ].
	self assert: generator upToEnd asArray equals: #(1 2)
]

{ #category : #tests }
GenPharoGeneratorTest >> testSort [
	| sorter unsorted |
	sorter := GeneratorSort new.
	unsorted := #( 5 3 8 9 6 2).
	sorter generatorClass: self generatorClass.
	self assert: (sorter sort: unsorted) equals: #(2 3 5 6 8 9).
		
]
