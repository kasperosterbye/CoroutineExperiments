Class {
	#name : #AAA,
	#superclass : #Object,
	#category : #'AA_Experiments'
}

{ #category : #'accessing - token' }
AAA >> bar [
	^ self foo
]

{ #category : #options }
AAA >> foo [
	| block |
	block := [ thisContext halt ].
	block value.
]
