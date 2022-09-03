Class {
	#name : #SimExponential,
	#superclass : #SimContinuousProbability,
	#instVars : [
		'mu'
	],
	#category : #'AA_Statistics'
}

{ #category : #'instance creation' }
SimExponential class >> mean: p [
        ^self parameter: 1.0/p
]

{ #category : #'instance creation' }
SimExponential class >> parameter:  p [
         
        p > 0.0
                ifTrue: [^self new setParameter: p]
                ifFalse: [self error: 'The probability parameter must be greater than 0.0']
]

{ #category : #'probability functions' }
SimExponential >> density: x [
        x > 0.0
                ifTrue: [^mu * (mu*x) negated exp]
                ifFalse: [^0.0]
]

{ #category : #'probability functions' }
SimExponential >> distribution: anInterval [
        anInterval last <= 0.0
                ifTrue: [^0.0]
                ifFalse: [^1.0 - (mu * anInterval last) negated exp - (anInterval first > 0.0 ifTrue: [self distribution: (0.0 to: anInterval first)] ifFalse: [0.0])]
]

{ #category : #private }
SimExponential >> inverseDistribution: x [
        ^ x ln negated / mu
]

{ #category : #accessing }
SimExponential >> mean [
        ^1.0/mu
]

{ #category : #private }
SimExponential >> setParameter: p [
        mu := p
]

{ #category : #accessing }
SimExponential >> variance [
        ^1.0/(mu*mu)
]
