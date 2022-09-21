"
I implement my generator using a process based coroutine
"
Class {
	#name : #GenCoSuspendGenerator,
	#superclass : #GenCoGenerator,
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #initialization }
GenCoSuspendGenerator >> coroutineClass [
	^ GenSuspendCoroutine 
]
