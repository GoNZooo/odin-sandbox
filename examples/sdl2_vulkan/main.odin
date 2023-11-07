package imgui_example_sdl2_vulkan

// This is an example of using the bindings with SDL2 and OpenGL 3.
// For a more complete example with comments, see:
// https://github.com/ocornut/imgui/blob/docking/examples/example_sdl2_opengl3/main.cpp

import imgui "../.."
import "../../imgui_impl_sdl2"
import "../../imgui_impl_vulkan"

import sdl "vendor:sdl2"
import vk "vendor:vulkan"

main :: proc() {
	assert(sdl.Init(sdl.INIT_EVERYTHING) == 0)
	defer sdl.Quit()

	window := sdl.CreateWindow(
		"Dear ImGui SDL2+OpenGl3 example",
		sdl.WINDOWPOS_CENTERED,
		sdl.WINDOWPOS_CENTERED,
		1280, 720,
		{.OPENGL, .RESIZABLE, .ALLOW_HIGHDPI})
	assert(window != nil)
	defer sdl.DestroyWindow(window)
}
