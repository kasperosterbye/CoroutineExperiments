"
how many successes occurred in N trials?

density funciton answers what is the probability that x successes will occur in the next N trials?

i.e., N repeated Bernoulli trials
"
Class {
	#name : #SimBinomial,
	#superclass : #SimBernoulli,
	#instVars : [
		'N'
	],
	#category : #'AA_Statistics'
}

{ #category : #Examples }
SimBinomial class >> FlippingCoins [

        | sampleA sampleB |
        sampleA := Bernoulli parameter: 0.5.

        "Did I get heads?"
        sampleA next.

        sampleB := Binomial events: 5 mean: 2.5.
         
        "How many heads did I get in 5 trials?"
        sampleB next
]

{ #category : #'instance creation' }
SimBinomial class >> events: n mean: m [

        n truncated <= 0 ifTrue: [self error: 'number of events must be > 0'].
        ^self new events: n mean: m
]

{ #category : #'probability functions' }
SimBinomial >> density: x [

        (x between: 0 and: N)
                ifTrue: [^((self computeSample: x outOf: N) / (self computeSample: x outOf: x)) * (prob raisedTo: x)*((1.0 - prob) raisedTo: N-x)]
                ifFalse: [^0.0]
]

{ #category : #private }
SimBinomial >> events: n mean: m [

        N := n truncated.
        self setParameter: m/N
]

{ #category : #'random sampling' }
SimBinomial >> next [
         
        |t|
        t := 0.
        N timesRepeat: [t := t + super next].
        ^t
]
