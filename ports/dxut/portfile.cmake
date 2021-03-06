vcpkg_check_linkage(ONLY_STATIC_LIBRARY ONLY_DYNAMIC_CRT)
vcpkg_fail_port_install(ON_ARCH arm)

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO microsoft/DXUT
	REF d6e8ef60b35b8d3b97684bd6b3cee88f8ba81a3f
	SHA512 2ac1ac4416dbf7ae0e8a9e1e95fbd8bede126ac6dc4e919f4bd1131d10f3a01e007aff2f770ace9cbf48093ff76d8b89c4b78b734658028be62e1412f44078ae
)

IF (TRIPLET_SYSTEM_ARCH MATCHES "x86")
	SET(BUILD_ARCH "Win32")
ELSE()
	SET(BUILD_ARCH ${TRIPLET_SYSTEM_ARCH})
ENDIF()

vcpkg_build_msbuild(
	PROJECT_PATH "${SOURCE_PATH}/DXUT_2015.sln"
	PLATFORM "${BUILD_ARCH}"
)

file(INSTALL
	"${SOURCE_PATH}/Core/"
	"${SOURCE_PATH}/Optional/"
	DESTINATION "${CURRENT_PACKAGES_DIR}/include"
	FILES_MATCHING PATTERN "*.h"
)
file(REMOVE_RECURSE
	"${CURRENT_PACKAGES_DIR}/include/Bin")

file(INSTALL
	"${SOURCE_PATH}/Core/Bin/Desktop_2015/${BUILD_ARCH}/Release/DXUT.lib"
	"${SOURCE_PATH}/Optional/Bin/Desktop_2015/${BUILD_ARCH}/Release/DXUTOpt.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/lib")

file(INSTALL
	"${SOURCE_PATH}/Core/Bin/Desktop_2015/${BUILD_ARCH}/Debug/DXUT.lib"
	"${SOURCE_PATH}/Optional/Bin/Desktop_2015/${BUILD_ARCH}/Debug/DXUTOpt.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/MIT.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
