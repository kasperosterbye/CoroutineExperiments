"
how many events occur in a unit time?
        used for sampling potential demands by customers for service

        The Poisson is typically the rate at which the service is provided.

        density function determines the probability that, in a unit interval, x events will occur.

"
Class {
	#name : #SimPoisson,
	#superclass : #SimDiscreteProbability,
	#instVars : [
		'mu'
	],
	#category : #'AA_Statistics'
}

{ #category : #'instance creation' }
SimPoisson class >> mean: p [

        p > 0.0
                ifTrue: [^self new setMean: p]
                ifFalse: [self error: 'mean must be greater than 0.0']
]

{ #category : #'probability functions' }
SimPoisson >> density: x [

        x >= 0
                ifTrue: [^ ((mu raisedTo: x) * (mu negated exp)) / x factorial]
                ifFalse: [^0.0]
]

{ #category : #accessing }
SimPoisson >> mean [
        ^mu
]

{ #category : #'random sampling' }
SimPoisson >> next [
        | p n q |
        p := mu negated exp.
        n := 0.
        q := 1.0.
        [q := q * U next.
         q >= p]
                whileTrue: [n := n + 1].
        ^n
]

{ #category : #private }
SimPoisson >> setMean: p [
        mu := p
]

{ #category : #accessing }
SimPoisson >> variance [
        ^mu
]
