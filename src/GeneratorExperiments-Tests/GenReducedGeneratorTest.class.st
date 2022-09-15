Class {
	#name : #GenReducedGeneratorTest,
	#superclass : #TestCase,
	#category : #'GeneratorExperiments-Tests'
}

{ #category : #accessing }
GenReducedGeneratorTest class >> packageNamesUnderTest [
	^ #('Generator')
]

{ #category : #generators }
GenReducedGeneratorTest >> fibonacciSequence [
	"Yields an infinite sequence of fibonacci numbers."
	
	^ self generatorClass on: [ :generator |
		| a b |
		a := 0. b := 1.
		[ a := b + (b := a).
		  generator yield: a ]
			repeat ]
]

{ #category : #accessing }
GenReducedGeneratorTest >> generatorClass [
	^ Generator
]

{ #category : #generators }
GenReducedGeneratorTest >> numbersBetween: aStartInteger and: aStopInteger [
	"Yields the nubmers between aStartInteger and aStopInteger."
	
	^ self generatorClass on: [ :generator |
		aStartInteger to: aStopInteger 
			do: [ :value | generator yield: value ] ]
]

{ #category : #tests }
GenReducedGeneratorTest >> testAtEnd [
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
GenReducedGeneratorTest >> testContents [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator contents equals: #(1 2 3)
]

{ #category : #tests }
GenReducedGeneratorTest >> testEmpty [
	| generator |
	generator := self generatorClass on: [ :g | ].
	self assert: generator atEnd.
	self assert: generator peek isNil.
	self assert: generator next isNil
]

{ #category : #tests }
GenReducedGeneratorTest >> testFibonacci [
	| generator |
	generator := self fibonacciSequence.
	self assert: (generator next: 10) asArray equals: #(1 1 2 3 5 8 13 21 34 55)
]

{ #category : #tests }
GenReducedGeneratorTest >> testNested [
	| g1 g2 |
	g1 := self generatorClass  on: [ :gg | gg yield: 10.].		
	g2 := self generatorClass on: [ :g | g yield: g1 next].
	self assert: g2 atEnd not.
	self assert: g2 next equals: 10
]

{ #category : #tests }
GenReducedGeneratorTest >> testNext [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator next equals: 1.
	self assert: generator next equals: 2.
	self assert: generator next equals: 3.
	self assert: generator next isNil
]

{ #category : #tests }
GenReducedGeneratorTest >> testPeek [
	| generator |
	generator := self numbersBetween: 1 and: 3.
	self assert: generator peek equals: 1.
	self assert: generator peek equals: 1.
	generator next.
	self assert: generator peek equals: 2
]

{ #category : #tests }
GenReducedGeneratorTest >> testSimple [
	| generator |
	generator := self generatorClass
		on: [ :g | g yield: 1; yield: 2 ].
	self assert: generator upToEnd asArray equals: #(1 2)
]

{ #category : #tests }
GenReducedGeneratorTest >> testSort [
	| sorter unsorted |
	sorter := GeneratorSort new.
	unsorted := #( 5 3 8 9 6 2).
	sorter generatorClass: self generatorClass.
	self assert: (sorter sort: unsorted) equals: #(2 3 5 6 8 9).
		
]
