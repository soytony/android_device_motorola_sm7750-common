// SPDX-License-Identifier: Apache-2.0

#include <android/binder_manager.h>

#include "core-impl/Configuration.h"
#include "core-impl/Module.h"

// Compile the module and its base class against the same audio-core interface.
// The stock QTI module inherits a different Module layout and cannot be loaded
// alongside Lineage's libaudioserviceexampleimpl.
extern "C" binder_status_t registerBluetoothAudioModule() {
    using aidl::android::hardware::audio::core::Module;
    // The one-argument overload creates an empty, non-null configuration, so
    // getConfig() would never initialize the Bluetooth device/mix ports.
    static const auto module = Module::createInstance(
            Module::BLUETOOTH,
            aidl::android::hardware::audio::core::internal::getConfiguration(Module::BLUETOOTH));
    if (!module) return STATUS_NO_MEMORY;
    const std::string name = std::string(Module::descriptor) + "/bluetooth";
    return AServiceManager_addService(module->asBinder().get(), name.c_str());
}
