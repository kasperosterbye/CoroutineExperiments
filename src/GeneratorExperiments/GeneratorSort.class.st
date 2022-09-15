"
I am an implementation of merge sort, where the merge is done using generators
"
Class {
	#name : #GeneratorSort,
	#superclass : #Object,
	#instVars : [
		'generatorClass'
	],
	#category : #'GeneratorExperiments-Performance'
}

{ #category : #accessing }
GeneratorSort >> generatorClass [

	^ generatorClass
]

{ #category : #accessing }
GeneratorSort >> generatorClass: anObject [

	generatorClass := anObject
]

{ #category : #sorting }
GeneratorSort >> merge: gen1 and: gen2 [
	"return a generator which merge gen1 and gen2"
	gen1 atEnd ifTrue: [ ^ gen2 ].
	gen2 atEnd ifTrue: [ ^ gen2 ].
	^ self generatorClass on: [ :gen |
		"as long both are not empty"
		[ gen1 atEnd or: [ gen2 atEnd] ]
			whileFalse: [ | next |
				next := gen1 peek < gen2 peek
					ifTrue: [ gen1 next]
					ifFalse: [ gen2 next].
				gen yield: next.
				 ].
		"One of them will be empty, only one of the loops will run"
		[ gen1 atEnd ] whileFalse:[ gen yield: gen1 next ].
		[ gen2 atEnd ] whileFalse:[ gen yield: gen2 next ]
	]
]

{ #category : #sorting }
GeneratorSort >> sort: anArray [
	| gen col |
	gen := self sort: anArray from: 1 to: anArray size.
	col := OrderedCollection new.
	[ gen atEnd ] whileFalse: [ col add: (gen next) ].
	^ col asArray
]

{ #category : #sorting }
GeneratorSort >> sort: anArray from: first to: last [
	| mid |
	first > last ifTrue: [ ^ self generatorClass  on: [ :gen | ] ].
	first = last ifTrue: [ ^ self generatorClass on: [ :gen | gen yield: (anArray at: first) ] ].
	mid := (first + ((last - first) / 2)) asInteger.
	^ self 
		merge: (self sort: anArray from: first to: mid) 
		and: (self sort: anArray from: mid+1 to: last)
	
]

{ #category : #tests }
GeneratorSort >> testSize: n [
	| rnd arr |
	rnd := Random new.
	arr := Array new: n.
	1 to: n do: [ :i | arr at: i put: (rnd nextIntegerBetween: 1 and: 1000) ].
	^ arr
]
