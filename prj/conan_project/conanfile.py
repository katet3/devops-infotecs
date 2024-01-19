from conans import ConanFile, CMake

class MyConanProject(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    requires = "fmt/8.0.1"

    generators = "cmake"

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
