"
I am a playground class
"
Class {
	#name : #GenPlaygroundClass,
	#superclass : #Object,
	#instVars : [
		'tmp',
		'first'
	],
	#category : #'GeneratorExperiments-Performance'
}

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> aaa [
	| b |
	Transcript log: 'Pre aaa'.
	b := [ |x| x := 99. 
		Transcript log: 'block 1'.
		x < 100 ifTrue: [ thisContext sender resume: x]. 
		Transcript log: 'block 2'.
		88 ].
	Transcript log: 'Post aaa'.
	^ b
]

{ #category : #'accessing - token' }
GenPlaygroundClass >> bar [
	"this code throws a cannotReturn: error. One cannot resume a method call which has already
	been returned (which is reasonable as it would break stack dicepline"
	tmp ifNil: [ tmp := self bar: 'Bar: ' ].
	tmp resume
]

{ #category : #'accessing - token' }
GenPlaygroundClass >> bar: string [
	| tc i|
	i := 1000.
	tc := thisContext copy.
	i := i +1.
	Transcript log: string, i asString.
	^ tc
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> baselineMethodCall [
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> check7Return [
	^ self return7byContext
]

{ #category : #options }
GenPlaygroundClass >> foo [
	"Repeated evaluation of the returned block illustrates that the foo instance activation is kept alive"
	| i |
	i := 100.
	^ [ i := i + 1. Transcript log: i asString ]
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> generatorCycles: n [
	| co |
	co := Generator on: [ :cr | n timesRepeat: [ cr yield: 99 ] ].
	n timesRepeat: [ co next ].
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> hiresRes [
	| x y |
	x := Smalltalk highResClock.
	y := Smalltalk highResClock.
	^ y-x
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> level1 [
	Transcript log: 'Level 1 ->'.
	self level2.
	Transcript log: 'Level 1 <-'.
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> level2 [
	Transcript log: 'Level 2 ->'.
	self level3.
	Transcript log: 'Level 2 <-'.
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> level3 [
	Transcript log: 'Level 3 ->'.
	self level4.
	Transcript log: 'Level 3 <-'.
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> level4 [
	Transcript log: 'Level 4 ->'.
	1halt.
	tmp resume: 99.
	Transcript log: 'Level 4 <-'.
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> levels [
	| x |
	Transcript log: 'Levels ->'.
	[tmp := thisContext. x := self level1] value.
	Transcript log: 'Levels <- ', x printString.
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> levelsWithGoto [
	| x pc|
	Transcript log: 'Levels ->'.
	tmp := thisContext.
	pc := tmp pc.
	x := self level1.
	Transcript log: 'Levels <- ', x printString.
	first ifNotNil: [ ^ self ].
	first := #STOP.
	thisContext pc: pc.
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> rawStream: n [
	(1 to: n) readStreamDo: [ :s | s next ]
]

{ #category : #'accessing - token' }
GenPlaygroundClass >> resumeAContext [
	"This shows that one can resule a context as long as it is still active"
	Transcript log: '1) Pre resume'.
	self resumeAContext: thisContext.
	Transcript log: '1) Post resume'
]

{ #category : #'accessing - token' }
GenPlaygroundClass >> resumeAContext: ctx [
	Transcript log: '2) Pre resume'.
	ctx resume.
	Transcript log: '2) Post resume'
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> return7byContext [
	thisContext return: 7.
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> return7normally [
	^7
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> suspendAttachCycles: n [
	| co |
	co := GenCoroutine new on: [ :cr | n timesRepeat: [ cr suspend ] ].
	n timesRepeat: [ co attach ].
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> withThisContext [
	^thisContext
]

{ #category : #'as yet unclassified' }
GenPlaygroundClass >> withThisContextSender [
	^thisContext sender
]
