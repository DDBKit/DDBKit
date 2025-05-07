//
//  Description.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation

public struct Description: MessageEmbedComponent {
	var text: String
	
	// may consider removing this
	@_disfavoredOverload
	public init(
		@GenericBuilder<Text> components: () -> GenericTuple<Text>
	) {
		self.text = components().values.reduce(
			"",
			{ partialResult, txt in
				return partialResult
					+ txt.textualRepresentation
					.trimmingCharacters(in: .newlines) + "\n"
			}
		).trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	public init(_ txt: String) {
		self.text = txt
	}
	public init(
		@MessageContentBuilder
		components: () -> [MessageContentComponent]
	) {
		self.text = components().reduce("") { partialResult, component in
			return partialResult + component.textualRepresentation
		}
		.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
