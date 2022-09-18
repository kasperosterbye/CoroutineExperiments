"
I implement the coroutine using a swap coroutine
"
Class {
	#name : #GenCoSwapGenerator,
	#superclass : #GenCoGenerator,
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #initialization }
GenCoSwapGenerator >> coroutineClass [
	^ GenSwapCoroutine
]
