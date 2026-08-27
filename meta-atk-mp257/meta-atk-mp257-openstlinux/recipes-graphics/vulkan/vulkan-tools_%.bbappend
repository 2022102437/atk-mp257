# Build vkcube from vulkan-tools
EXTRA_OECMAKE:remove = "-DBUILD_CUBE=OFF"
EXTRA_OECMAKE:append = " -DBUILD_CUBE=ON"

# glslang required to build vkcube shaders
DEPENDS:append = " glslang-native"
EXTRA_OECMAKE:append = " -DGLSLANG_INSTALL_DIR=${STAGING_DIR_NATIVE}"

# Force winsys to Wayland
EXTRA_OECMAKE:append = " -DCUBE_WSI_SELECTION=WAYLAND"

# pkgconfig needed by cmake to look for dependencies (wayland-native and wayland-protocols added)
inherit pkgconfig
PACKAGECONFIG[wayland] = "-DBUILD_WSI_WAYLAND_SUPPORT=ON, -DBUILD_WSI_WAYLAND_SUPPORT=OFF, wayland wayland-native wayland-protocols"

do_configure:prepend() {
    if [ -e "${STAGING_LIBDIR_NATIVE}/pkgconfig/wayland-scanner.pc" ]; then
        sed -i -e "s|wayland_scanner=.*$|wayland_scanner=${STAGING_BINDIR_NATIVE}/wayland-scanner|" "${STAGING_LIBDIR_NATIVE}/pkgconfig/wayland-scanner.pc"
    fi
    if [ -e "${STAGING_LIBDIR}/pkgconfig/wayland-scanner.pc" ]; then
        sed -i -e "s|wayland_scanner=.*$|wayland_scanner=${STAGING_BINDIR_NATIVE}/wayland-scanner|" "${STAGING_LIBDIR}/pkgconfig/wayland-scanner.pc"
    fi
}
