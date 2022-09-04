Class {
	#name : #AAA,
	#superclass : #Object,
	#instVars : [
		'tmp'
	],
	#category : #'AA_Experiments'
}

{ #category : #'accessing - token' }
AAA >> bar [
	"this code throws a cannotReturn: error. One cannot resume a method call which has already
	been returned (which is reasonable as it would break stack dicepline"
	tmp ifNil: [ tmp := self bar: 'Bar: ' ].
	tmp resume
]

{ #category : #'accessing - token' }
AAA >> bar: string [
	| tc i|
	i := 1000.
	tc := thisContext copy.
	i := i +1.
	Transcript log: string, i asString.
	^ tc
]

{ #category : #options }
AAA >> foo [
	"Repeated evaluation of the returned block illustrates that the foo instance activation is kept alive"
	| i |
	i := 100.
	^ [ i := i + 1. Transcript log: i asString ]
]

{ #category : #'accessing - token' }
AAA >> resumeAContext [
	"This shows that one can resule a context as long as it is still active"
	Transcript log: '1) Pre resume'.
	self resumeAContext: thisContext.
	Transcript log: '1) Post resume'
]

{ #category : #'accessing - token' }
AAA >> resumeAContext: ctx [
	Transcript log: '2) Pre resume'.
	ctx resume.
	Transcript log: '2) Post resume'
]
