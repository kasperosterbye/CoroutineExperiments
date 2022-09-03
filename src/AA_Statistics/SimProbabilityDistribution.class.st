"
Initialization of the class is needed.  Use

        ProbabilityDistribution initialize
"
Class {
	#name : #SimProbabilityDistribution,
	#superclass : #Stream,
	#classVars : [
		'U'
	],
	#category : #'AA_Statistics'
}

{ #category : #'class initialization' }
SimProbabilityDistribution class >> initialize [
        "Uniformly distributed random numbers in the range [o,1]."

        U := Random new
]

{ #category : #'instance creation' }
SimProbabilityDistribution class >> new [
         
        ^self basicNew
]

{ #category : #'random sampling' }
SimProbabilityDistribution >> atEnd [
        ^false
]

{ #category : #private }
SimProbabilityDistribution >> computeSample: m outOf: n [

        m>n ifTrue: [^0.0].
        ^n factorial / (n-m) factorial
]

{ #category : #'probability functions' }
SimProbabilityDistribution >> density: x [

        self subclassResponsibility
]

{ #category : #'probability functions' }
SimProbabilityDistribution >> distribution: aCollection [

        self subclassResponsibility
]

{ #category : #private }
SimProbabilityDistribution >> inverseDistribution: x [
        self subclassResponsibility
]

{ #category : #'random sampling' }
SimProbabilityDistribution >> next [
        "This is a general random number generation method for any probability law;  use the (0,1) uniformly distributed random varible U as the value of the law's distribution function.  Obtain the next random value and then solve for the inverse.  The inverse solution is defined by the subclass."

        ^self inverseDistribution: U next
]
