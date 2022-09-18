"
A GenBufferTest is a test class for testing the behavior of GenBuffer
"
Class {
	#name : #GenBufferTest,
	#superclass : #TestCase,
	#instVars : [
		'buf'
	],
	#category : #'GeneratorExperiments-Tests-Generators'
}

{ #category : #running }
GenBufferTest >> setUp [
	super setUp.
	buf := GenBuffer new.
	
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
GenBufferTest >> testAdd [
	buf add: 19.
	self deny: buf isEmpty.
	self deny: buf isFull.
	self assert: buf take equals: 19.
	self assert: buf isEmpty.
	
]

{ #category : #tests }
GenBufferTest >> testCircular [
	buf := GenBuffer new: 2.
	buf add: 1; add: 2; take; add: 3.
	self assert: buf isFull.
	self assert: buf take equals: 2.
]

{ #category : #tests }
GenBufferTest >> testInitialize [
	self assert: buf isEmpty.
	self deny: buf isFull.
	
]
