Extension { #name : #Context }

{ #category : #'*GeneratorExperiments' }
Context >> inspectSourceWithNextPC [
	<inspectorPresentationOrder: 20 title: 'Source'>
	pc 
		ifNil: [ ^ self method sourceCode inspectionString ]
		ifNotNil: [ ^ (self method sourceNodeForPC: pc) inspectionSourceCode ]
]
