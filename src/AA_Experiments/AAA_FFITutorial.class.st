Class {
	#name : #'AAA_FFITutorial',
	#superclass : #Object,
	#category : #'AA_Experiments'
}

{ #category : #'as yet unclassified' }
AAA_FFITutorial class >> ticksSinceStart [ 
  ^ self ffiCall: #( uint clock() ) library: 'libc.dylib'


]
