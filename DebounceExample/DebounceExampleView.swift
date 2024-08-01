//
//  DebounceExampleView.swift
//  DebounceExample
//
//  Created by Mohammed Rokon Uddin on 7/29/24.
//

import SwiftUI

struct DebounceExampleView: View {
  @OperatorState(.debounce()) private var filterText: String = ""

  var body: some View {
    ZStack {
      Color.gray.opacity(0.3)
      VStack(alignment: .leading) {
        Text("Input text:")
          .padding(.top, 72)
        TextEditor(text: $filterText)
          .frame(height: 100)

        Text("Debounced text:")
          .padding(.top, 16)
        Text(filterText)
          .padding()
          .foregroundStyle(.black)
          .frame(height: 100, alignment: .top)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(.white)

        Spacer()
      }
      .padding()
    }
    .ignoresSafeArea()
  }
}

#Preview {
  DebounceExampleView()
}
