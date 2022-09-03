"
How many repeated, independent Bernoulli trials are needed before the first success is obtained?

e.g., how many seconds before the next car arrives (as versus how many cars arrive in the next 20 sec as in a binomial question)
"
Class {
	#name : #SimGeometric,
	#superclass : #SimBernoulli,
	#category : #'AA_Statistics'
}

{ #category : #Examples }
SimGeometric class >> CarsArriving [

        | sample |
         
        "two cars arrive every minute"
        sample := Geometric mean: 60/2.

        "what is the probability that it will take 30 sec before the next car arrives?"
        sample density: 30.

        "Did the next car arrive in 30 to 40 seconds?"
        sample distribution: (30 to: 40)
]

{ #category : #'instance creation' }
SimGeometric class >> mean: m [

        ^self parameter: m
]

{ #category : #'probability functions' }
SimGeometric >> density: x [

        x>0 ifTrue: [^prob * ((1.0 - prob) raisedTo: x-1)]
                ifFalse: [^0.0]
]

{ #category : #private }
SimGeometric >> inverseDistribution: x [

        ^(x ln / (1.0 - prob) ln) ceiling
]

{ #category : #accessing }
SimGeometric >> mean [
        ^ 1.0 / prob
]

{ #category : #accessing }
SimGeometric >> variance [
        ^ (1.0 - prob) / prob squared
]
