package abi44_0_0.expo.modules.network

import android.content.Context

import abi44_0_0.expo.modules.core.BasePackage
import abi44_0_0.expo.modules.core.ExportedModule

class NetworkPackage : BasePackage() {
  override fun createExportedModules(context: Context): List<ExportedModule> =
    listOf(NetworkModule(context))
}
