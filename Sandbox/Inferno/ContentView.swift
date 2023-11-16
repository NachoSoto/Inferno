//
// ContentView.swift
// Inferno
// https://www.github.com/twostraws/Inferno
// See LICENSE for license information.
//

import SwiftUI

/// Shows a list of all available shaders, navigating to the various previewing
/// views depending on which one is shown.
struct ContentView: View {
    /// The currently selected list item. This is only used so that
    /// we automatically select WelcomeView on launch.
    @State private var selection: Int? = 0

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink("Home", destination: WelcomeView.init)
                    .tag(0)

                Section("Simple Transformation") {
                    ForEach(SimpleTransformationShader.shaders) { shader in
                        NavigationLink(value: shader) {
                            Text(shader.name)
                        }
                    }
                }
                .nonCollapsible()

                Section("Animated") {
                    ForEach(TimeTransformationShader.shaders) { shader in
                        NavigationLink(value: shader) {
                            Text(shader.name)
                        }
                    }
                }
                .nonCollapsible()

                Section("Touchable") {
                    ForEach(TouchTransformationShader.shaders) { shader in
                        NavigationLink(value: shader) {
                            Text(shader.name)
                        }
                    }
                }
                .nonCollapsible()

                Section("Transitions") {
                    ForEach(TransitionShader.shaders) { shader in
                        NavigationLink(value: shader) {
                            Text(shader.name)
                        }
                    }
                }
                .nonCollapsible()

                Section("Generation") {
                    ForEach(GenerativeShader.shaders) { shader in
                        NavigationLink(value: shader) {
                            Text(shader.name)
                        }
                    }
                }
                .nonCollapsible()
            }
            .navigationTitle("Inferno Sandbox")
            .navigationDestination(for: SimpleTransformationShader.self) { shader in
                // SwiftUI tries to reuse views here, which means
                // switching between shaders doesn't trigger `onAppear()`
                // and so doesn't reset the value slider.
                SimpleTransformationPreview(shader: shader).id(UUID())
            }
            .navigationDestination(for: TimeTransformationShader.self, destination: TimeTransformationPreview.init)
            .navigationDestination(for: TouchTransformationShader.self) { shader in
                // SwiftUI tries to reuse views here, which means
                // switching between shaders doesn't trigger `onAppear()`
                // and so doesn't reset the value slider.
                TouchTransformationPreview(shader: shader).id(UUID())
            }
            .navigationDestination(for: TransitionShader.self) { shader in
                // SwiftUI tries to reuse views here, which causes
                // switching between transitions to behave
                // strangely. So, we force a random UUID every
                // time we change destination.
                TransitionPreview(shader: shader).id(UUID())
            }
            .navigationDestination(for: GenerativeShader.self, destination: GenerativePreview.init)
            .frame(minWidth: 200)
        } detail: {
            WelcomeView()
        }
    }
}

private extension Section where Parent: View, Content: View, Footer: View {
    func nonCollapsible() -> some View {
        #if macOS
        self.collapsible(false)
        #else
        return self
        #endif
    }
}

#Preview {
    ContentView()
}
