# Путь к тулчейну
if (DEFINED ENV{ARM_TOOLCHAIN_PATH})
    SET(TOOLCHAIN_DIR $ENV{ARM_TOOLCHAIN_PATH})
else ()
    message(FATAL_ERROR "Please set ARM_TOOLCHAIN_PATH environment value")
endif ()

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)


# Другие полезные пути
SET(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_DIR}/bin)

if (WIN32)
    SET(EXE_SUFFIX ".exe")
else ()
    SET(EXE_SUFFIX "")
endif ()
# Компиляторы
SET(CMAKE_C_COMPILER "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-gcc${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_CXX_COMPILER "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-g++${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_ASM_COMPILER "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-gcc${EXE_SUFFIX}" CACHE INTERNAL "")
# objcopy и objdump для создания хексов и бинариков
SET(CMAKE_OBJCOPY "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-objcopy${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_OBJDUMP "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-objdump${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_SIZE "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-size${EXE_SUFFIX}" CACHE INTERNAL "")

# Включаем ассемблер
ENABLE_LANGUAGE(ASM)

# Установка HSE_VALUE
if (NOT HSE_VALUE)
    message(STATUS "Setting HSE to default")
else ()
    message(STATUS "Setting HSE to ${HSE_VALUE}")
    ADD_DEFINITIONS("-DHSE_VALUE=${HSE_VALUE}")

endif ()

# Флаги компиляторов, тут можно подкрутить
SET(CMAKE_C_FLAGS "-ffinite-math-only -MMD -MP -Wall -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mthumb -mfloat-abi=soft -fno-strict-aliasing -fdata-sections -ffunction-sections  -std=gnu99" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "-ffinite-math-only -MMD -MP -Wall -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mthumb -mfloat-abi=soft -fno-strict-aliasing -fdata-sections -ffunction-sections -std=c++11" CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_EXE_LINKER_FLAGS "--specs=nosys.specs --specs=nano.specs -Wl,--gc-sections" CACHE INTERNAL "exe link flags")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)


SET(STARTUP_SOURCES
        startup/startup_stm32f417xx.s
        )

SET(CMSIS_INCLUDE_DIR
        drivers/CMSIS/Include/
        drivers/CMSIS/Device/ST/STM32F4xx/Include
        )


# Дефайны
add_definitions(-DHSI_VALUE=25000000UL)
add_definitions(-DLSI_VALUE=32000U)


