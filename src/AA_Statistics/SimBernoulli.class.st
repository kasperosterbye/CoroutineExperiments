"
Does an event occur?

density function answers the probability of occurrence of one of two events
"
Class {
	#name : #SimBernoulli,
	#superclass : #SimDiscreteProbability,
	#instVars : [
		'prob'
	],
	#category : #'AA_Statistics'
}

{ #category : #Examples }
SimBernoulli class >> Cardgame [

        "is the first draw of a card an ace?"
        (Bernoulli parameter: 4/52) next

        "does a car arrive in the next second?"

        "will a machine break down today?"
]

{ #category : #'instance creation' }
SimBernoulli class >> parameter: aNumber [
        (aNumber between: 0.0 and: 1.0)
                ifTrue: [^self new setParameter: aNumber]
                ifFalse: [^self error: 'The probability must be between 0.0 and 1.0']
]

{ #category : #'probability functions' }
SimBernoulli >> density: x [

        x=1 ifTrue: [^prob].
        x=0 ifTrue: [^1.0-prob].
        self error: ' outcomes of a Bernoulli can only be 1 or 0'
]

{ #category : #private }
SimBernoulli >> inverseDistribution: x [

        x <= prob
                ifTrue: [^1]
                ifFalse: [^0]
]

{ #category : #accessing }
SimBernoulli >> mean [
        ^prob
]

{ #category : #private }
SimBernoulli >> setParameter: aNumber [
        prob :=aNumber
]

{ #category : #accessing }
SimBernoulli >> variance [
        ^prob * (1.0 - prob)
]
