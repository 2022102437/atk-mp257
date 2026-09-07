DEPENDS += " openssh-native libgcrypt-native cmake-native openssl-native"

BBCLASSEXTEND += "native"

OECMAKE_C_FLAGS = "${HOST_CC_ARCH} ${TOOLCHAIN_OPTIONS} ${TARGET_CPPFLAGS} -Wno-error=strict-overflow"

EXTRA_OECMAKE = " -DHAVE_COMPILER__FUNCTION__=1 -DWITH_EXAMPLES=0 -DWITH_SERVER=1 -DWITH_STACK_PROTECTOR=0 -DWITH_GCRYPT=0 -DWITH_PCAP=0 -DWITH_SFTP=1 -DWITH_ZLIB=0 -DLIB_SUFFIX=${@d.getVar('baselib', True).replace('lib', '')}"
