"
I implement my generator using a process based coroutine
"
Class {
	#name : #GenCoSuspendpGenerator,
	#superclass : #GenCoGenerator,
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #initialization }
GenCoSuspendpGenerator >> coroutineClass [
	^ GenSuspendCoroutine 
]
